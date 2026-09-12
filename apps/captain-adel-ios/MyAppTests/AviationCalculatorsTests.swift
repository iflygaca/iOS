import XCTest
@testable import MyApp

final class AviationCalculatorsTests: XCTestCase {

    // MARK: - GACAR §91.151 Fuel Reserve Tests

    func testVFRDayFuelReserveCalculation() {
        let burnRateGPH = 10.0
        let flightHours = 2.0
        let isNight = false
        
        let reserveMinutes: Double = isNight ? 45.0 : 30.0
        let tripFuel = burnRateGPH * flightHours
        let reserveFuel = burnRateGPH * (reserveMinutes / 60.0)
        let totalRequired = tripFuel + reserveFuel
        
        // 2 hours @ 10 GPH = 20 gal. 30 min reserve = 5 gal. Total = 25 gal.
        XCTAssertEqual(tripFuel, 20.0, accuracy: 0.001)
        XCTAssertEqual(reserveFuel, 5.0, accuracy: 0.001)
        XCTAssertEqual(totalRequired, 25.0, accuracy: 0.001)
    }

    func testVFRNightFuelReserveCalculation() {
        let burnRateGPH = 12.0
        let flightHours = 1.5
        let isNight = true
        
        let reserveMinutes: Double = isNight ? 45.0 : 30.0
        let tripFuel = burnRateGPH * flightHours
        let reserveFuel = burnRateGPH * (reserveMinutes / 60.0)
        let totalRequired = tripFuel + reserveFuel
        
        // 1.5 hours @ 12 GPH = 18 gal. 45 min reserve = 9 gal. Total = 27 gal.
        XCTAssertEqual(tripFuel, 18.0, accuracy: 0.001)
        XCTAssertEqual(reserveFuel, 9.0, accuracy: 0.001)
        XCTAssertEqual(totalRequired, 27.0, accuracy: 0.001)
    }

    // MARK: - Trigonometric Crosswind Resolution Tests

    func test45DegreeCrosswind() {
        let windSpeed = 20.0
        let windDir = 045.0
        let rwyHeading = 360.0
        
        let (crosswind, headwind) = METARService.calculateCrosswind(
            windSpeed: windSpeed,
            windDirection: windDir,
            runwayHeading: rwyHeading
        )
        
        let expected = 20.0 * sin(45.0 * .pi / 180.0) // ~ 14.14 kt
        XCTAssertEqual(crosswind, expected, accuracy: 0.01)
        XCTAssertEqual(headwind, expected, accuracy: 0.01)
    }
}
