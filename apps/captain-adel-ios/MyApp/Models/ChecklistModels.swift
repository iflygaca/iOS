import Foundation
import SwiftUI

// MARK: - Checklist Item
struct FlightChecklistItem: Identifiable, Codable, Equatable {
    let id: UUID
    let itemEn: String
    let actionEn: String
    let itemAr: String
    let actionAr: String
    var isCompleted: Bool = false
    let noteEn: String?
    let noteAr: String?

    init(
        id: UUID = UUID(),
        itemEn: String,
        actionEn: String,
        itemAr: String,
        actionAr: String,
        noteEn: String? = nil,
        noteAr: String? = nil
    ) {
        self.id = id
        self.itemEn = itemEn
        self.actionEn = actionEn
        self.itemAr = itemAr
        self.actionAr = actionAr
        self.isCompleted = false
        self.noteEn = noteEn
        self.noteAr = noteAr
    }
}

// MARK: - Checklist Category
enum ChecklistType: String, CaseIterable, Identifiable {
    case normal = "Normal Procedures"
    case emergency = "Emergency (QRF)"

    var id: String { rawValue }

    var arabicName: String {
        switch self {
        case .normal: return "الإجراءات الاعتيادية"
        case .emergency: return "طوارئ قمرة القيادة"
        }
    }

    var icon: String {
        switch self {
        case .normal: return "checkmark.shield.fill"
        case .emergency: return "exclamationmark.triangle.fill"
        }
    }

    var accentColor: Color {
        switch self {
        case .normal: return Color(red: 34/255, green: 211/255, blue: 238/255)
        case .emergency: return Color(red: 251/255, green: 191/255, blue: 36/255)
        }
    }
}

// MARK: - Checklist Model
struct FlightChecklist: Identifiable, Codable, Equatable {
    let id: String
    let titleEn: String
    let titleAr: String
    let subtitleEn: String
    let subtitleAr: String
    let type: String
    let gacarRef: String
    var items: [FlightChecklistItem]

    var checklistType: ChecklistType {
        type == "emergency" ? .emergency : .normal
    }

    var isComplete: Bool {
        !items.isEmpty && items.allSatisfy { $0.isCompleted }
    }

    var completedCount: Int {
        items.filter { $0.isCompleted }.count
    }

    var progress: Double {
        guard !items.isEmpty else { return 0 }
        return Double(completedCount) / Double(items.count)
    }
}

