import CoreModels
import XCTest

@testable import StudyEngines

/// Frozen cross-platform vectors for the FSRS scheduler.
///
/// These are THE reference shared with the web engine (`src/calc/study/srs.ts`);
/// `tests/srs.test.ts` over there asserts the same numbers. The memory model was
/// verified numerically against ts-fsrs 5.4.2 over a grid of 960 (stability,
/// difficulty, elapsed, rating) cases plus all four first reviews, and this port
/// was then differentially checked against the TypeScript across 1,367 cases —
/// every `due`, `box`, `reps` and `lapses` exact, every stability and difficulty
/// equal to within 1e-12 relative.
///
/// If one of these fails after an engine change, web and iOS have diverged.
/// Fix the port; do not re-bless the number.
final class SRSTests: XCTestCase {
    let now = Date(timeIntervalSince1970: 1_781_946_000)  // 2026-06-20T09:00:00Z

    /// 09:00 UTC on a given day — mid-day, so a timezone slip would be visible.
    func at(_ day: String) -> Date {
        Date(timeIntervalSince1970: SRS.timestamp(day)! + 9 * 3600)
    }

    // ── The UTC day contract ──

    func testDayIsUTCNotLocal() {
        // 23:59 UTC on Jan 1 is already Jan 2 in Riyadh (UTC+3). The web uses
        // toISOString() (UTC); a Calendar.current port would return "1970-01-02"
        // on a Mac in a positive-offset timezone and drift all due dates.
        XCTAssertEqual(SRS.day(Date(timeIntervalSince1970: 86_340)), "1970-01-01")
        XCTAssertEqual(SRS.day(Date(timeIntervalSince1970: 0)), "1970-01-01")
        XCTAssertEqual(SRS.day(now), "2026-06-20")
    }

    // ── FSRS first review (frozen vectors) ──

    func testFirstReviewSetsStabilityAndDifficultyPerRating() {
        let again = SRS.schedule(nil, rated: .again, now: now)
        XCTAssertEqual(again.s!, 0.212, accuracy: 1e-10)
        XCTAssertEqual(again.d!, 6.4133, accuracy: 1e-10)
        XCTAssertEqual(again.box, 0)
        XCTAssertEqual(again.due, "2026-06-20")

        let hard = SRS.schedule(nil, rated: .hard, now: now)
        XCTAssertEqual(hard.s!, 1.2931, accuracy: 1e-10)
        XCTAssertEqual(hard.d!, 5.112171, accuracy: 1e-5)
        XCTAssertEqual(hard.due, "2026-06-21")

        let good = SRS.schedule(nil, rated: .good, now: now)
        XCTAssertEqual(good.s!, 2.3065, accuracy: 1e-10)
        XCTAssertEqual(good.d!, 2.118104, accuracy: 1e-5)
        XCTAssertEqual(good.due, "2026-06-22")
        XCTAssertEqual(good.box, 1)

        let easy = SRS.schedule(nil, rated: .easy, now: now)
        XCTAssertEqual(easy.s!, 8.2956, accuracy: 1e-10)
        XCTAssertEqual(easy.d!, 1)
        XCTAssertEqual(easy.due, "2026-06-28")
        XCTAssertEqual(easy.box, 3)
    }

    func testFirstAgainCountsAsALapse() {
        XCTAssertEqual(SRS.schedule(nil, rated: .again, now: now).lapses, 1)
        XCTAssertEqual(SRS.schedule(nil, rated: .again, now: now).reps, 1)
        XCTAssertEqual(SRS.schedule(nil, rated: .good, now: now).lapses, 0)
    }

    // ── FSRS is adaptive: the point of the change ──

    func testIntervalStretchesAsACardIsRecalledOnTime() {
        var card = SRS.schedule(nil, rated: .good, now: now)
        var dues = [card.due]
        for _ in 0..<5 {
            card = SRS.schedule(card, rated: .good, now: at(card.due))
            dues.append(card.due)
        }
        XCTAssertEqual(
            dues,
            [
                "2026-06-22", "2026-07-03", "2026-08-18", "2027-01-28", "2028-06-08",
                "2032-02-14",
            ])
        // Under the old ladder this card would have capped at a 30-day interval.
        XCTAssertEqual(card.s!, 1345.5288, accuracy: 1e-3)
        XCTAssertEqual(card.box, SRS.maxBox)
    }

    func testStabilityCollapsesOnALapse() {
        var card = SRS.schedule(nil, rated: .good, now: now)
        for _ in 0..<5 { card = SRS.schedule(card, rated: .good, now: at(card.due)) }
        let mature = card.s!

        let lapsed = SRS.schedule(card, rated: .again, now: at(card.due))
        XCTAssertEqual(lapsed.s!, 9.444601, accuracy: 1e-5)
        XCTAssertLessThan(lapsed.s!, mature / 100)
        XCTAssertGreaterThan(lapsed.d!, card.d!)
        XCTAssertEqual(lapsed.lapses, 1)
        XCTAssertEqual(lapsed.reps, 7)
    }

