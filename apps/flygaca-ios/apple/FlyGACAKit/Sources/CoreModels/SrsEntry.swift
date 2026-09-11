import Foundation

/// A flashcard's spaced-repetition state — the exact web shape
/// (`src/calc/study/srs.ts` `SrsEntry`).
///
/// `due` is a UTC calendar day ("yyyy-mm-dd"), kept as a day STRING and not a
/// `Date`: the web computes days in UTC (`toISOString().slice(0, 10)`), and
/// comparing formatted strings is what keeps iOS and web agreeing on "due today".
///
/// `box` is a DERIVED display bucket, never an input to scheduling — FSRS decides
/// when a card comes back (see `StudyEngines.SRS`). It is still written on every
/// entry so the existing UI (the mastery count, the progress grid) keeps working,
/// and so an older app build can still read an entry written by a newer one. The
/// mapping is chosen so the old mastery rule survives exactly: box ≥ 3 ⇔
/// stability ≥ 7 days.
///
/// The FSRS fields are optional for exactly one reason: entries written before
/// FSRS landed carry only `box` and `due`. `SRS.migrate` fills them in, lazily
/// and idempotently, preserving `due` untouched — nobody's schedule moves.
public struct SrsEntry: Hashable, Sendable, Codable {
    /// Display bucket 0…`SRS.maxBox`, derived from `s`.
    public var box: Int
    /// ISO yyyy-mm-dd the card next becomes due.
    public var due: String
    /// FSRS stability, in days. Absent only on pre-FSRS entries.
    public var s: Double?
    /// FSRS difficulty, 1…10. Absent only on pre-FSRS entries.
    public var d: Double?
    /// ISO yyyy-mm-dd of the last review, for elapsed-day computation.
    public var last: String?
    /// Total reviews recorded for this card.
    public var reps: Int?
    /// How many of those reviews were failures.
    public var lapses: Int?

    public init(
        box: Int,
        due: String,
        s: Double? = nil,
        d: Double? = nil,
        last: String? = nil,
        reps: Int? = nil,
        lapses: Int? = nil
    ) {
        self.box = box
        self.due = due
        self.s = s
        self.d = d
        self.last = last
        self.reps = reps
        self.lapses = lapses
    }
}
