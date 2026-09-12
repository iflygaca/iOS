import XCTest
@testable import MyApp

final class GACARCorpusDatabaseTests: XCTestCase {

    func testExact74PartsPresent() {
        let parts = GACARCorpusDatabase.allParts
        XCTAssertEqual(parts.count, 74, "Corpus must contain exactly 74 Saudi GACAR regulatory parts")
    }

    func testAllPartsHaveValidStructure() {
        let parts = GACARCorpusDatabase.allParts
        var seenIDs: Set<String> = []

        for part in parts {
            XCTAssertFalse(part.id.isEmpty, "Part ID must not be empty")
            XCTAssertFalse(seenIDs.contains(part.id), "Duplicate Part ID: \(part.id)")
            seenIDs.insert(part.id)

            XCTAssertTrue(part.partNumber.hasPrefix("GACAR Part"), "Part number must start with 'GACAR Part': \(part.partNumber)")
            XCTAssertFalse(part.titleEn.isEmpty, "Part \(part.partNumber) missing English title")
            XCTAssertFalse(part.titleAr.isEmpty, "Part \(part.partNumber) missing Arabic title")
            XCTAssertFalse(part.summaryEn.isEmpty, "Part \(part.partNumber) missing English summary")
            XCTAssertFalse(part.summaryAr.isEmpty, "Part \(part.partNumber) missing Arabic summary")
            XCTAssertFalse(part.keySections.isEmpty, "Part \(part.partNumber) must contain at least one key section")

            for section in part.keySections {
                XCTAssertFalse(section.sectionCode.isEmpty, "Section code must not be empty in \(part.partNumber)")
                XCTAssertFalse(section.titleEn.isEmpty, "Section \(section.sectionCode) missing English title")
                XCTAssertFalse(section.titleAr.isEmpty, "Section \(section.sectionCode) missing Arabic title")
                XCTAssertFalse(section.contentEn.isEmpty, "Section \(section.sectionCode) missing English content")
                XCTAssertFalse(section.contentAr.isEmpty, "Section \(section.sectionCode) missing Arabic content")
            }
        }
    }

    func testKeyAviationPartsPresent() {
        let parts = GACARCorpusDatabase.allParts
        let partNumbers = Set(parts.map { $0.partNumber })

        let essentialParts = [
            "GACAR Part 1",   // Definitions
            "GACAR Part 61",  // Certification: Pilots and Flight Instructors
            "GACAR Part 67",  // Medical Standards
            "GACAR Part 91",  // General Operating and Flight Rules
            "GACAR Part 107", // Small Unmanned Aircraft Systems
            "GACAR Part 121", // Air Carriers: Commercial Operations
            "GACAR Part 135", // Commuter and On-Demand Operations
            "GACAR Part 141", // Pilot Schools
            "GACAR Part 145"  // Approved Maintenance Organizations
        ]

        for essential in essentialParts {
            XCTAssertTrue(partNumbers.contains(essential), "Essential aviation part missing: \(essential)")
        }
    }
}
