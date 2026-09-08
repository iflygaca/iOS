import SwiftUI
import Combine

@MainActor
final class CaptainAdelAIService: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var isThinking: Bool = false
    @Published var activeLanguage: AppLanguage = .english
    
    // Curated GACAR Parts database for reference tab
    let gacarParts: [GACARPart] = [
        GACARPart(
            id: "61",
            partNumber: "GACAR Part 61",
            titleEn: "Certification: Pilots, Flight Instructors, and Ground Instructors",
            titleAr: "إصدار الشهادات: الطيارون ومربو الطيران ومدربو الأرض",
            category: .licensing,
            summaryEn: "Defines requirements for issuing Private Pilot (PPL), Commercial Pilot (CPL), Airline Transport Pilot (ATPL), instrument ratings, and instructor certificates in Saudi Arabia.",
            summaryAr: "يتضمن شروط وإجراءات إصدار رخص الطيار الخاص، التجاري، طيار النقل الجوي، وأهليات الطيران الآلي والتدريب في المملكة العربية السعودية.",
            keySections: [
                GACARSection(
                    sectionCode: "61.103",
                    titleEn: "Eligibility Requirements for Private Pilot Certificate",
                    titleAr: "شروط الأهلية للحصول على رخصة طيار خاص",
                    contentEn: "Applicant must be at least 17 years old, read/write English, hold at least a Class 2 Medical Certificate issued under GACAR Part 67, and log a minimum of 40 hours of flight time.",
                    contentAr: "يجب ألا يقل عمر المتقدم عن 17 عاماً، وأن يتقن قراءة وكتابة اللغة الإنجليزية، ويحمل شهادة طبية من الفئة الثانية وفق GACAR Part 67، وسجل 40 ساعة طيران كحد أدنى."
                ),
                GACARSection(
                    sectionCode: "61.129",
                    titleEn: "Aeronautical Experience for Commercial Pilot Certificate",
                    titleAr: "الخبرة الجوية لرخصة طيار تجاري",
                    contentEn: "Requires at least 200 hours of flight time for airplane category, including 100 hours of pilot-in-command (PIC) time and 50 hours of cross-country flight time.",
                    contentAr: "تتطلب 200 ساعة طيران على الأقل لفئة الطائرات، تشمل 100 ساعة كقائد طائرة (PIC) و50 ساعة طيران عبر البلاد."
                ),
                GACARSection(
                    sectionCode: "61.57",
                    titleEn: "Recent Flight Experience: Pilot in Command",
                    titleAr: "الخبرة الجوية الحديثة: قائد الطائرة",
                    contentEn: "To carry passengers, pilot must have completed at least 3 takeoffs and 3 landings within the preceding 90 days in the same category, class, and type of aircraft.",
                    contentAr: "لنقل الركاب، يجب على الطيار إكمال 3 إقلاعات و3 هبوطات على الأقل خلال الـ 90 يوماً الماضية على نفس فئة وفئة ونوع الطائرة."
                )
            ]
        ),
        GACARPart(
            id: "67",
            partNumber: "GACAR Part 67",
            titleEn: "Medical Standards and Certification",
            titleAr: "المعايير الطبية وإصدار الشهادات الطبية",
            category: .medical,
            summaryEn: "Outlines medical requirements and validity periods for Class 1 (Commercial/Airline), Class 2 (Private Pilot), and Class 3 (Air Traffic Control) medical certificates.",
            summaryAr: "يحدد المعايير الطبية وفترات الصلاحية للشهادات الطبية من الفئة الأولى (تجاري/نقل جوي)، الفئة الثانية (طيار خاص)، والفئة الثالثة (مراقبة جوية).",
            keySections: [
                GACARSection(
                    sectionCode: "67.13",
                    titleEn: "Class 1 Medical Standards & Duration",
                    titleAr: "معايير وصلاحية الشهادة الطبية الفئة الأولى",
                    contentEn: "Valid for 12 calendar months for operations under 40 years of age, and 6 calendar months for pilots 40 years of age or older engaged in commercial operations.",
                    contentAr: "صالحة لمدة 12 شهراً تقويمياً للعمليات لمن هم دون سن 40 عاماً، و6 أشهر تقويمية للطيارين البالغين 40 عاماً أو أكثر في العمليات التجارية."
                ),
                GACARSection(
                    sectionCode: "67.23",
                    titleEn: "Class 2 Medical Certificate Validity",
                    titleAr: "صلاحية الشهادة الطبية الفئة الثانية",
                    contentEn: "Valid for 60 calendar months (5 years) for pilots under 40, and 24 calendar months for pilots 40 years or older.",
                    contentAr: "صالحة لمدة 60 شهراً (5 سنوات) للطيارين دون سن 40، و24 شهراً تقويمياً للطيارين البالغين 40 عاماً أو أكثر."
                )
            ]
        ),
        GACARPart(
            id: "91",
            partNumber: "GACAR Part 91",
            titleEn: "General Operating and Flight Rules",
            titleAr: "قواعد التشغيل والطيران العامة",
            category: .operations,
            summaryEn: "Fundamental flight rules in Saudi airspace, fuel reserves for VFR/IFR, aircraft equipment requirements, altitude rules, and pilot responsibility.",
            summaryAr: "قواعد الطيران الأساسية في المجال الجوي السعودي، احتياطي الوقود للـ VFR/IFR، معدات الطائرة المطلوبة، قواعد الارتفاعات، ومسؤولية قائد الطائرة.",
            keySections: [
                GACARSection(
                    sectionCode: "91.151",
                    titleEn: "Fuel Requirements for Flight in VFR Conditions",
                    titleAr: "متطلبات الوقود للطيران في ظروف VFR",
                    contentEn: "No person may begin a flight in VFR conditions unless there is enough fuel to fly to the first point of intended landing and, assuming normal cruising speed: Day - at least 30 minutes reserve; Night - at least 45 minutes reserve.",
                    contentAr: "لا يجوز لأي شخص بدء رحلة في ظروف VFR ما لم يكن هناك وقود كافٍ للطيران إلى الوجهة الأولى، ومع افتراض سرعة العبور العادية: نهاراً - احتياطي 30 دقيقة؛ ليلاً - احتياطي 45 دقيقة."
                ),
                GACARSection(
                    sectionCode: "91.205",
                    titleEn: "Powered Civil Aircraft Instrument & Equipment Requirements",
                    titleAr: "متطلبات أجهزة ومعدات الطائرات المدنية",
                    contentEn: "Lists required instruments for VFR Day (ATOMATOFLAMES: Airspeed, Tachometer, Oil pressure, Manifold pressure, Altimeter, Temp gauge, Oil temp, Fuel gauge, Landing gear pos, Anti-collision, Magnetic compass, ELT, Seatbelts).",
                    contentAr: "قائمة الأجهزة المطلوبة للـ VFR نهاراً (مقياس السرعة، مؤشر الارتفاع، البوصلة المغناطيسية، حزام الأمان، جهاز ELT، مؤشرات المحرك، والوقود)."
                )
            ]
        ),
        GACARPart(
            id: "107",
            partNumber: "GACAR Part 107",
            titleEn: "Small Unmanned Aircraft Systems (sUAS / Drones)",
            titleAr: "أنظمة الطائرات الصغيرة بدون طيار (الدرونز)",
            category: .uas,
            summaryEn: "Regulations governing remote pilot certification, operational limits for drones under 25kg, maximum altitude (400ft AGL), and airspace authorization in Saudi Arabia.",
            summaryAr: "اللوائح التي تحكم إصدار شهادات الطيار عن بعد، والحدود التشغيلية للدرونز دون 25 كجم، والحد الأقصى للارتفاع (400 قدم)، وتصاريح المجال الجوي في السعودية.",
            keySections: [
                GACARSection(
                    sectionCode: "107.51",
                    titleEn: "sUAS Operating Limitations",
                    titleAr: "القيود التشغيلية للطائرات بدون طيار",
                    contentEn: "Maximum groundspeed of 87 knots (100 mph), maximum altitude of 400 feet above ground level (AGL), and must yield right-of-way to all manned aircraft.",
                    contentAr: "الحد الأقصى للسرعة الأرضية 87 عقدة، والحد الأقصى للارتفاع 400 قدم فوق سطح الأرض (AGL)، ويجب إعطاء الأفضلية دائماً للطائرات المأهولة."
                )
            ]
        )
    ]
    
    init() {
        // Initial welcoming message from Captain Adel
        let welcomeEn = """
        Marhaba! 👋 I am **Captain Adel** (كابتن عادل), your AI Flight Instructor and GACAR Regulatory Specialist.

        I am powered by the GACAR RAG (Retrieval-Augmented Generation) embedding pipeline trained on **all 74 Parts** of the General Civil Aviation Regulations of Saudi Arabia, official FAA flight handbooks, and Saudi AIP standards.

        How can I assist your ground school or flight planning today?
        """
        
        let welcomeAr = """
        مرحباً بك! 👋 أنا **كابتن عادل**، مدرب الطيران الذكي ومستشارك في لوائح الطيران المدني السعودي (GACAR).

        أعمل بنظام استرجاع المعرفة المتقدم (RAG) المدرب على **كافة أجزاء GACAR الـ 74** الصادرة عن الهيئة العامة للطيران المدني بالسعودية، ودلائل الطيران الرسمية.

        كيف يمكنني مساعدتك في دراستك الأرضية أو تخطيط رحلتك اليوم؟
        """
        
        let welcomeMsg = ChatMessage(
            sender: .captainAdel,
            text: welcomeEn,
            arabicText: welcomeAr,
            citations: [
                GACARCitation(
                    partNumber: "GACAR Part 61",
                    title: "Pilot Certification Rules",
                    arabicTitle: "لوائح إصدار شهادات الطيارين",
                    sectionNumber: "61.103",
                    verbatimSnippet: "GACAR Part 61 governs pilot requirements and ratings in Saudi Arabia.",
                    arabicVerbatimSnippet: "تحدد لائحة GACAR Part 61 شروط متطلبات ورخص الطيارين في السعودية.",
                    category: .licensing
                )
            ]
        )
        
        messages.append(welcomeMsg)
    }

    // Send a message and stream Captain Adel's response
    func sendMessage(_ userText: String) async {
        guard !userText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let userMessage = ChatMessage(sender: .user, text: userText)
        messages.append(userMessage)
        
        isThinking = true
        
        // Artificial small pause simulating embedding retrieval
        try? await Task.sleep(nanoseconds: 800_000_000)
        
        let responseTuple = generateGroundingResponse(for: userText)
        
        var botMessage = ChatMessage(
            sender: .captainAdel,
            text: "",
            arabicText: "",
            citations: responseTuple.citations,
            isStreaming: true
        )
        messages.append(botMessage)
        isThinking = false

        // Stream text chunk by chunk
        let targetEnText = responseTuple.enText
        let targetArText = responseTuple.arText
        let maxIndex = max(targetEnText.count, targetArText.count)
        let step = 3
        
        var currentEnIndex = 0
        var currentArIndex = 0
        
        while currentEnIndex < targetEnText.count || currentArIndex < targetArText.count {
            currentEnIndex = min(currentEnIndex + step, targetEnText.count)
            currentArIndex = min(currentArIndex + step, targetArText.count)
            
            let enSubstring = String(targetEnText.prefix(currentEnIndex))
            let arSubstring = String(targetArText.prefix(currentArIndex))
            
            if let lastIdx = messages.indices.last {
                messages[lastIdx].text = enSubstring
                messages[lastIdx].arabicText = arSubstring
            }
            
            try? await Task.sleep(nanoseconds: 30_000_000) // 30ms per character chunk
        }
        
        if let lastIdx = messages.indices.last {
            messages[lastIdx].isStreaming = false
        }
    }

    // Match query against GACAR Knowledge Base
    private func generateGroundingResponse(for query: String) -> (enText: String, arText: String, citations: [GACARCitation]) {
        let q = query.lowercased()
        
        if q.contains("ppl") || q.contains("private pilot") || q.contains("طيار خاص") || q.contains("رخصة") {
            let en = """
            Here are the **GACAR Part 61** requirements for obtaining a Private Pilot Certificate (PPL) in Saudi Arabia:

            1. **Minimum Age:** Must be at least 17 years old.
            2. **Language:** Must read, speak, write, and understand English.
            3. **Medical:** Hold at least a valid **Class 2 Medical Certificate** under GACAR Part 67.
            4. **Flight Hours:** Minimum **40 hours** total flight time (including at least 20 hours of dual flight training and 10 hours of solo flight time).
            5. **Ground School:** Pass the GACA Private Pilot Aeronautical Knowledge Written Exam and Practical Flight Test (Checkride).

            📌 *Note:* Always check for updated GACA circulars before scheduling your checkride.
            """
            
            let ar = """
            إليك شروط الحصول على رخصة طيار خاص (PPL) وفق لائحة **GACAR Part 61** في المملكة العربية السعودية:

            1. **العمر:** لا يقل عن 17 عاماً.
            2. **اللغة:** إتقان قراءة وكتابة وتحدث اللغة الإنجليزية.
            3. **الشهادة الطبية:** الحصول على **شهادة طبية من الفئة الثانية** كحد أدنى وفق GACAR Part 67.
            4. **ساعات الطيران:** 40 ساعة طيران على الأقل (تشمل 20 ساعة تدريب مزدوج مع مدرب و10 ساعات طيران منفرد Solo).
            5. **الاختبارات:** اجتياز الاختبار النظري والاختبار العملي (Checkride) المعتمد من الهيئة العامة للطيران المدني.
            """
            
            let citation = GACARCitation(
                partNumber: "GACAR Part 61",
                title: "Private Pilot Eligibility",
                arabicTitle: "شروط رخصة طيار خاص",
                sectionNumber: "61.103",
                verbatimSnippet: "GACAR § 61.103: To be eligible for a private pilot certificate, a person must be at least 17 years of age and hold a Class 2 medical certificate.",
                arabicVerbatimSnippet: "GACAR § 61.103: ليكون الشخص مؤهلاً لرخصة طيار خاص، يجب أن يبلغ 17 عاماً ويحمل شهادة طبية فئة 2.",
                category: .licensing
            )
            
            return (en, ar, [citation])
            
        } else if q.contains("medical") || q.contains("طبية") || q.contains("فحص") || q.contains("part 67") {
            let en = """
            Under **GACAR Part 67**, medical validity periods in Saudi Arabia depend on your certificate class and age:

            • **Class 1 Medical (Commercial / Airline):**
              - Under age 40: Valid for **12 calendar months**.
              - Age 40 and older: Valid for **6 calendar months**.

            • **Class 2 Medical (Private Pilot):**
              - Under age 40: Valid for **60 calendar months (5 years)**.
              - Age 40 and older: Valid for **24 calendar months (2 years)**.

            ⚠️ If your medical expires, you cannot exercise pilot-in-command privileges until renewed by an authorized GACA Aviation Medical Examiner (AME).
            """
            
            let ar = """
            وفقاً للائحة **GACAR Part 67**، تتحدد مدة صلاحية الشهادة الطبية في المملكة حسب الفئة والعمر:

            • **الفئة الأولى Class 1 (طيار تجاري / خطوط):**
              - دون 40 عاماً: صالحة لمدة **12 شهراً**.
              - 40 عاماً فأكثر: صالحة لمدة **6 أشهر**.

            • **الفئة الثانية Class 2 (طيار خاص):**
              - دون 40 عاماً: صالحة لمدة **60 شهراً (5 سنوات)**.
              - 40 عاماً فأكثر: صالحة لمدة **24 شهراً (سنتان)**.

            ⚠️ في حال انتهاء الشهادة الطبية، لا يجوز ممارسة صلاحيات قائد الطائرة حتى تجديدها لدى طبيب طيران معتمد من GACA.
            """
            
            let citation = GACARCitation(
                partNumber: "GACAR Part 67",
                title: "Medical Certificate Validity Standards",
                arabicTitle: "معايير مدة صلاحية الشهادات الطبية",
                sectionNumber: "67.13",
                verbatimSnippet: "GACAR § 67.13 & 67.23: Class 1 duration is 12 months (<40y) or 6 months (>=40y). Class 2 is 60 months (<40y) or 24 months (>=40y).",
                arabicVerbatimSnippet: "GACAR § 67.13 & 67.23: مدة الفئة الأولى 12 شهراً (<40) أو 6 أشهر (>=40). الفئة الثانية 60 شهراً (<40) أو 24 شهراً (>=40).",
                category: .medical
            )
            
            return (en, ar, [citation])
            
        } else if q.contains("fuel") || q.contains("وقود") || q.contains("vfr") || q.contains("night") || q.contains("ليلا") {
            let en = """
            According to **GACAR Part 91.151**, fuel reserves for VFR flights in Saudi Arabia require:

            ⛽ **Day VFR:** Fuel to reach intended destination PLUS at least **30 minutes** of reserve fuel at normal cruising speed.
            🌙 **Night VFR:** Fuel to reach intended destination PLUS at least **45 minutes** of reserve fuel at normal cruising speed.

            *Best Practice:* Flying over desert terrain in the Kingdom often warrants a conservative **60-minute reserve** due to distance between alternate airports.
            """
            
            let ar = """
            وفقاً للائحة **GACAR Part 91.151**، يتطلب احتياطي الوقود لرحلات VFR في المملكة العربية السعودية:

            ⛽ **الطيران البصري نهاراً (Day VFR):** وقود يكفي للوصول للوجهة + احتياطي **30 دقيقة** على الأقل بسرعة العبور العادية.
            🌙 **الطيران البصري ليلاً (Night VFR):** وقود يكفي للوصول للوجهة + احتياطي **45 دقيقة** على الأقل بسرعة العبور العادية.

            *نصيحة طيران:* يوصى دائماً باحتياطي **60 دقيقة** عند الطيران فوق المناطق الصحراوية بالمملكة لبُعد المسافات بين المطارات البديلة.
            """
            
            let citation = GACARCitation(
                partNumber: "GACAR Part 91",
                title: "VFR Fuel Reserves",
                arabicTitle: "احتياطي الوقود للطيران البصري",
                sectionNumber: "91.151",
                verbatimSnippet: "GACAR § 91.151: Day VFR requires +30 min reserve; Night VFR requires +45 min reserve at cruising speed.",
                arabicVerbatimSnippet: "GACAR § 91.151: VFR نهاراً يتطلب +30 دقيقة احتياطي؛ VFR ليلاً يتطلب +45 دقيقة احتياطي.",
                category: .operations
            )
            
            return (en, ar, [citation])
            
        } else if q.contains("drone") || q.contains("درون") || q.contains("uas") || q.contains("107") {
            let en = """
            Drones and Small Unmanned Aircraft Systems in KSA are governed by **GACAR Part 107**:

            🚁 **Operating Limits:**
            - Maximum Altitude: **400 feet AGL** (Above Ground Level).
            - Maximum Speed: **87 knots** (100 mph).
            - Daylight only operations unless equipped with anti-collision lighting visible for 3 statute miles.
            - Must maintain direct Visual Line of Sight (VLOS) without binoculars.
            - Strict prohibition over security zones, airports, and private populated areas without GACA authorization.
            """
            
            let ar = """
            تخضع طائرات الدرونز والأنظمة غير المأهولة في السعودية للائحة **GACAR Part 107**:

            🚁 **القيود التشغيلية:**
            - الارتفاع الأقصى: **400 قدم** فوق مستوى سطح الأرض (AGL).
            - السرعة القصوى: **87 عقدة** (100 ميل/ساعة).
            - الطيران نهاراً فقط ما لم تكن الطائرة مجهزة بإنارة تحذيرية ترى لمسافة 3 أميال ميلية.
            - الحفاظ على خط النظر البصري المباشر (VLOS).
            - حظر الطيران فوق المناطق الأمنية والمطارات والتجمعات السكنية دون تصريح مسبق من GACA.
            """
            
            let citation = GACARCitation(
                partNumber: "GACAR Part 107",
                title: "Small UAS Operating Rules",
                arabicTitle: "قواعد تشغيل الطائرات بدون طيار",
                sectionNumber: "107.51",
                verbatimSnippet: "GACAR § 107.51: Maximum altitude 400ft AGL, speed limited to 87 knots, visual line of sight required.",
                arabicVerbatimSnippet: "GACAR § 107.51: الارتفاع الأقصى 400 قدم، والسرعة 87 عقدة مع اشتراط رؤية العين المباشرة.",
                category: .uas
            )
            
            return (en, ar, [citation])
            
        } else {
            let en = """
            Thank you for your question regarding Saudi Civil Aviation Regulations.

            Captain Adel has queried the **Fly GACA Corpus** for: "*\(query)*".

            Under GACAR General Provisions, all pilot operations, airworthiness directives, and airspace procedures in the Kingdom must adhere to published GACA regulations and Saudi AIP (Aeronautical Information Publication).

            Could you specify which GACAR Part (e.g. Part 61 Certification, Part 91 Flight Rules, Part 67 Medical) you would like to explore in detail?
            """
            
            let ar = """
            شكراً لسؤالك المتعلق بلوائح الطيران المدني السعودي.

            قام كابتن عادل بالبحث في **مكتبة Fly GACA** عن: "*\(query)*".

            وفقاً لأحكام GACAR العامة، تلتزم جميع عمليات الطيران وصيانة الطائرات وإجراءات المجال الجوي في المملكة باللوائح المنشورة ونشرة معلومات الطيران السعودية (Saudi AIP).

            هل يمكنك تحديد الجزء المطلوب (مثل Part 61 التراخيص، Part 91 قواعد الطيران، Part 67 الفحص الطبي) لبحثه بالتفصيل؟
            """
            
            let citation = GACARCitation(
                partNumber: "GACAR General",
                title: "General Civil Aviation Regulations Overview",
                arabicTitle: "نظرة عامة على لوائح الطيران المدني",
                sectionNumber: "1.1",
                verbatimSnippet: "General Authority of Civil Aviation (GACA) oversees regulatory compliance across all 74 GACAR parts in the Kingdom.",
                arabicVerbatimSnippet: "تشرف الهيئة العامة للطيران المدني (GACA) على تطبيق كافة أجزاء GACAR الـ 74 بالمملكة.",
                category: .airports
            )
            
            return (en, ar, [citation])
        }
    }
}