    func testEasyRatesAboveGoodRatesAboveHard() {
        let seed = SRS.schedule(nil, rated: .good, now: now)
        let when = at(seed.due)
        let again = SRS.schedule(seed, rated: .again, now: when).s!
        let hard = SRS.schedule(seed, rated: .hard, now: when).s!
        let good = SRS.schedule(seed, rated: .good, now: when).s!
        let easy = SRS.schedule(seed, rated: .easy, now: when).s!
        XCTAssertEqual(again, 0.60758, accuracy: 1e-5)
        XCTAssertEqual(hard, 7.51332, accuracy: 1e-5)
        XCTAssertEqual(good, 10.964332, accuracy: 1e-5)
        XCTAssertEqual(easy, 18.521754, accuracy: 1e-5)
        XCTAssertLessThan(again, hard)
        XCTAssertLessThan(hard, good)
        XCTAssertLessThan(good, easy)
    }

    // ── A wrong answer stays due today ──

    func testAWrongAnswerStaysInTodaysDuePool() {
        // The flashcard drill depends on this: box 0 used to mean "due today", so
        // a card you just missed came round again in the same session. FSRS would
        // schedule a lapsed mature card days out, which would silently remove that
        // loop — see the note in SRS.swift.
        let fresh = SRS.schedule(nil, correct: false, now: now)
        XCTAssertEqual(fresh.due, "2026-06-20")
        XCTAssertTrue(SRS.isDue(fresh, now: now))

        var card = SRS.schedule(nil, rated: .good, now: now)
        for _ in 0..<5 { card = SRS.schedule(card, rated: .good, now: at(card.due)) }
        let when = at(card.due)
        let lapsed = SRS.schedule(card, rated: .again, now: when)
        XCTAssertEqual(lapsed.due, SRS.day(when))
        XCTAssertTrue(SRS.isDue(lapsed, now: when))
    }

    // ── Binary grading maps onto FSRS ──

    func testBinaryGradingMapsCorrectToGoodAndWrongToAgain() {
        XCTAssertEqual(
            SRS.schedule(nil, correct: true, now: now).s!,
            SRS.schedule(nil, rated: .good, now: now).s!, accuracy: 1e-12)
        XCTAssertEqual(
            SRS.schedule(nil, correct: false, now: now).s!,
            SRS.schedule(nil, rated: .again, now: now).s!, accuracy: 1e-12)
    }

    // ── Migration from the Leitner ladder ──

    func testMigrationPreservesDueForEveryBox() {
        for box in 0...SRS.maxBox {
            XCTAssertEqual(SRS.migrate(SrsEntry(box: box, due: "2026-07-01")).due, "2026-07-01")
            XCTAssertEqual(SRS.migrate(SrsEntry(box: box, due: "2026-07-01")).box, box)
        }
    }

    func testMigrationSeedsStabilityFromTheBoxTheCardHadEarned() {
        XCTAssertEqual(SRS.migrate(SrsEntry(box: 4, due: "2026-07-01")).s!, 14)
        XCTAssertEqual(SRS.migrate(SrsEntry(box: 5, due: "2026-07-01")).s!, 30)
        // Box 0 has a zero-day interval, so it floors at the minimum stability
        // rather than zero, which would make retrievability undefined.
        XCTAssertEqual(SRS.migrate(SrsEntry(box: 0, due: "2026-07-01")).s!, 0.212, accuracy: 1e-10)
    }

    func testMigrationBacksLastDateOffByTheBoxInterval() {
        // Setting `last` to `due` instead would read as zero elapsed time on the
        // first post-migration review — retrievability 1, no stability gained, and
        // every learner's first review after the update silently does nothing.
        XCTAssertEqual(SRS.migrate(SrsEntry(box: 4, due: "2026-07-01")).last, "2026-06-17")
        XCTAssertEqual(SRS.migrate(SrsEntry(box: 5, due: "2026-07-01")).last, "2026-06-01")
        XCTAssertEqual(SRS.migrate(SrsEntry(box: 0, due: "2026-07-01")).last, "2026-07-01")
    }

    func testMigrationIsIdempotent() {
        let once = SRS.migrate(SrsEntry(box: 3, due: "2026-07-01"))
        XCTAssertEqual(SRS.migrate(once), once)
    }

    func testAMigratedCardSchedulesWithoutLosingItsHistory() {
        let legacy = SrsEntry(box: 5, due: "2026-06-20")
        let next = SRS.schedule(legacy, rated: .good, now: now)
        // A box-5 card carries 30 days of seeded stability, so one more correct
        // review must push it well past the old 30-day ceiling.
        XCTAssertEqual(next.s!, 111.458668, accuracy: 1e-5)
        XCTAssertEqual(next.reps, 6)
    }

    // ── box is derived from stability ──

    func testBoxBucketsOnTheLegacyLadder() {
        let expected: [(Double, Int)] = [
            (-1, 0), (0, 0), (0.5, 0), (0.99, 0), (1, 1), (2.9, 1), (3, 2), (6.99, 2),
            (7, 3), (13.9, 3), (14, 4), (29.9, 4), (30, 5), (500, 5),
        ]
        for (stability, box) in expected {
            XCTAssertEqual(SRS.boxForStability(stability), box, "stability \(stability)")
        }
    }

