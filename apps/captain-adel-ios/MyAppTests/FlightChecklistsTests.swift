import XCTest
@testable import MyApp

final class FlightChecklistsTests: XCTestCase {

    func testDefaultChecklistsDatabasePopulated() {
        let checklists = CockpitChecklistDatabase.defaultChecklists()
        XCTAssertGreaterThan(checklists.count, 0, "Checklists database must not be empty")
        
        let normalChecklists = checklists.filter { $0.checklistType == .normal }
        let emergencyChecklists = checklists.filter { $0.checklistType == .emergency }
        
        XCTAssertFalse(normalChecklists.isEmpty, "Normal procedures must exist")
        XCTAssertFalse(emergencyChecklists.isEmpty, "Emergency procedures must exist")
    }

    func testPreflightChecklistContentAndGACARReference() {
        let checklists = CockpitChecklistDatabase.defaultChecklists()
        guard let preflight = checklists.first(where: { $0.id == "preflight_normal" }) else {
            XCTFail("Preflight checklist not found")
            return
        }
        
        XCTAssertTrue(preflight.gacarRef.contains("91.9") || preflight.gacarRef.contains("91.203"))
        XCTAssertEqual(preflight.items.count, 5)
        
        let arrowItem = preflight.items.first { $0.itemEn.contains("ARROW") }
        XCTAssertNotNil(arrowItem, "ARROW documents inspection must be in preflight checklist")
    }

    func testChecklistProgressCalculation() {
        var checklist = FlightChecklist(
            id: "test_list",
            titleEn: "Test List",
            titleAr: "قائمة اختبار",
            subtitleEn: "Testing",
            subtitleAr: "اختبار",
            type: "normal",
            gacarRef: "§ 91.1",
            items: [
                FlightChecklistItem(itemEn: "Item 1", actionEn: "CHECK", itemAr: "بند 1", actionAr: "فحص"),
                FlightChecklistItem(itemEn: "Item 2", actionEn: "CHECK", itemAr: "بند 2", actionAr: "فحص"),
                FlightChecklistItem(itemEn: "Item 3", actionEn: "CHECK", itemAr: "بند 3", actionAr: "فحص"),
                FlightChecklistItem(itemEn: "Item 4", actionEn: "CHECK", itemAr: "بند 4", actionAr: "فحص")
            ]
        )
        
        XCTAssertEqual(checklist.progress, 0.0)
        XCTAssertFalse(checklist.isComplete)
        
        checklist.items[0].isCompleted = true
        checklist.items[1].isCompleted = true
        XCTAssertEqual(checklist.progress, 0.5)
        XCTAssertFalse(checklist.isComplete)
        
        checklist.items[2].isCompleted = true
        checklist.items[3].isCompleted = true
        XCTAssertEqual(checklist.progress, 1.0)
        XCTAssertTrue(checklist.isComplete)
    }

    func testEmergencyQRFChecklistsPresence() {
        let checklists = CockpitChecklistDatabase.defaultChecklists()
        let emergencies = checklists.filter { $0.checklistType == .emergency }
        
        let hasEngineFailure = emergencies.contains { $0.id.contains("engine_failure") }
        XCTAssertTrue(hasEngineFailure, "QRF must include Engine Failure procedures")
    }
}
