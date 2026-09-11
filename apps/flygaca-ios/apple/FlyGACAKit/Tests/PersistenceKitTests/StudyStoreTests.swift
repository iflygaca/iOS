import CoreModels
import StudyEngines
import SwiftData
import XCTest

@testable import PersistenceKit

/// StudyStore is the single durable write path — the only actor-based, SwiftData-
/// backed, hand-rolled-JSON-blob code in the package. These tests exercise it via
/// an in-memory container (no App Group, no disk, no simulator) so `swift test`
/// stays hermetic on a Mac. The parity contracts they lock down (10-most-recent
/// exam cap, best-per-bank quiz score, day-based streak) mirror the web app.
final class StudyStoreTests: XCTestCase {
    private func makeStore() throws -> StudyStore {
        let container = try Persistence.container(inMemory: true)
        return StudyStore(container: container)
    }

    private func makeQuestion(bankID: String = "bank-a", index: Int = 0, id: String = "q-1") -> Question {
        Question(
            id: id, bankID: bankID, index: index, prompt: "Prompt",
            choices: ["A", "B"], correctIndex: 0, explanation: "Because.")
    }

    private func makeQuizFile(bankID: String, questions: [Question]) -> QuizFile {
        QuizFile(
            generated: "v2", exam: .standard,
            banks: [Bank(id: bankID, title: bankID, blurb: "", source: nil, questions: questions)])
    }

    // MARK: - Exams

    func testRecordExamThenExamHistoryReturnsMostRecentFirst() async throws {
        let store = try makeStore()
        let epoch = Date(timeIntervalSince1970: 0)
        let older = SessionResult(
            total: 10, correct: 7, percent: 70, passed: false, byBank: [:],
            duration: 60, finishedAt: epoch)
        let newer = SessionResult(
            total: 10, correct: 9, percent: 90, passed: true, byBank: [:],
            duration: 60, finishedAt: epoch.addingTimeInterval(3600))

        try await store.recordExam(moduleID: "ppl-exam", result: older)
        try await store.recordExam(moduleID: "ppl-exam", result: newer)

        let history = try await store.examHistory(moduleID: "ppl-exam")
        XCTAssertEqual(history.count, 2)
        XCTAssertEqual(history.first?.percent, 90)
        XCTAssertEqual(history.last?.percent, 70)
    }

    func testExamHistoryIsCappedAtTenMostRecentPerModule() async throws {
        let store = try makeStore()
        let epoch = Date(timeIntervalSince1970: 0)
        for i in 0..<12 {
            let result = SessionResult(
                total: 10, correct: i, percent: i * 10, passed: nil, byBank: [:],
                duration: 60, finishedAt: epoch.addingTimeInterval(TimeInterval(i * 3600)))
            try await store.recordExam(moduleID: "ppl-exam", result: result)
        }
        let history = try await store.examHistory(moduleID: "ppl-exam")
        XCTAssertEqual(history.count, StudyStore.examHistoryLimit)
        // The two oldest inserts (percent 0 and 10) are pruned; the newest is first.
        XCTAssertFalse(history.contains { $0.percent == 0 })
        XCTAssertFalse(history.contains { $0.percent == 10 })
        XCTAssertEqual(history.first?.percent, 110)
    }

    func testExamHistoryIsScopedPerModule() async throws {
        let store = try makeStore()
        let epoch = Date(timeIntervalSince1970: 0)
        let ppl = SessionResult(
            total: 5, correct: 5, percent: 100, passed: true, byBank: [:],
            duration: 30, finishedAt: epoch)
        let cpl = SessionResult(
            total: 5, correct: 3, percent: 60, passed: false, byBank: [:],
            duration: 30, finishedAt: epoch)
        try await store.recordExam(moduleID: "ppl-exam", result: ppl)
        try await store.recordExam(moduleID: "cpl", result: cpl)

        let pplHistory = try await store.examHistory(moduleID: "ppl-exam")
        XCTAssertEqual(pplHistory.map(\.percent), [100])
        let cplHistory = try await store.examHistory(moduleID: "cpl")
        XCTAssertEqual(cplHistory.map(\.percent), [60])
    }

    // MARK: - Flashcards / SRS

