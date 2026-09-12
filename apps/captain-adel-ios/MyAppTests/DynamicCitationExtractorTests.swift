import XCTest
@testable import MyApp

@MainActor
final class DynamicCitationExtractorTests: XCTestCase {

    func testExtractCitationsFromAIResponse() {
        let service = CaptainAdelAIService()
        let sampleResponse = """
        According to GACAR §91.155, VFR weather minima require 5 km flight visibility.
        Furthermore, GACAR §61.103 sets private pilot eligibility requirements.
        """
        
        let citations = service.extractCitations(from: sampleResponse)
        XCTAssertEqual(citations.count, 2, "Should extract exactly 2 citations")
        
        let sectionCodes = Set(citations.map { $0.sectionNumber })
        XCTAssertTrue(sectionCodes.contains("91.155"))
        XCTAssertTrue(sectionCodes.contains("61.103"))
    }

    func testExtractCitationsNoMatch() {
        let service = CaptainAdelAIService()
        let responseWithoutGACAR = "Good morning captain, the flight deck is ready for engine start."
        
        let citations = service.extractCitations(from: responseWithoutGACAR)
        XCTAssertTrue(citations.isEmpty, "No citations should be found if no section code is present")
    }
}
