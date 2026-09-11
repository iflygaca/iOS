import Foundation

/// FSRS-6 memory model — the scheduler behind flashcard review.
///
/// A literal port of the web engine (`src/calc/study/fsrs.ts`). It replaces the
/// fixed Leitner ladder (boxes 0…5 on `[0, 1, 3, 7, 14, 30]` days), which gave
/// every learner the same intervals regardless of how hard a given card was for
/// them. FSRS tracks two values per card instead:
///
///   stability  S — days until recall probability falls to 90%
///   difficulty D — 1…10, how fast that card decays for this learner
///
/// WHY THIS IS HAND-WRITTEN AND NOT A PACKAGE DEPENDENCY. Two reasons, both
/// structural:
///
///   1. This package declares zero external dependencies on purpose — that is
///      what keeps `swift build` / `swift test` instant with no SDK downloads.
///   2. Web and iOS must agree exactly; users move between them mid-deck. Two
///      different libraries, or a library on one side and a port on the other,
///      is *more* drift risk than two ports of one spec cross-checked by shared
///      vectors. That is already how Leitner was kept in parity, and it worked.
///
/// The web side of this model was verified numerically against ts-fsrs 5.4.2
/// across a grid of 960 (stability, difficulty, elapsed, rating) cases plus all
/// four first reviews. `SRSTests` pins the same frozen vectors here, so the two
/// ports are checked against one reference without either taking a dependency.
///
/// Pure: no clock of its own, no IO — every entry point takes its inputs, so
/// tests need no simulator and no fixed-date plumbing beyond a `Date` argument.
public enum FSRS {
    /// FSRS-6 default weights (21). Upstream defaults, not tuned on our learners.
    public static let defaultW: [Double] = [
        0.212, 1.2931, 2.3065, 8.2956, 6.4133, 0.8334, 3.0194, 0.001, 1.8722, 0.1666, 0.796,
        1.4835, 0.0614, 0.2629, 1.6483, 0.6014, 1.8729, 0.5425, 0.0912, 0.0658, 0.1542,
    ]

    /// Target recall probability at the moment a card comes due.
    public static let requestRetention = 0.9

    /// Interval ceiling, in days. Matches ts-fsrs's default (100 years).
    public static let maxIntervalDays = 36_500

    /// Grade for one review. Mirrors FSRS ratings 1…4, and the web's `Rating`
    /// object — the raw values are the wire contract, not just an ordering.
    public enum Rating: Int, Hashable, Sendable, Codable, CaseIterable {
        case again = 1
        case hard = 2
        case good = 3
        case easy = 4
    }

    static let decay = -defaultW[20]
    static let factor = pow(0.9, 1 / decay) - 1

    static func clamp(_ x: Double, _ lo: Double, _ hi: Double) -> Double {
        min(hi, max(lo, x))
    }

    /// Recall probability `elapsedDays` after the last review, given stability S.
    /// By construction `retrievability(S, S) == 0.9` — a card is due exactly when
    /// recall has decayed to the target retention.
    public static func retrievability(elapsedDays: Double, stability: Double) -> Double {
        guard stability > 0 else { return 0 }
        return pow(1 + factor * max(0, elapsedDays) / stability, decay)
    }

    /// Ideal interval, in days, for a card at the given stability.
    public static func idealInterval(stability: Double) -> Double {
        (stability / factor) * (pow(requestRetention, 1 / decay) - 1)
    }

    /// The whole-day interval we actually schedule.
    ///
    /// `rounded()` is half-away-from-zero where JavaScript's `Math.round` is
    /// half-up; they agree for every non-negative value, and `idealInterval` is
    /// non-negative for any non-negative stability, so the two ports round
    /// identically on every input this is ever called with.
    public static func intervalDays(stability: Double) -> Int {
        Int(clamp(idealInterval(stability: stability).rounded(), 1, Double(maxIntervalDays)))
    }

    /// Stability of a brand-new card after its first grade.
    public static func initialStability(rating: Rating) -> Double {
        max(defaultW[rating.rawValue - 1], 0.01)
    }

    /// Raw D₀ curve, before clamping.
    static func rawInitialDifficulty(_ rating: Int) -> Double {
        defaultW[4] - exp(defaultW[5] * Double(rating - 1)) + 1
    }

    /// Difficulty of a brand-new card after its first grade.
    public static func initialDifficulty(rating: Rating) -> Double {
        clamp(rawInitialDifficulty(rating.rawValue), 1, 10)
    }

    /// Difficulty after a review: linear damping toward 10, then mean reversion.
    ///
    /// The reversion target is the **unclamped** D₀(Easy), which at the default
    /// weights is about −4.776, not 1. That asymmetry is deliberate upstream and
    /// easy to get wrong: clamping it here instead shifts every post-review
    /// difficulty by roughly 0.006, which compounds over a deck's lifetime. A
    /// differential run against ts-fsrs caught exactly that on the web side — the
    /// clamp belongs on a new card's starting difficulty, and nowhere else.
    public static func nextDifficulty(_ difficulty: Double, rating: Rating) -> Double {
        let delta = -defaultW[6] * Double(rating.rawValue - 3)
        let damped = difficulty + (delta * (10 - difficulty)) / 9
        let reverted =
            defaultW[7] * rawInitialDifficulty(Rating.easy.rawValue) + (1 - defaultW[7]) * damped
        return clamp(reverted, 1, 10)
    }

    /// Stability after a successful recall (Hard, Good or Easy).
    public static func stabilityAfterRecall(
        stability: Double,
        difficulty: Double,
        recall: Double,
        rating: Rating
    ) -> Double {
        let hardPenalty: Double = rating == .hard ? defaultW[15] : 1
        let easyBonus: Double = rating == .easy ? defaultW[16] : 1
        let growth =
            1 + exp(defaultW[8])
            * (11 - difficulty)
            * pow(stability, -defaultW[9])
            * (exp(defaultW[10] * (1 - recall)) - 1)
            * hardPenalty
            * easyBonus
        return max(stability * growth, 0.01)
    }

    /// Stability after a lapse (Again). Capped at the card's current stability:
    /// forgetting must never lengthen an interval.
    public static func stabilityAfterLapse(
        stability: Double,
        difficulty: Double,
        recall: Double
    ) -> Double {
        let lapsed =
            defaultW[11]
            * pow(difficulty, -defaultW[12])
            * (pow(stability + 1, defaultW[13]) - 1)
            * exp(defaultW[14] * (1 - recall))
        return clamp(min(lapsed, stability), 0.01, stability)
    }
}