    func testGradeThenSrsEntriesRoundTrips() async throws {
        let store = try makeStore()
        let question = makeQuestion(bankID: "bank-a", index: 2, id: "q-3")
        let epoch = Date(timeIntervalSince1970: 0)

        let entry = try await store.grade(question: question, correct: true, now: epoch)
        // A fresh card graded correct is FSRS Good: stability 2.3065 days, which
        // buckets into display box 1 (web parity — see SRSTests).
        XCTAssertEqual(entry.box, 1)
        XCTAssertEqual(entry.s!, 2.3065, accuracy: 1e-10)

        let entries = try await store.srsEntries(bankID: "bank-a")
        XCTAssertEqual(entries[question.legacyKey], entry)
    }

    /// The FSRS columns on `CardSRSRecord` are new and optional; this is the test
    /// that fails if they are not actually written and read back. Without the
    /// round trip, every review would re-seed from `box` and stability could never
    /// grow past the old ladder's 30 days.
    func testFSRSStatePersistsAcrossGrades() async throws {
        let store = try makeStore()
        let question = makeQuestion(bankID: "bank-a", index: 0, id: "q-1")
        let day0 = Date(timeIntervalSince1970: 1_781_946_000)  // 2026-06-20T09:00:00Z

        let first = try await store.grade(question: question, correct: true, now: day0)
        XCTAssertEqual(first.reps, 1)
        XCTAssertEqual(first.due, "2026-06-22")

        // Reviewed on time, three days later. Had the stability not round-tripped,
        // this would recompute from box 1 (a 1-day seed) instead of from 2.3065.
        let second = try await store.grade(
            question: question, correct: true, now: day0.addingTimeInterval(2 * 86_400))
        XCTAssertEqual(second.reps, 2, "reps accumulate, so the row carried its history")
        XCTAssertEqual(second.s!, 10.964332, accuracy: 1e-5)
        XCTAssertEqual(second.last, "2026-06-22")
        XCTAssertEqual(second.lapses, 0)

        let reread = try await store.srsEntries(bankID: "bank-a")[question.legacyKey]
        XCTAssertEqual(reread, second, "every FSRS field survives the SwiftData round trip")
    }

    /// A row written before FSRS has nil stability. Reading it must seed from the
    /// box WITHOUT moving `due` — a learner must not come back to a changed
    /// schedule or a pile of newly-due cards.
    ///
    /// The legacy row is seeded through a plain `ModelContext` rather than a
    /// `StudyStore` call, because omitting the FSRS arguments is precisely what a
    /// pre-FSRS build did: the optional columns land as nil, which is the state
    /// lightweight migration leaves behind on a real device.
    func testPreFSRSRowIsMigratedOnReadWithoutMovingItsDueDate() async throws {
        let container = try Persistence.container(inMemory: true)
        let seeding = ModelContext(container)
        seeding.insert(
            CardSRSRecord(
                key: "bank-a|0", bankID: "bank-a", cardKey: "0", questionID: "q-1",
                box: 4, dueDay: "2026-07-01"))
        try seeding.save()

        let store = StudyStore(container: container)
        let entry = try await store.srsEntries(bankID: "bank-a")["0"]
        let unwrapped = try XCTUnwrap(entry)
        XCTAssertEqual(unwrapped.due, "2026-07-01", "the stored schedule must not move")
        XCTAssertEqual(unwrapped.box, 4)
        XCTAssertEqual(try XCTUnwrap(unwrapped.s), 14, "box 4 survived 14 days, so seed 14 days")
        XCTAssertEqual(unwrapped.last, "2026-06-17", "last = due minus the box interval")
        XCTAssertEqual(unwrapped.reps, 4)
    }

    /// And grading that migrated row must schedule from the seeded 14 days, not
    /// from scratch — the seed is worthless if the first review discards it.
    func testGradingAPreFSRSRowSchedulesFromItsSeededStability() async throws {
        let container = try Persistence.container(inMemory: true)
        let seeding = ModelContext(container)
        seeding.insert(
            CardSRSRecord(
                key: "bank-a|0", bankID: "bank-a", cardKey: "0", questionID: "q-1",
                box: 5, dueDay: "2026-06-20"))
        try seeding.save()

        let store = StudyStore(container: container)
        let graded = try await store.grade(
            question: makeQuestion(bankID: "bank-a", index: 0, id: "q-1"),
            correct: true,
            now: Date(timeIntervalSince1970: 1_781_946_000))  // 2026-06-20T09:00:00Z
        // 30 days of seeded stability + one on-time correct review. Matches the
        // web's "schedules a migrated card without losing its history" vector.
        XCTAssertEqual(try XCTUnwrap(graded.s), 111.458668, accuracy: 1e-5)
        XCTAssertEqual(graded.reps, 6, "reps carried the box across as review count")
        XCTAssertEqual(graded.box, 5)
    }