    func testTheOldMasteryRuleSurvivesExactly() {
        // box >= 3 iff stability >= 7 days.
        XCTAssertEqual(SRS.intervalDays(forBox: 3), SRS.masteryStabilityDays)
        XCTAssertEqual(SRS.boxForStability(Double(SRS.masteryStabilityDays)), 3)
        XCTAssertLessThan(SRS.boxForStability(Double(SRS.masteryStabilityDays) - 0.01), 3)
    }

    func testBoxIntervalsAreClamped() {
        XCTAssertEqual((0...5).map(SRS.intervalDays(forBox:)), [0, 1, 3, 7, 14, 30])
        XCTAssertEqual(SRS.intervalDays(forBox: -1), 0)
        XCTAssertEqual(SRS.intervalDays(forBox: 99), 30)
    }

    // ── Day-string arithmetic ──

    func testAddDaysCrossesMonthAndLeapBoundaries() {
        XCTAssertEqual(SRS.addDays("2026-06-20", 0), "2026-06-20")
        XCTAssertEqual(SRS.addDays("2026-06-20", 1), "2026-06-21")
        XCTAssertEqual(SRS.addDays("2026-06-20", -1), "2026-06-19")
        XCTAssertEqual(SRS.addDays("2026-06-20", -30), "2026-05-21")
        XCTAssertEqual(SRS.addDays("2026-01-01", -1), "2025-12-31")
        XCTAssertEqual(SRS.addDays("2026-03-01", -1), "2026-02-28")
        XCTAssertEqual(SRS.addDays("2024-03-01", -1), "2024-02-29")
        XCTAssertEqual(SRS.addDays("2026-12-31", 1), "2027-01-01")
        // Unparseable input is returned unchanged, matching the web's NaN guard.
        XCTAssertEqual(SRS.addDays("nonsense", 5), "nonsense")
    }

    func testDaysBetweenCountsWholeUTCDaysAndClampsNegatives() {
        XCTAssertEqual(SRS.daysBetween(from: "2026-06-20", to: "2026-06-20"), 0)
        XCTAssertEqual(SRS.daysBetween(from: "2026-06-20", to: "2026-06-23"), 3)
        XCTAssertEqual(SRS.daysBetween(from: "2026-06-23", to: "2026-06-20"), 0)
        XCTAssertEqual(SRS.daysBetween(from: "nonsense", to: "2026-06-20"), 0)
        XCTAssertEqual(SRS.daysBetween(from: "2026-02-01", to: "2026-03-01"), 28)
        XCTAssertEqual(SRS.daysBetween(from: "2024-02-01", to: "2024-03-01"), 29)
        XCTAssertEqual(SRS.daysBetween(from: "2026-01-01", to: "2027-01-01"), 365)
    }

    func testAnOutOfRangeMonthIsRejectedNotRolledOver() {
        // A Gregorian Calendar would happily resolve "2026-13-01" to 2027-01-01;
        // the web gets NaN from Date.parse. Both platforms must fall back.
        XCTAssertEqual(SRS.addDays("2026-13-01", 1), "2026-13-01")
        XCTAssertEqual(SRS.daysBetween(from: "2026-00-01", to: "2026-06-20"), 0)
        XCTAssertEqual(SRS.daysBetween(from: "2026-06-32", to: "2026-06-20"), 0)
    }

    // ── Unchanged read-model behaviour: the `due` contract did not move ──

    func testIsDueTreatsUnseenAndPastCardsAsDue() {
        XCTAssertTrue(SRS.isDue(nil, now: now))
        XCTAssertTrue(SRS.isDue(SrsEntry(box: 2, due: "2026-06-19"), now: now))
        XCTAssertTrue(SRS.isDue(SrsEntry(box: 2, due: "2026-06-20"), now: now))
        XCTAssertFalse(SRS.isDue(SrsEntry(box: 2, due: "2026-06-30"), now: now))
    }

    func testDueKeysPreserveInputOrderAndIncludeUnseen() {
        let entries: [String: SrsEntry] = [
            "a": SrsEntry(box: 1, due: "2026-06-19"),
            "b": SrsEntry(box: 2, due: "2026-06-20"),
            "c": SrsEntry(box: 3, due: "2026-06-30"),
        ]
        XCTAssertEqual(
            SRS.dueKeys(in: entries, allKeys: ["a", "b", "c", "d"], now: now), ["a", "b", "d"])
        XCTAssertEqual(SRS.dueCount(in: entries, allKeys: ["a", "b", "c", "d"], now: now), 3)
    }

    func testMasteredCountUsesTheBoxThreshold() {
        let entries: [String: SrsEntry] = [
            "a": SrsEntry(box: 1, due: ""),
            "b": SrsEntry(box: 3, due: ""),
            "c": SrsEntry(box: 5, due: ""),
        ]
        XCTAssertEqual(SRS.masteredCount(in: entries), 2)
        XCTAssertEqual(SRS.masteredCount(in: entries, threshold: 5), 1)
    }
}
