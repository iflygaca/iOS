import SwiftUI

struct METARService {
    
    static let saudiAirports: [METARReport] = [
        METARReport(
            rawText: "OERK 080300Z 12008KT 9999 NSC 28/14 Q1016 NOSIG",
            icaoCode: "OERK",
            airportNameEn: "King Khalid Int'l (Riyadh)",
            airportNameAr: "مطار الملك خالد الدولي (الرياض)",
            flightCategory: .vfr,
            windInfo: "120° at 8 knots",
            visibility: "10+ km (6+ miles)",
            ceiling: "Clear / No Significant Cloud",
            temperature: "28°C (82°F)",
            dewPoint: "14°C (57°F)",
            altimeter: "1016 hPa / 30.00 inHg",
            remarks: "NOSIG (No significant change expected)"
        ),
        METARReport(
            rawText: "OEJN 080300Z 27014G22KT 8000 DU FEW020 34/26 Q1009",
            icaoCode: "OEJN",
            airportNameEn: "King Abdulaziz Int'l (Jeddah)",
            airportNameAr: "مطار الملك عبد العزيز الدولي (جدة)",
            flightCategory: .mvfr,
            windInfo: "270° at 14 knots, gusts 22 knots",
            visibility: "8,000 meters (Dust/Haze)",
            ceiling: "Few clouds at 2,000 ft",
            temperature: "34°C (93°F)",
            dewPoint: "26°C (79°F)",
            altimeter: "1009 hPa / 29.80 inHg",
            remarks: "Blowing dust in coastal area"
        ),
        METARReport(
            rawText: "OEDF 080300Z 35018KT 6000 HZ NSC 36/18 Q1011",
            icaoCode: "OEDF",
            airportNameEn: "King Fahd Int'l (Dammam)",
            airportNameAr: "مطار الملك فهد الدولي (الدمام)",
            flightCategory: .mvfr,
            windInfo: "350° at 18 knots",
            visibility: "6,000 meters (Haze)",
            ceiling: "Clear",
            temperature: "36°C (97°F)",
            dewPoint: "18°C (64°F)",
            altimeter: "1011 hPa / 29.85 inHg",
            remarks: "Haze reduces slant range visibility"
        ),
        METARReport(
            rawText: "OEMA 080300Z 04006KT 9999 CAVOK 26/12 Q1018",
            icaoCode: "OEMA",
            airportNameEn: "Prince Mohammad Int'l (Madinah)",
            airportNameAr: "مطار الأمير محمد بن عبد العزيز (المدينة المنورة)",
            flightCategory: .vfr,
            windInfo: "040° at 6 knots",
            visibility: "CAVOK (10+ km)",
            ceiling: "Clouds & Visibility OK",
            temperature: "26°C (79°F)",
            dewPoint: "12°C (54°F)",
            altimeter: "1018 hPa / 30.06 inHg",
            remarks: "Ideal VFR flying conditions"
        ),
        METARReport(
            rawText: "OEAB 080300Z 18012KT 4000 TSRA BKN015CB 19/16 Q1022",
            icaoCode: "OEAB",
            airportNameEn: "Abha Regional Airport (Abha)",
            airportNameAr: "مطار أبها الإقليمي (أبها)",
            flightCategory: .ifr,
            windInfo: "180° at 12 knots",
            visibility: "4,000 meters (Thunderstorm & Rain)",
            ceiling: "Broken Cumulonimbus at 1,500 ft",
            temperature: "19°C (66°F)",
            dewPoint: "16°C (61°F)",
            altimeter: "1022 hPa / 30.18 inHg",
            remarks: "High elevation airfield (6,858 ft MSL) with thunderstorm"
        )
    ]
    
    // Crosswind Component calculation helper
    static func calculateCrosswind(windSpeed: Double, windDirection: Double, runwayHeading: Double) -> (crosswind: Double, headwind: Double) {
        let angleDegrees = abs(windDirection - runwayHeading)
        let angleRadians = angleDegrees * .pi / 180.0
        let crosswind = abs(windSpeed * sin(angleRadians))
        let headwind = windSpeed * cos(angleRadians)
        return (crosswind, headwind)
    }
}
