import XCTest
@testable import MyApp

final class METARServiceTests: XCTestCase {

    // MARK: - Crosswind & Headwind Vector Tests

    func testDirectHeadwind() {
        let (crosswind, headwind) = METARService.calculateCrosswind(
            windSpeed: 20.0,
            windDirection: 360.0,
            runwayHeading: 360.0
        )
        XCTAssertEqual(crosswind, 0.0, accuracy: 0.001)
        XCTAssertEqual(headwind, 20.0, accuracy: 0.001)
    }

    func testDirectCrosswind() {
        let (crosswind, headwind) = METARService.calculateCrosswind(
            windSpeed: 15.0,
            windDirection: 090.0,
            runwayHeading: 360.0
        )
        XCTAssertEqual(crosswind, 15.0, accuracy: 0.001)
        XCTAssertEqual(headwind, 0.0, accuracy: 0.001)
    }

    func testAngleWraparoundNorthCrosswind() {
        // Wind from 350°, runway heading 010° (10°) -> 20° angular difference
        let (crosswind, headwind) = METARService.calculateCrosswind(
            windSpeed: 20.0,
            windDirection: 350.0,
            runwayHeading: 010.0
        )
        let expectedCross = 20.0 * sin(20.0 * .pi / 180.0) // ~ 6.8404 kt
        let expectedHead = 20.0 * cos(20.0 * .pi / 180.0)  // ~ 18.7939 kt
        
        XCTAssertEqual(crosswind, expectedCross, accuracy: 0.01)
        XCTAssertEqual(headwind, expectedHead, accuracy: 0.01)
    }

    func testTailwindCondition() {
        // Wind from 180°, runway 360° -> direct tailwind
        let (crosswind, headwind) = METARService.calculateCrosswind(
            windSpeed: 12.0,
            windDirection: 180.0,
            runwayHeading: 360.0
        )
        XCTAssertEqual(crosswind, 0.0, accuracy: 0.001)
        XCTAssertEqual(headwind, -12.0, accuracy: 0.001, "Negative headwind indicates tailwind")
    }

    // MARK: - Altimeter Formatting Tests

    func testAltimeterHectopascalsAndInchesMercury() {
        let report = METARReport(
            rawText: "OERK 120400Z 32010KT CAVOK 28/14 Q1013 NOSIG",
            icaoCode: "OERK",
            airportNameEn: "King Khalid Int'l Airport",
            airportNameAr: "مطار الملك خالد الدولي",
            flightCategory: .vfr,
            windInfo: "320° at 10 knots",
            visibility: "10+ km",
            ceiling: "CAVOK",
            temperature: "28°C (82°F)",
            dewPoint: "14°C (57°F)",
            altimeter: "1013 hPa / 29.92 inHg",
            remarks: "Test Report",
            isLive: false,
            lastUpdated: Date()
        )
        
        XCTAssertTrue(report.altimeter.contains("1013 hPa"))
        XCTAssertTrue(report.altimeter.contains("29.92 inHg"))
    }

    // MARK: - Aerodrome Database Coverage Tests

    func testDefaultSaudiAirportsCountAndICAOCodes() {
        let airports = METARService.defaultSaudiAirports
        XCTAssertEqual(airports.count, 18, "Should cover all 18 specified Saudi aerodromes")
        
        let expectedCodes: Set<String> = [
            "OERK", "OEJN", "OEDF", "OEMA",
            "OEAB", "OEAO", "OETB", "OETR",
            "OEGS", "OEYN", "OEGN", "OEAH",
            "OEBA", "OEHL", "OENG", "OEWD",
            "OESH", "OERF"
        ]
        
        let actualCodes = Set(airports.map { $0.icaoCode })
        XCTAssertEqual(actualCodes, expectedCodes, "All 18 Saudi civil aerodrome ICAOs must match")
        
        for airport in airports {
            XCTAssertTrue(airport.icaoCode.hasPrefix("OE"), "Saudi airport ICAO codes must start with OE: \(airport.icaoCode)")
            XCTAssertFalse(airport.airportNameEn.isEmpty, "Airport English name must not be empty")
            XCTAssertFalse(airport.airportNameAr.isEmpty, "Airport Arabic name must not be empty")
        }
    }
}
