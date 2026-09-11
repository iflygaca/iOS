import CoreModels
import Foundation

/// Flashcard scheduling. FSRS-6 decides *when* a card comes back; the Leitner box
/// is kept as a derived presentation bucket.
///
/// A literal port of the web engine (`src/calc/study/srs.ts`), which is the
/// cross-platform contract: users move between the web app and these apps, so
/// stability, difficulty, due and mastery must agree exactly. Any change here must
/// land in `srs.ts` too (and vice versa); the frozen vectors in `SRSTests` assert
/// the shared semantics, and the web's `tests/srs.test.ts` holds the same numbers.
///
/// This used to be a pure Leitner ladder: boxes 0…5 on a fixed `[0, 1, 3, 7, 14,
/// 30]` day ladder, the same intervals for every learner and every card. FSRS
/// replaces the ladder with a per-card memory model (see `FSRS`), so a section a
/// learner keeps failing comes back sooner and one they know cold stretches out.
///
/// WHAT DID NOT CHANGE, deliberately:
///
///   `due` is still a UTC day-string ("yyyy-mm-dd") compared with `<=`. Every read
///   path — `dueKeys`, `dueCount`, the deck builder, the web — keeps working
///   unchanged, and a `Calendar.current` port would still drift a day near
///   midnight.
///
///   `box` is still present on every entry, now DERIVED from stability via the old
///   interval ladder (`boxForStability`). It is a display bucket, never an input to
///   scheduling. That keeps the mastery count and progress UI working without a
///   rewrite. The mapping is chosen so the old mastery rule survives exactly:
///   box ≥ 3 ⇔ stability ≥ 7 days.
///
/// Migration is lossless for the learner: `migrate` seeds stability and difficulty
/// from the stored box but **preserves `due` byte-for-byte**, so nobody wakes up to
/// a changed schedule or a flood of suddenly-due cards.
public enum SRS {
    public static let maxBox = 5
    /// Cards at/above this box count as "learned" (web `masteredCount` default).
    public static let masteryThreshold = 3
    /// Stability at/above which a card counts as mastered — box 3's old interval.
    public static let masteryStabilityDays = 7

    /// The legacy ladder. Now only used to bucket stability into a display box.
    static let intervals = [0, 1, 3, 7, 14, 30]

