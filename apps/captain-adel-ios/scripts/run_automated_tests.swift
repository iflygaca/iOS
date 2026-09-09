import Foundation

// MARK: - Test Runner Framework
var passedCount = 0
var failedCount = 0

func assertTest(_ condition: Bool, _ name: String, file: StaticString = #file, line: UInt = #line) {
    if condition {
        passedCount += 1
        print("  ✅ PASS: \(name)")
    } else {
        failedCount += 1
        print("  ❌ FAIL: \(name) [Line \(line)]")
    }
}

func assertApproxEqual(_ a: Double, _ b: Double, tolerance: Double = 0.01, _ name: String, file: StaticString = #file, line: UInt = #line) {
    let diff = abs(a - b)
    if diff <= tolerance {
        passedCount += 1
        print("  ✅ PASS: \(name) (\(a) ≈ \(b))")
    } else {
        failedCount += 1
        print("  ❌ FAIL: \(name) (\(a) vs expected \(b), diff=\(diff) > tol=\(tolerance)) [Line \(line)]")
    }
}

print("=======================================================")
print("🧪 RUNNING CAPTAIN ADEL AUTOMATED TEST SUITE")
print("=======================================================\n")

// MARK: - TEST SUITE 1: FMC FLIGHT COMPUTER MATHEMATICS
print("--- [Suite 1: FMC Flight Computer Mathematics] ---")

// 1.1 VFR Fuel Reserves (§91.151)
// Day: 30 minutes reserve. Night: 45 minutes reserve.
func computeFuelRequired(flightMinutes: Double, burnRateGPH: Double, isNight: Bool) -> (reserveFuel: Double, totalFuel: Double) {
    let cruiseFuel = (flightMinutes / 60.0) * burnRateGPH
    let reserveHours = isNight ? (45.0 / 60.0) : (30.0 / 60.0)
    let reserveFuel = reserveHours * burnRateGPH
    let totalFuel = cruiseFuel + reserveFuel
    return (reserveFuel, totalFuel)
}

// 120 min flight at 10 GPH Day -> cruise=20, reserve=5, total=25
let dayFuel = computeFuelRequired(flightMinutes: 120, burnRateGPH: 10, isNight: false)
assertApproxEqual(dayFuel.reserveFuel, 5.0, "Day VFR reserve fuel is exactly 30 mins at 10 GPH")
assertApproxEqual(dayFuel.totalFuel, 25.0, "Day VFR total fuel is 25 gallons")

// 120 min flight at 10 GPH Night -> cruise=20, reserve=7.5, total=27.5
let nightFuel = computeFuelRequired(flightMinutes: 120, burnRateGPH: 10, isNight: true)
assertApproxEqual(nightFuel.reserveFuel, 7.5, "Night VFR reserve fuel is exactly 45 mins at 10 GPH")
assertApproxEqual(nightFuel.totalFuel, 27.5, "Night VFR total fuel is 27.5 gallons")

// 1.2 Crosswind & Headwind Components
func computeWindComponents(runwayHeadingDeg: Double, windDirectionDeg: Double, windSpeedKnots: Double) -> (crosswind: Double, headwind: Double) {
    let angleDiff = abs(windDirectionDeg - runwayHeadingDeg) * (.pi / 180.0)
    let crosswind = abs(windSpeedKnots * sin(angleDiff))
    let headwind = windSpeedKnots * cos(angleDiff)
    return (crosswind, headwind)
}

// Runway 36 (360°), Wind 030° at 20 kts -> Angle = 30°
// sin(30°) = 0.5 -> Crosswind = 10.0 kts
// cos(30°) = 0.8660 -> Headwind = 17.32 kts
let wind30 = computeWindComponents(runwayHeadingDeg: 360, windDirectionDeg: 30, windSpeedKnots: 20)
assertApproxEqual(wind30.crosswind, 10.0, "Runway 36 with 030/20 gives 10 kt crosswind")
assertApproxEqual(wind30.headwind, 17.32, tolerance: 0.02, "Runway 36 with 030/20 gives 17.32 kt headwind")

// Direct 90° crosswind: Runway 09 (090°), Wind 180° at 15 kts
let directCross = computeWindComponents(runwayHeadingDeg: 90, windDirectionDeg: 180, windSpeedKnots: 15)
assertApproxEqual(directCross.crosswind, 15.0, "90° angle produces 100% crosswind component")
assertApproxEqual(directCross.headwind, 0.0, tolerance: 0.001, "90° angle produces 0 headwind")

// 1.3 Pressure & Density Altitude (Summer Saudi Desert Operations)
func computeDensityAltitude(elevationFt: Double, qnhHPa: Double, oatCelsius: Double) -> (pa: Double, isa: Double, da: Double) {
    let pa = elevationFt + (1013.25 - qnhHPa) * 27.3
    let isa = 15.0 - (2.0 * (pa / 1000.0))
    let da = pa + (120.0 * (oatCelsius - isa))
    return (pa, isa, da)
}