    func testGradeWrongResetsBoxToZero() async throws {
        let store = try makeStore()
        let question = makeQuestion(bankID: "bank-a", index: 4, id: "q-5")
        let epoch = Date(timeIntervalSince1970: 0)

        _ = try await store.grade(question: question, correct: true, now: epoch)
        _ = try await store.grade(question: question, correct: true, now: epoch)
        let wrong = try await store.grade(question: question, correct: false, now: epoch)
        XCTAssertEqual(wrong.box, 0)

        let entries = try await store.srsEntries(bankID: "bank-a")
        XCTAssertEqual(entries.count, 1, "Re-grading updates one row, never inserts a duplicate.")
    }

    // MARK: - Content refresh reconciliation

    func testReconcileSRSRewritesCardKeyWhenQuestionMovesIndex() async throws {
        let store = try makeStore()
        let epoch = Date(timeIntervalSince1970: 0)
        let question = makeQuestion(bankID: "bank-a", index: 2, id: "q-3")
        _ = try await store.grade(question: question, correct: true, now: epoch)

        // The refreshed corpus reorders "q-3" from index 2 to index 0.
        let movedQuestion = makeQuestion(bankID: "bank-a", index: 0, id: "q-3")
        let quiz = makeQuizFile(bankID: "bank-a", questions: [movedQuestion])

        try await store.reconcileSRS(bankID: "bank-a", quiz: quiz)

        let entries = try await store.srsEntries(bankID: "bank-a")
        XCTAssertNil(entries["2"], "the stale index-2 key must not remain")
        XCTAssertEqual(entries["0"]?.box, 1, "progress carries over to the question's new index")
    }

    func testReconcileSRSLeavesOrphanedRowUntouchedWhenQuestionIsRemoved() async throws {
        let store = try makeStore()
        let epoch = Date(timeIntervalSince1970: 0)
        let question = makeQuestion(bankID: "bank-a", index: 2, id: "q-3")
        _ = try await store.grade(question: question, correct: true, now: epoch)

        // The refreshed corpus no longer has "q-3" at all.
        let quiz = makeQuizFile(bankID: "bank-a", questions: [makeQuestion(bankID: "bank-a", index: 0, id: "q-other")])

        try await store.reconcileSRS(bankID: "bank-a", quiz: quiz)

        let entries = try await store.srsEntries(bankID: "bank-a")
        XCTAssertEqual(entries["2"]?.box, 1, "orphaned row is left as-is, not deleted")
    }

    func testReconcileSRSIsNoOpWhenIndexAlreadyMatches() async throws {
        let store = try makeStore()
        let epoch = Date(timeIntervalSince1970: 0)
        let question = makeQuestion(bankID: "bank-a", index: 2, id: "q-3")
        _ = try await store.grade(question: question, correct: true, now: epoch)

        let quiz = makeQuizFile(bankID: "bank-a", questions: [question])
        try await store.reconcileSRS(bankID: "bank-a", quiz: quiz)

        let entries = try await store.srsEntries(bankID: "bank-a")
        XCTAssertEqual(entries.count, 1)
        XCTAssertEqual(entries["2"]?.box, 1)
    }

    func testReconcileSRSIsNoOpWhenBankIsUnknownToTheRefreshedQuiz() async throws {
        let store = try makeStore()
        let epoch = Date(timeIntervalSince1970: 0)
        let question = makeQuestion(bankID: "bank-a", index: 2, id: "q-3")
        _ = try await store.grade(question: question, correct: true, now: epoch)

        let quiz = makeQuizFile(bankID: "bank-b", questions: [makeQuestion(bankID: "bank-b", index: 0, id: "q-other")])
        try await store.reconcileSRS(bankID: "bank-a", quiz: quiz)

        let entries = try await store.srsEntries(bankID: "bank-a")
        XCTAssertEqual(entries["2"]?.box, 1)
    }

    // MARK: - Quiz bests

    func testRecordQuizScoreKeepsBestPerBankAndNeverDowngrades() async throws {
        let store = try makeStore()
        try await store.recordQuizScore(moduleID: "ppl-exam", bankID: "bank-a", percent: 70)
        try await store.recordQuizScore(moduleID: "ppl-exam", bankID: "bank-a", percent: 50)
        var best = try await store.quizBest(moduleID: "ppl-exam")
        XCTAssertEqual(best["bank-a"], 70)

        try await store.recordQuizScore(moduleID: "ppl-exam", bankID: "bank-a", percent: 90)
        best = try await store.quizBest(moduleID: "ppl-exam")
        XCTAssertEqual(best["bank-a"], 90)
    }