// MARK: - Standard Cockpit Database
enum CockpitChecklistDatabase {
    static func defaultChecklists() -> [FlightChecklist] {
        [
            // 1. PRE-FLIGHT
            FlightChecklist(
                id: "preflight_normal",
                titleEn: "Pre-Flight & Cockpit Prep",
                titleAr: "فحص ما قبل الإقلاع والوثائق",
                subtitleEn: "GACAR 91 Required Documents & Systems Walkaround",
                subtitleAr: "وثائق الطيران المعتمدة وأنظمة الفحص الأرضي",
                type: "normal",
                gacarRef: "GACAR § 91.9 / § 91.203",
                items: [
                    FlightChecklistItem(
                        itemEn: "ARROW Documents",
                        actionEn: "VERIFIED ONBOARD",
                        itemAr: "وثائق الطائرة (ARROW)",
                        actionAr: "مُحققة ومكتملة",
                        noteEn: "Airworthiness, Registration, Radio, Operating Limits, Weight/Balance",
                        noteAr: "شهادة الصلاحية، التسجيل، الترخيص اللاسلكي، كتيب التشغيل والوزن والاتزان"
                    ),
                    FlightChecklistItem(
                        itemEn: "Control Locks & Pitot Cover",
                        actionEn: "REMOVED & STOWED",
                        itemAr: "أقفال التحكم وغطاء أنبوب البيتوت",
                        actionAr: "مُزالة ومخزنة"
                    ),
                    FlightChecklistItem(
                        itemEn: "Master Switch",
                        actionEn: "ON / FUEL GAUGES CHECK",
                        itemAr: "المفتاح الرئيسي (Master)",
                        actionAr: "تشغيل وفحص مؤشرات الوقود"
                    ),
                    FlightChecklistItem(
                        itemEn: "Fuel Quantity & Strainers",
                        actionEn: "CHECKED & SUMPED",
                        itemAr: "كمية الوقود ونقاط التصريف",
                        actionAr: "تم الفحص وسحب عينات النقاء"
                    ),
                    FlightChecklistItem(
                        itemEn: "Avionics & Circuit Breakers",
                        actionEn: "OFF / ALL IN",
                        itemAr: "أجهزة الملاحة وقواطع الدوائر",
                        actionAr: "إغلاق / متصلة بالكامل"
                    )
                ]
            ),

            // 2. BEFORE TAKEOFF & RUN-UP
            FlightChecklist(
                id: "before_takeoff",
                titleEn: "Before Takeoff / Engine Run-Up",
                titleAr: "قبل الإقلاع وتجربة المحرك",
                subtitleEn: "Engine Magnetos, Controls & Takeoff Configuration",
                subtitleAr: "فحص مغناطيس الإشعال وأسطح التوجيه وتجهيز الإقلاع",
                type: "normal",
                gacarRef: "GACAR § 91.103",
                items: [
                    FlightChecklistItem(
                        itemEn: "Flight Controls",
                        actionEn: "FREE & CORRECT",
                        itemAr: "أسطح التحكم في الطيران",
                        actionAr: "حرة وتتحرك بالاتجاه الصحيح"
                    ),
                    FlightChecklistItem(
                        itemEn: "Engine Run-Up (1700-1800 RPM)",
                        actionEn: "MAGNETOS & CARB HEAT CHECK",
                        itemAr: "دورة المحرك (1700 د.د)",
                        actionAr: "فحص المغناطيس وتسخين المكربن"
                    ),
                    FlightChecklistItem(
                        itemEn: "Trim Tab",
                        actionEn: "SET FOR TAKEOFF",
                        itemAr: "موازن الارتفاع (Trim)",
                        actionAr: "مضبوط لوضعية الإقلاع"
                    ),
                    FlightChecklistItem(
                        itemEn: "Flaps",
                        actionEn: "SET 0° - 10°",
                        itemAr: "الجنيحات الإضافية (Flaps)",
                        actionAr: "مضبوطة 0 إلى 10 درجات"
                    ),
                    FlightChecklistItem(
                        itemEn: "Transponder",
                        actionEn: "ALT / SQUAWK ASSIGNED",
                        itemAr: "جهاز التعارف الراداري (XPDR)",
                        actionAr: "وضع ALT ورمز البرج المعتمد"
                    )
                ]
            ),

            // 3. CRUISE & LEVEL-OFF
            FlightChecklist(
                id: "cruise_enroute",
                titleEn: "Cruise & Level-Off",
                titleAr: "الطيران المستوي وارتفاع السفر",
                subtitleEn: "FL380 / VFR Cruise Power & Altimeter Settings",
                subtitleAr: "ضبط القدرة ومقياس الارتفاع ومراقبة المحرك",
                type: "normal",
                gacarRef: "GACAR § 91.121 / § 91.159",
                items: [
                    FlightChecklistItem(
                        itemEn: "Altimeter",
                        actionEn: "SET LOCAL QNH (OR 1013 HPA > TL)",
                        itemAr: "مقياس الارتفاع",
                        actionAr: "مضبوط حسب الضغط المحلي أو القياسي"
                    ),
                    FlightChecklistItem(
                        itemEn: "Cruise Power",
                        actionEn: "SET (2300-2400 RPM)",
                        itemAr: "قدرة الطيران المستوي",
                        actionAr: "مضبوطة حسب الكتيب"
                    ),
                    FlightChecklistItem(
                        itemEn: "Mixture",
                        actionEn: "LEANED AS REQUIRED",
                        itemAr: "خليط الوقود والهواء",
                        actionAr: "تخفيف الخليط حسب الارتفاع"
                    ),
                    FlightChecklistItem(
                        itemEn: "Engine Instruments",
                        actionEn: "ALL IN THE GREEN",
                        itemAr: "مؤشرات المحرك والحرارة والزيت",
                        actionAr: "جميع القراءات في النطاق الأخضر"
                    )
                ]
            ),

            // 4. BEFORE LANDING
            FlightChecklist(
                id: "before_landing",
                titleEn: "Before Landing / Final Approach",
                titleAr: "قبل الهبوط والاقتراب النهائي",
                subtitleEn: "Runway Alignment, Flaps & Speed Control",
                subtitleAr: "محاذاة المدرج والجنيحات والسرعة الجوية",
                type: "normal",
                gacarRef: "GACAR § 91.129",
                items: [
                    FlightChecklistItem(
                        itemEn: "Seatbelts & Harnesses",
                        actionEn: "SECURE",
                        itemAr: "أحزمة الأمان للركاب والطاقم",
                        actionAr: "محكمة الإغلاق"
                    ),
                    FlightChecklistItem(
                        itemEn: "Fuel Selector",
                        actionEn: "FULLEST TANK / BOTH",
                        itemAr: "مفتاح خزان الوقود",
                        actionAr: "الخزان الأكبر أو كلاهما"
                    ),
                    FlightChecklistItem(
                        itemEn: "Mixture",
                        actionEn: "FULL RICH",
                        itemAr: "خليط الوقود",
                        actionAr: "كامل الغنى (Rich)"
                    ),
                    FlightChecklistItem(
                        itemEn: "Carburetor Heat",
                        actionEn: "ON (AS REQUIRED)",
                        itemAr: "سخان المكربن",
                        actionAr: "تشغيل عند الحاجة لتفادي التثليج"
                    ),
                    FlightChecklistItem(
                        itemEn: "Flaps & Approach Speed",
                        actionEn: "FULL / Vref STABLE",
                        itemAr: "الجنيحات وسرعة الاقتراب",
                        actionAr: "مفتوحة بالكامل وسرعة مستقرة"
                    )
                ]
            ),

            // 5. EMERGENCY: ENGINE FAILURE IN FLIGHT
            FlightChecklist(
                id: "emerg_engine_fail",
                titleEn: "EMERGENCY: Engine Failure In Flight",
                titleAr: "طوارئ: توقف المحرك أثناء الطيران",
                subtitleEn: "Best Glide, Restart Attempt & Forced Landing",
                subtitleAr: "أفضل سرعة انزلاق، محاولة إعادة التشغيل والهبوط الاضطراري",
                type: "emergency",
                gacarRef: "GACAR § 91.3 (Emergency Authority)",
                items: [
                    FlightChecklistItem(
                        itemEn: "Airspeed (Best Glide)",
                        actionEn: "65 - 68 KIAS (IMMEDIATE)",
                        itemAr: "السرعة الجوية (أفضل انزلاق)",
                        actionAr: "65 إلى 68 عقدة فوراً",
                        noteEn: "Maintain pitch attitude immediately. Trim aircraft for hands-off glide.",
                        noteAr: "حافظ على زاوية الميل فوراً واضبط الموازن للانزلاق الحر."
                    ),
                    FlightChecklistItem(
                        itemEn: "Best Field / Landing Area",
                        actionEn: "SELECTED & TURN TOWARD",
                        itemAr: "أفضل حقل أو مهبط للهبوط",
                        actionAr: "تحديد الموقع والالتفاف نحوه"
                    ),
                    FlightChecklistItem(
                        itemEn: "Fuel Shutoff Valve",
                        actionEn: "ON / BOTH",
                        itemAr: "صمام قفل الوقود",
                        actionAr: "تشغيل / كلا الخزانين"
                    ),
                    FlightChecklistItem(
                        itemEn: "Mixture",
                        actionEn: "FULL RICH",
                        itemAr: "خليط الوقود",
                        actionAr: "غني بالكامل"
                    ),
                    FlightChecklistItem(
                        itemEn: "Carburetor Heat",
                        actionEn: "ON",
                        itemAr: "سخان المكربن",
                        actionAr: "تشغيل لإزالة أي تثليج"
                    ),
                    FlightChecklistItem(
                        itemEn: "Ignition / Magnetos",
                        actionEn: "BOTH (CHECK START IF PROPELLER STOPPED)",
                        itemAr: "مفتاح الإشعال والمغناطيس",
                        actionAr: "الوضع كلاهما (BOTH) ومحاولة التشغيل"
                    ),
                    FlightChecklistItem(
                        itemEn: "Transponder",
                        actionEn: "SQUAWK 7700",
                        itemAr: "جهاز التعارف الراداري (XPDR)",
                        actionAr: "الرمز 7700 (طوارئ عامة)"
                    ),
                    FlightChecklistItem(
                        itemEn: "Radio Distress Call",
                        actionEn: "MAYDAY 121.500 MHz",
                        itemAr: "نداء استغاثة راديوي",
                        actionAr: "ميداي على تردد الطوارئ 121.500 ميجاهرتز"
                    )
                ]
            ),

            // 6. EMERGENCY: ELECTRICAL FIRE
            FlightChecklist(
                id: "emerg_elec_fire",
                titleEn: "EMERGENCY: Electrical Fire in Flight",
                titleAr: "طوارئ: حريق كهربائي في القمرة",
                subtitleEn: "Master Switch Isolation & Cabin Smoke Clearing",
                subtitleAr: "عزل النظام الكهربائي وتصريف الدخان من القمرة",
                type: "emergency",
                gacarRef: "GACAR § 91.3 Emergency Operating Procedures",
                items: [
                    FlightChecklistItem(
                        itemEn: "Master Switch",
                        actionEn: "OFF IMMEDIATELY",
                        itemAr: "المفتاح الرئيسي (Master)",
                        actionAr: "إغلاق فوري لعزل التيار"
                    ),
                    FlightChecklistItem(
                        itemEn: "Avionics Power Switch",
                        actionEn: "OFF",
                        itemAr: "مفتاح أجهزة الملاحة والاتصال",
                        actionAr: "إغلاق"
                    ),
                    FlightChecklistItem(
                        itemEn: "All Other Electrical Switches",
                        actionEn: "OFF",
                        itemAr: "جميع مفاتيح الأنظمة الكهربائية",
                        actionAr: "إغلاق كامل"
                    ),
                    FlightChecklistItem(
                        itemEn: "Cabin Air & Heat Vents",
                        actionEn: "CLOSED (TO PREVENT DRAFT)",
                        itemAr: "فتحات تهوية وتسخين القمرة",
                        actionAr: "إغلاق لمنع دخول الدخان أو اشتداد الحريق"
                    ),
                    FlightChecklistItem(
                        itemEn: "Fire Extinguisher",
                        actionEn: "DISCHARGE AT BASE OF FLAME",
                        itemAr: "طفّاية الحريق اليدوية",
                        actionAr: "توجيه وتفريغ على قاعدة اللهب"
                    ),
                    FlightChecklistItem(
                        itemEn: "Emergency Landing",
                        actionEn: "LAND AS SOON AS POSSIBLE",
                        itemAr: "الهبوط الاضطراري",
                        actionAr: "الهبوط في أقرب مهبط فوراً"
                    )
                ]
            ),

            // 7. EMERGENCY: SPIN RECOVERY (PARE)
            FlightChecklist(
                id: "emerg_spin_recovery",
                titleEn: "EMERGENCY: Spin Recovery (PARE)",
                titleAr: "طوارئ: الخروج من الدوران المغزلي (PARE)",
                subtitleEn: "Standard Aerodynamic Spin Recovery Technique",
                subtitleAr: "القاعدة الديناميكية المعتمدة للخروج من الانعطاف الحلزوني",
                type: "emergency",
                gacarRef: "GACAR Flight Instructor Manual / AC 61-67",
                items: [
                    FlightChecklistItem(
                        itemEn: "P - Power",
                        actionEn: "IDLE (THROTTLE CLOSED)",
                        itemAr: "P - القدرة (Power)",
                        actionAr: "سحب الخانق للحد الأدنى (Idle)"
                    ),
                    FlightChecklistItem(
                        itemEn: "A - Ailerons",
                        actionEn: "NEUTRAL",
                        itemAr: "A - جنيحات التوجيه (Ailerons)",
                        actionAr: "وضع الحياد تماماً (Neutral)"
                    ),
                    FlightChecklistItem(
                        itemEn: "R - Rudder",
                        actionEn: "FULL OPPOSITE TO ROTATION",
                        itemAr: "R - دفة التوجيه (Rudder)",
                        actionAr: "ضغط كامل عكس اتجاه الدوران"
                    ),
                    FlightChecklistItem(
                        itemEn: "E - Elevator",
                        actionEn: "BRISKLY FORWARD TO BREAK STALL",
                        itemAr: "E - موازن الرفع (Elevator)",
                        actionAr: "دفع سريع للأمام لكسر الانهيار الهوائي"
                    )
                ]
            )
        ]
    }
}