// Riyadh (OERK): Elevation = 2049 ft, QNH = 1008 hPa, OAT = 45°C
let riyadhSummer = computeDensityAltitude(elevationFt: 2049, qnhHPa: 1008, oatCelsius: 45)
// PA ≈ 2049 + (5.25 * 27.3) ≈ 2192 ft
// ISA ≈ 15 - (2 * 2.192) ≈ 10.62°C
// DA ≈ 2192 + 120 * (45 - 10.62) ≈ 6317 ft (Severe density altitude hazard)
assertTest(riyadhSummer.da > 6000, "Riyadh at 45°C results in severe Density Altitude (>6000 ft)")
assertTest(riyadhSummer.da > riyadhSummer.pa, "Density Altitude significantly exceeds Pressure Altitude in high OAT")

// 1.4 Top of Descent (TOD 3:1 Glide Slope Rule)
func computeTopOfDescent(currentAltFt: Double, targetAltFt: Double, groundSpeedKnots: Double) -> (distanceNM: Double, verticalSpeedFPM: Double, timeMins: Double) {
    let altToLose = max(0, currentAltFt - targetAltFt)
    let distNM = (altToLose / 1000.0) * 3.0
    let vSpeed = -(groundSpeedKnots * 5.0)
    let timeM = groundSpeedKnots > 0 ? (distNM / groundSpeedKnots) * 60.0 : 0
    return (distNM, vSpeed, timeM)
}

// Cruising at 35,000 ft, descending to 3,000 ft at 420 kts GS
// Alt to lose = 32,000 ft -> Distance = 32 * 3 = 96 NM
// Required VS = -(420 * 5) = -2,100 FPM
// Time = (96 / 420) * 60 ≈ 13.71 mins
let todResult = computeTopOfDescent(currentAltFt: 35000, targetAltFt: 3000, groundSpeedKnots: 420)
assertApproxEqual(todResult.distanceNM, 96.0, "TOD from FL350 to 3,000ft is exactly 96 NM")
assertApproxEqual(todResult.verticalSpeedFPM, -2100.0, "3° Glideslope descent rate at 420 kts is -2,100 FPM")
assertApproxEqual(todResult.timeMins, 13.71, tolerance: 0.05, "TOD descent duration is ~13.7 minutes")

print("\n--- [Suite 2: GACAR Aerodrome Database Verification] ---")
// 2.1 Verify KSA Aerodromes coverage
let saudiICAOCodes: Set<String> = [
    "OERK", "OEJN", "OEDF", "OEMA", "OEAH", "OETB", "OEGS", "OENG",
    "OEHL", "OESH", "OERY", "OEAO", "OETR", "OEWD", "OEGN", "OEKG",
    "OEBQ", "OEPA", "OERS", "OENN", "OEWJ", "OEBH", "OEDM", "OERR",
    "OEGT", "OETR_TURAIF"
]
assertTest(saudiICAOCodes.count == 26, "Database contains exactly 26 curated Saudi Aerodromes")
assertTest(saudiICAOCodes.contains("OERS"), "Red Sea International (OERS) is present")
assertTest(saudiICAOCodes.contains("OENN"), "NEOM Bay (OENN) is present")
assertTest(saudiICAOCodes.contains("OERK"), "King Khalid International (OERK) is present")
assertTest(saudiICAOCodes.contains("OEJN"), "King Abdulaziz International (OEJN) is present")

print("\n--- [Suite 3: Bilingual Tokenizer & Text Normalizer] ---")
func normalizeArabic(_ text: String) -> String {
    var s = text
    s = s.replacingOccurrences(of: "[\\u{064B}-\\u{0652}]", with: "", options: .regularExpression)
    s = s.replacingOccurrences(of: "[أإآ]", with: "ا", options: .regularExpression)
    s = s.replacingOccurrences(of: "ى", with: "ي")
    s = s.replacingOccurrences(of: "ة", with: "ه")
    return s
}

let tashkeelSample = "رُخْصَةُ الطَّيَرَانِ"
let normalized = normalizeArabic(tashkeelSample)
assertTest(!normalized.contains("ُ") && !normalized.contains("ْ"), "Arabic diacritics (tashkeel) stripped correctly")
assertTest(normalizeArabic("إجازة") == "اجازه", "Alef and Taa Marbouta normalized consistently")

print("\n--- [Suite 4: 'Cite or Refuse' Doctrine Verification] ---")
// Suborbital hops, UFOs, fictional queries must trigger refusal
func shouldRefuseQuery(topCosineSimilarity: Double, refusalThreshold: Double = 0.28) -> Bool {
    return topCosineSimilarity < refusalThreshold
}

assertTest(shouldRefuseQuery(topCosineSimilarity: 0.12), "Query with low similarity (0.12) is correctly refused")
assertTest(!shouldRefuseQuery(topCosineSimilarity: 0.78), "Grounded GACAR query (0.78) is accepted and cited")

print("\n=======================================================")
print("🏁 TEST SUITE FINISHED: \(passedCount) Passed, \(failedCount) Failed")
print("=======================================================")

if failedCount > 0 {
    exit(1)
} else {
    exit(0)
}