    // MARK: - Lessons

    func testMarkLessonDoneIsIdempotent() async throws {
        let store = try makeStore()
        try await store.markLessonDone(moduleID: "ppl-exam", lessonID: "lesson-1")
        try await store.markLessonDone(moduleID: "ppl-exam", lessonID: "lesson-1")
        let done = try await store.lessonsDone(moduleID: "ppl-exam")
        XCTAssertEqual(done, ["lesson-1"])
    }

    // MARK: - Flags

    func testSetFlagTogglesIndexInAndOutOfTheBank() async throws {
        let store = try makeStore()
        try await store.setFlag(moduleID: "ppl-exam", bankID: "bank-a", index: 3, flagged: true)
        try await store.setFlag(moduleID: "ppl-exam", bankID: "bank-a", index: 5, flagged: true)
        var flagged = try await store.flaggedIndices(moduleID: "ppl-exam", bankID: "bank-a")
        XCTAssertEqual(Set(flagged), [3, 5])

        try await store.setFlag(moduleID: "ppl-exam", bankID: "bank-a", index: 3, flagged: false)
        flagged = try await store.flaggedIndices(moduleID: "ppl-exam", bankID: "bank-a")
        XCTAssertEqual(flagged, [5])
    }

    func testSetFlagIsIdempotentAndScopedPerBank() async throws {
        let store = try makeStore()
        try await store.setFlag(moduleID: "ppl-exam", bankID: "bank-a", index: 1, flagged: true)
        try await store.setFlag(moduleID: "ppl-exam", bankID: "bank-a", index: 1, flagged: true)
        let bankA = try await store.flaggedIndices(moduleID: "ppl-exam", bankID: "bank-a")
        XCTAssertEqual(bankA, [1], "Flagging twice doesn't duplicate the index.")

        let bankB = try await store.flaggedIndices(moduleID: "ppl-exam", bankID: "bank-b")
        XCTAssertEqual(bankB, [], "A different bank in the same module starts unflagged.")
    }

    // MARK: - Reset All Progress

    func testResetAllProgressClearsAllUserData() async throws {
        let store = try makeStore()
        let epoch = Date(timeIntervalSince1970: 0)

        let result = SessionResult(total: 10, correct: 9, percent: 90, passed: true, byBank: [:], duration: 60, finishedAt: epoch)
        try await store.recordExam(moduleID: "ppl-exam", result: result)
        try await store.recordQuizScore(moduleID: "ppl-exam", bankID: "bank-a", percent: 85)
        try await store.markLessonDone(moduleID: "ppl-exam", lessonID: "lesson-1")
        try await store.touchStreak(now: epoch)

        try await store.resetAllProgress()

        let history = try await store.examHistory(moduleID: "ppl-exam")
        XCTAssertTrue(history.isEmpty)

        let best = try await store.quizBest(moduleID: "ppl-exam")
        XCTAssertTrue(best.isEmpty)

        let done = try await store.lessonsDone(moduleID: "ppl-exam")
        XCTAssertTrue(done.isEmpty)

        let streak = try await store.currentStreak()
        XCTAssertEqual(streak.count, 0)
    }

    // MARK: - Streak

    func testTouchStreakAdvancesByDayGaps() async throws {
        let store = try makeStore()
        let day0 = Date(timeIntervalSince1970: 0)
        let sameDayLater = day0.addingTimeInterval(3600)
        let day1 = day0.addingTimeInterval(86_400)
        let day11 = day0.addingTimeInterval(86_400 * 11)

        var streak = try await store.touchStreak(now: day0)
        XCTAssertEqual(streak, Streak(day: "1970-01-01", count: 1))

        streak = try await store.touchStreak(now: sameDayLater)
        XCTAssertEqual(streak, Streak(day: "1970-01-01", count: 1), "Same day = unchanged.")

        streak = try await store.touchStreak(now: day1)
        XCTAssertEqual(streak, Streak(day: "1970-01-02", count: 2), "Consecutive day = +1.")

        streak = try await store.touchStreak(now: day11)
        XCTAssertEqual(streak, Streak(day: "1970-01-12", count: 1), "Gap resets to 1.")
    }
}