    /// Deliberately NOT `Calendar.current`: a local-time calendar would drift a day
    /// against the web near midnight, and every due comparison is a string compare.
    static let utcCalendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        return calendar
    }()

    /// UTC calendar day ("yyyy-mm-dd") — the web's `srsDay`
    /// (`Date.toISOString().slice(0, 10)`).
    public static func day(_ date: Date) -> String {
        let c = utcCalendar.dateComponents([.year, .month, .day], from: date)
        return String(format: "%04d-%02d-%02d", c.year!, c.month!, c.day!)
    }

    /// The legacy ladder's interval for a box — the web's `boxIntervalDays`.
    public static func intervalDays(forBox box: Int) -> Int {
        intervals[max(0, min(maxBox, box))]
    }

    /// Bucket a stability into the legacy box: the largest box whose old interval
    /// the stability has reached, so box ≥ 3 ⇔ stability ≥ 7 days.
    public static func boxForStability(_ stability: Double) -> Int {
        for box in (0...maxBox).reversed() where stability >= Double(intervals[box]) {
            return box
        }
        return 0
    }

    /// Shift a UTC day-string by `n` days (negative shifts backwards). An
    /// unparseable day is returned unchanged, matching the web's NaN guard.
    public static func addDays(_ dayString: String, _ n: Int) -> String {
        guard let t = timestamp(dayString) else { return dayString }
        return day(Date(timeIntervalSince1970: t + Double(n) * 86_400))
    }

    /// Whole days between two UTC day-strings; negative clamps to 0.
    public static func daysBetween(from: String, to: String) -> Int {
        guard let a = timestamp(from), let b = timestamp(to) else { return 0 }
        return max(0, Int(((b - a) / 86_400).rounded()))
    }

    /// Seconds-since-epoch for a "yyyy-mm-dd" day at UTC midnight, or nil.
    ///
    /// The month/day range checks are load-bearing: the web gets its rejection for
    /// free from `Date.parse` returning NaN, whereas a Gregorian `Calendar` happily
    /// rolls "2026-13-01" over into 2027. Validating here keeps a malformed stored
    /// day falling back the same way on both platforms instead of silently
    /// resolving to a real — and wrong — date.
    static func timestamp(_ dayString: String) -> Double? {
        let parts = dayString.split(separator: "-")
        guard parts.count == 3,
            let year = Int(parts[0]), let month = Int(parts[1]), let dayOfMonth = Int(parts[2]),
            (1...12).contains(month), (1...31).contains(dayOfMonth)
        else { return nil }
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = dayOfMonth
        return utcCalendar.date(from: components)?.timeIntervalSince1970
    }

    /// Bring a stored entry up to the FSRS shape. Idempotent.
    ///
    /// A pre-FSRS entry has only `box` and `due`. Stability is seeded from the
    /// box's old interval — a card in box 4 demonstrably survived a 14-day gap, so
    /// 14 days of stability is the honest estimate — and difficulty starts at the
    /// neutral D₀(Good) because the old model recorded nothing about per-card
    /// difficulty. `due` is copied across untouched.
    ///
    /// `last` is reconstructed as `due` minus the box's interval, which is when the
    /// review that produced this schedule must have happened. Setting it to `due`
    /// instead looks harmless and is not: elapsed time would read as zero on the
    /// first review after migration, retrievability would be 1, and FSRS grants no
    /// stability for recalling something you were just shown — so every learner's
    /// first post-migration review would silently fail to advance the card.
    public static func migrate(_ entry: SrsEntry) -> SrsEntry {
        if entry.s != nil, entry.d != nil { return entry }
        let box = max(0, min(maxBox, entry.box))
        let seededStability = max(
            Double(intervalDays(forBox: box)), FSRS.initialStability(rating: .again))
        return SrsEntry(
            box: box,
            due: entry.due,
            s: seededStability,
            d: FSRS.initialDifficulty(rating: .good),
            last: addDays(entry.due, -intervalDays(forBox: box)),
            reps: box,
            lapses: 0
        )
    }

    /// Schedule a card after grading it `rating` at `now`.
    public static func schedule(
        _ previous: SrsEntry?,
        rated rating: FSRS.Rating,
        now: Date
    ) -> SrsEntry {
        let today = day(now)

        let stability: Double
        let difficulty: Double
        let reps: Int
        let lapses: Int

        if let previous {
            // `migrate` guarantees both fields are present when either was missing,
            // so the fallbacks below are unreachable — they exist only to unwrap.
            let base = migrate(previous)
            let s = base.s ?? FSRS.initialStability(rating: .again)
            let d = base.d ?? FSRS.initialDifficulty(rating: .good)
            let elapsed = daysBetween(from: base.last ?? base.due, to: today)
            let recall = FSRS.retrievability(elapsedDays: Double(elapsed), stability: s)
            stability =
                rating == .again
                ? FSRS.stabilityAfterLapse(stability: s, difficulty: d, recall: recall)
                : FSRS.stabilityAfterRecall(
                    stability: s, difficulty: d, recall: recall, rating: rating)
            difficulty = FSRS.nextDifficulty(d, rating: rating)
            reps = (base.reps ?? 0) + 1
            lapses = (base.lapses ?? 0) + (rating == .again ? 1 : 0)
        } else {
            stability = FSRS.initialStability(rating: rating)
            difficulty = FSRS.initialDifficulty(rating: rating)
            reps = 1
            lapses = rating == .again ? 1 : 0
        }

        // A lapse stays due today, exactly as box 0 did. FSRS proper would schedule
        // a lapsed card by its new stability — which at day granularity can land
        // days out (a mature card failing once came back in 5 days in testing).
        // That would quietly delete the "got it wrong, see it again now" loop the
        // flashcard drill is built on. Relearning steps are the upstream answer to
        // this; our contract is a UTC day-string, so the day-granular equivalent is
        // to keep it in today's due pool. The FSRS state is still recorded in full,
        // so the next *successful* review schedules from the real post-lapse
        // stability.
        let due =
            rating == .again
            ? today
            : day(
                now.addingTimeInterval(
                    TimeInterval(FSRS.intervalDays(stability: stability)) * 86_400))

        return SrsEntry(
            box: boxForStability(stability),
            due: due,
            s: stability,
            d: difficulty,
            last: today,
            reps: reps,
            lapses: lapses
        )
    }

    /// Binary grading, kept so the existing known/unknown flashcard flow works
    /// unchanged: a correct answer is Good, a wrong one is Again. The four-rating
    /// entry point above is there for when the UI grows Hard/Easy buttons.
    public static func schedule(_ previous: SrsEntry?, correct: Bool, now: Date) -> SrsEntry {
        schedule(previous, rated: correct ? .good : .again, now: now)
    }

    /// True when a card should be reviewed now (unseen cards count as due).
    public static func isDue(_ entry: SrsEntry?, now: Date) -> Bool {
        guard let entry else { return true }
        return entry.due <= day(now)
    }

    /// The subset of `allKeys` that are due now, preserving input order.
    public static func dueKeys(in entries: [String: SrsEntry], allKeys: [String], now: Date)
        -> [String]
    {
        allKeys.filter { isDue(entries[$0], now: now) }
    }

    public static func dueCount(in entries: [String: SrsEntry], allKeys: [String], now: Date) -> Int
    {
        dueKeys(in: entries, allKeys: allKeys, now: now).count
    }

    /// Cards considered "learned". The threshold is a box, as before, and the
    /// derived box keeps the old cohort intact: the default 3 still means
    /// "stability has reached 7 days".
    public static func masteredCount(
        in entries: [String: SrsEntry],
        threshold: Int = masteryThreshold
    ) -> Int {
        entries.values.filter { $0.box >= threshold }.count
    }
}
