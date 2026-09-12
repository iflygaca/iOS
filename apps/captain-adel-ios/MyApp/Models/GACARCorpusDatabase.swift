import Foundation

/// Comprehensive 74-Part Saudi Civil Aviation Regulations (GACAR) Database
struct GACARCorpusDatabase {
    static let allParts: [GACARPart] = [
        // MARK: - Division I: General Rules & Safety
        GACARPart(
            id: "1",
            partNumber: "GACAR Part 1",
            titleEn: "Definitions and Abbreviations",
            titleAr: "التعاريف والاختصارات",
            category: .operations,
            summaryEn: "Defines regulatory aviation terms, abbreviations, and symbols used across all GACAR regulations in the Kingdom.",
            summaryAr: "يحدد المصطلحات الفنية والاختصارات والرموز التنظيمية المعتمدة في كافة لوائح الطيران المدني السعودي.",
            keySections: [
                GACARSection(
                    sectionCode: "1.1",
                    titleEn: "General Definitions",
                    titleAr: "التعاريف العامة",
                    contentEn: "Authoritative regulatory definitions for Pilot in Command (PIC), Flight Time, Night (end of evening civil twilight to beginning of morning civil twilight), VFR, IFR, and Air Carrier.",
                    contentAr: "التعاريف النظامية المعتمدة لقائد الطائرة، وقت الطيران، الليل (من نهاية الشفق المدني المسائي حتى بداية الصباحي)، وقواعد VFR وIFR."
                )
            ]
        ),
        GACARPart(
            id: "3",
            partNumber: "GACAR Part 3",
            titleEn: "General Requirements and Falsification Prohibitions",
            titleAr: "المتطلبات العامة وحظر تزوير السجلات",
            category: .operations,
            summaryEn: "Prohibits fraudulent or intentionally false statements on applications, logbooks, and records, and sets general rules of compliance with GACAR.",
            summaryAr: "يحظر تقديم بيانات كاذبة أو تزوير السجلات وتراخيص الطيران وسجلات الصيانة، ويحدد القواعد العامة للامتثال التنظيمي.",
            keySections: [
                GACARSection(
                    sectionCode: "3.5",
                    titleEn: "Falsification, Reproduction, or Alteration",
                    titleAr: "تزوير السجلات والوثائق",
                    contentEn: "No person may make any fraudulent or intentionally false statement in any application, logbook, record, or report required by GACAR.",
                    contentAr: "يحظر حظراً تاماً تقديم بيانات كاذبة أو تزوير أو تعديل أي طلب أو سجل طيران أو تقرير تطلبه لوائح الطيران المدني."
                )
            ]
        ),
        GACARPart(
            id: "5",
            partNumber: "GACAR Part 5",
            titleEn: "Safety Management Systems (SMS)",
            titleAr: "أنظمة إدارة السلامة (SMS)",
            category: .operations,
            summaryEn: "Mandates Safety Management Systems for certified air operators, maintenance organizations, and aerodromes.",
            summaryAr: "يلزم المشغلين الجويين ومراكز الصيانة والمطارات المرخصة بتطبيق أنظمة معتمدة لإدارة السلامة الجوية والمخاطر.",
            keySections: [
                GACARSection(
                    sectionCode: "5.21",
                    titleEn: "Safety Policy & Objectives",
                    titleAr: "سياسة وأهداف السلامة",
                    contentEn: "Certificate holders must establish an accountable safety policy with clear safety reporting protocols and safety performance indicators.",
                    contentAr: "يجب على حاملي الشهادات وضع سياسة واضحة للسلامة وتوفير قنوات سرية للإبلاغ وتحديد مؤشرات أداء السلامة."
                )
            ]
        ),
        GACARPart(
            id: "11",
            partNumber: "GACAR Part 11",
            titleEn: "General Rulemaking Procedures",
            titleAr: "إجراءات سن وتعديل اللوائح التنظيمية",
            category: .operations,
            summaryEn: "Procedures for petitioning GACA for rulemaking, regulatory amendments, exemptions, and public consultations across civil aviation.",
            summaryAr: "إجراءات تقديم التماسات سن أو تعديل لوائح الطيران المدني وطلبات الاستثناء والمشاورات العامة مع قطاع الطيران.",
            keySections: [
                GACARSection(
                    sectionCode: "11.25",
                    titleEn: "Petitions for Rulemaking and Exemptions",
                    titleAr: "التماسات تعديل اللوائح وطلبات الإعفاء",
                    contentEn: "Governs formal petitions submitted to the President of GACA for regulatory amendment, adoption, or temporary exemptions with safety cases.",
                    contentAr: "ينظم تقديم الالتماسات الرسمية لرئيس الهيئة لتعديل أو اعتماد نصوص تنظيمية أو طلب إعفاءات مؤقتة مع بيان مبررات السلامة."
                )
            ]
        ),
        GACARPart(
            id: "13",
            partNumber: "GACAR Part 13",
            titleEn: "Investigative and Enforcement Procedures",
            titleAr: "إجراءات التحقيق وإنفاذ اللوائح",
            category: .operations,
            summaryEn: "Procedures for GACA regulatory investigations, notices of proposed civil penalties, orders of suspension, or revocation of certificates.",
            summaryAr: "إجراءات التحقيق في المخالفات وفرض الغرامات المالية وتعليق أو إلغاء الرخص والشهادات الجوية.",
            keySections: [
                GACARSection(
                    sectionCode: "13.15",
                    titleEn: "Civil Penalties & License Suspension",
                    titleAr: "العقوبات المالية وتعليق التراخيص",
                    contentEn: "Details sanctions for regulatory non-compliance, operating unairworthy aircraft, or reckless operations endangering persons or property.",
                    contentAr: "يحدد الجزاءات المترتبة على مخالفة اللوائح وتشغيل طائرات غير صالحة للطيران أو تعريض السلامة للخطر."
                )
            ]
        ),
        GACARPart(
            id: "17",
            partNumber: "GACAR Part 17",
            titleEn: "Rules of Practice in GACA Appeals and Hearings",
            titleAr: "قواعد المرافعات وجلسات الاستماع والطعون",
            category: .operations,
            summaryEn: "Administrative adjudication, appeal procedures, and formal hearing processes for GACA regulatory decisions and sanctions.",
            summaryAr: "إجراءات التقاضي الإداري والاستماع والطعن على قرارات الهيئة العامة للطيران المدني والجزاءات الصادرة بحق المخالفين.",
            keySections: [
                GACARSection(
                    sectionCode: "17.11",
                    titleEn: "Appeals against Administrative Sanctions",
                    titleAr: "الطعن على القرارات والجزاءات الإدارية",
                    contentEn: "Procedures for affected certificate holders to file administrative appeals against sanctions, suspensions, or certificate denials.",
                    contentAr: "حق حامل الرخصة أو الشهادة في التظلم وتقديم الطعن ضد قرارات الإيقاف أو سحب التراخيص أمام لجان النظر المختصة."
                )
            ]
        ),

        // MARK: - Division II: Aircraft & Airworthiness
        GACARPart(
            id: "21",
            partNumber: "GACAR Part 21",
            titleEn: "Certification Procedures for Products and Parts",
            titleAr: "إجراءات اعتماد المنتجات والقطع",
            category: .maintenance,
            summaryEn: "Type certificates, supplemental type certificates (STC), and airworthiness approval for aircraft, engines, and propellers.",
            summaryAr: "شهادات النوع واعتماد صلاحية الطائرات والمحركات والقطع المصنعة والمعدلة.",
            keySections: [
                GACARSection(
                    sectionCode: "21.183",
                    titleEn: "Standard Airworthiness Certificates",
                    titleAr: "شهادات صلاحية الطيران القياسية",
                    contentEn: "Requirements for issuing standard airworthiness certificates for aircraft registered in Saudi Arabia.",
                    contentAr: "شروط وإجراءات إصدار شهادة صلاحية الطيران القياسية للطائرات المسجلة في المملكة."
                )
            ]
        ),
        GACARPart(
            id: "23",
            partNumber: "GACAR Part 23",
            titleEn: "Airworthiness Standards: Normal Category Airplanes",
            titleAr: "معايير الصلاحية: الطائرات العادية",
            category: .maintenance,
            summaryEn: "Airworthiness design standards for normal, utility, aerobatic, and commuter category airplanes up to 19 passengers.",
            summaryAr: "معايير التصميم وصلاحية الطيران لطائرات الركاب الصغيرة والطائرات التدريبية.",
            keySections: [
                GACARSection(
                    sectionCode: "23.1501",
                    titleEn: "Operating Limitations",
                    titleAr: "الحدود التشغيلية للطائرة",
                    contentEn: "Prescribes mandatory flight limitations, airspeed operating limits, and weight/balance envelopes.",
                    contentAr: "يحدد السرعات التشغيلية الآمنة وحدود الوزن ومركز الثقل المسموح بها."
                )
            ]
        ),
        GACARPart(
            id: "25",
            partNumber: "GACAR Part 25",
            titleEn: "Airworthiness Standards: Transport Category Airplanes",
            titleAr: "معايير الصلاحية: طائرات النقل التجاري الكبيرة",
            category: .maintenance,
            summaryEn: "Structural, powerplant, and system safety standards for multi-engine transport category jet airplanes.",
            summaryAr: "المعايير الهيكلية ومواصفات الأمان لطائرات النقل الجوي التجاري النفاثة.",
            keySections: [
                GACARSection(
                    sectionCode: "25.107",
                    titleEn: "Takeoff Speeds (V1, VR, V2)",
                    titleAr: "سرعات الإقلاع المعتمدة",
                    contentEn: "Defines minimum takeoff decision speed (V1), rotation speed (VR), and takeoff climb speed (V2).",
                    contentAr: "تحديد سرعة اتخاذ قرار الإقلاع (V1) وسرعة الرفع (VR) وسرعة صعود الإقلاع (V2)."
                )
            ]
        ),
        GACARPart(
            id: "27",
            partNumber: "GACAR Part 27",
            titleEn: "Airworthiness Standards: Normal Category Rotorcraft",
            titleAr: "معايير الصلاحية: طائرات الهليكوبتر العادية",
            category: .maintenance,
            summaryEn: "Certification standards for helicopters with maximum weight of 7,000 lbs and 9 or fewer passengers.",
            summaryAr: "معايير اعتماد وصلاحية الطائرات العمودية الخفيفة والمتوسطة.",
            keySections: [
                GACARSection(
                    sectionCode: "27.65",
                    titleEn: "Rotorcraft Performance & Hovering",
                    titleAr: "أداء الطيران العمودي والحوم",
                    contentEn: "Hovering ceiling performance in ground effect (HIGE) and out of ground effect (HOGE).",
                    contentAr: "تحديد أداء الحوم داخل التأثير الأرضي وخارجه وحدود الارتفاع."
                )
            ]
        ),
        GACARPart(
            id: "29",
            partNumber: "GACAR Part 29",
            titleEn: "Airworthiness Standards: Transport Category Rotorcraft",
            titleAr: "معايير الصلاحية: طائرات الهليكوبتر للنقل التجاري",
            category: .maintenance,
            summaryEn: "Standards for heavy transport category multi-engine rotorcraft.",
            summaryAr: "معايير اعتماد طائرات الهليكوبتر الكبيرة متعددة المحركات.",
            keySections: [
                GACARSection(
                    sectionCode: "29.25",
                    titleEn: "Category A & B Rotorcraft Performance",
                    titleAr: "أداء الطائرات العمودية الفئة أ و ب",
                    contentEn: "Engine failure safety and continuation of flight requirements for transport helicopters.",
                    contentAr: "متطلبات مواصلة الطيران بأمان في حال تعطل أحد المحركات."
                )
            ]
        ),
        GACARPart(
            id: "31",
            partNumber: "GACAR Part 31",
            titleEn: "Airworthiness Standards: Manned Free Balloons",
            titleAr: "معايير صلاحية الطيران: المناطيد المأهولة الحرّة",
            category: .maintenance,
            summaryEn: "Design and airworthiness requirements for hot air and gas manned free balloons operating within Saudi airspace.",
            summaryAr: "متطلبات ومعايير التصميم والصلاحية الفنية لمناطيد الهواء الساخن والغاز المأهولة العاملة في أجواء المملكة.",
            keySections: [
                GACARSection(
                    sectionCode: "31.21",
                    titleEn: "Burner and Fuel System Standards",
                    titleAr: "معايير الحوارق ومنظومة الوقود",
                    contentEn: "Prescribes structural envelope, heating burner, fuel pressure, and emergency deflation system airworthiness criteria.",
                    contentAr: "يحدد متطلبات متانة الغلاف وحوارق التسخين وضغط الوقود وصمامات التنفيس السريع للهبوط الاضطراري في المناطيد."
                )
            ]
        ),
        GACARPart(
            id: "33",
            partNumber: "GACAR Part 33",
            titleEn: "Airworthiness Standards: Aircraft Engines",
            titleAr: "معايير الصلاحية: محركات الطائرات",
            category: .maintenance,
            summaryEn: "Design and durability standards for turbine and reciprocating aircraft engines.",
            summaryAr: "شروط صلاحية واعتماد محركات الطائرات التوربينية والمكبسية.",
            keySections: [
                GACARSection(
                    sectionCode: "33.75",
                    titleEn: "Engine Safety Analysis",
                    titleAr: "تحليل سلامة المحركات",
                    contentEn: "Failure containment, uncontained turbine blade shedding prevention, and bird ingestion testing.",
                    contentAr: "اختبارات مقاومة دخول الطيور واحتواء الشظايا التوربينية داخل هيكل المحرك."
                )
            ]
        ),
        GACARPart(
            id: "34",
            partNumber: "GACAR Part 34",
            titleEn: "Fuel Venting and Exhaust Emission Requirements",
            titleAr: "معايير تصريف الوقود وانبعاثات عادم المحركات التوربينية",
            category: .maintenance,
            summaryEn: "Environmental standards for fuel venting prevention and exhaust emissions for turbine-powered airplanes in the Kingdom.",
            summaryAr: "معايير حماية البيئة لمنع تسريب وتصريف الوقود في الجو والحد من انبعاثات الغازات والعادم للطائرات التوربينية.",
            keySections: [
                GACARSection(
                    sectionCode: "34.11",
                    titleEn: "Fuel Discharge Prevention Standards",
                    titleAr: "منع تفريغ وتصريف الوقود غير المحترق",
                    contentEn: "Turbine aircraft must be designed to eliminate unintentional liquid fuel discharge into the atmosphere following engine shutdown.",
                    contentAr: "إلزام الطائرات التوربينية بتجهيزات فنية تمنع تسرب وتفريغ الوقود السائل في الهواء عقب إيقاف المحركات."
                )
            ]
        ),
        GACARPart(
            id: "35",
            partNumber: "GACAR Part 35",
            titleEn: "Airworthiness Standards: Propellers",
            titleAr: "معايير الصلاحية: مراوح الطائرات",
            category: .maintenance,
            summaryEn: "Certification standards for fixed, variable-pitch, and feathering aircraft propellers.",
            summaryAr: "معايير تصميم واعتماد مراوح الطائرات ذات الخطوة الثابتة والمتغيرة والريش المتعامد.",
            keySections: [
                GACARSection(
                    sectionCode: "35.21",
                    titleEn: "Propeller Pitch Control",
                    titleAr: "التحكم في زاوية ريش المروحة",
                    contentEn: "Feathering safety systems to prevent negative thrust during engine shutdown.",
                    contentAr: "أنظمة التعامد لمنع الدفع السلبي عند انطفاء المحرك."
                )
            ]
        ),
        GACARPart(
            id: "36",
            partNumber: "GACAR Part 36",
            titleEn: "Noise Standards: Aircraft Type and Airworthiness Certification",
            titleAr: "معايير الضوضاء: اعتماد نوع الطائرة وصلاحيتها",
            category: .maintenance,
            summaryEn: "Prescribes acoustic noise limits, flight test measurements, and certification levels for airplanes and helicopters.",
            summaryAr: "يحدد الحدود القصوى المسموح بها لضوضاء الطائرات النفاثة والمروحية وطرق القياس الصوتي لاعتماد الصلاحية البيئية.",
            keySections: [
                GACARSection(
                    sectionCode: "36.1",
                    titleEn: "Acoustical and Noise Certification Limits",
                    titleAr: "الحدود القصوى للضوضاء الصوتية",
                    contentEn: "Aircraft operating in Saudi Arabia must comply with ICAO Annex 16 noise levels for takeoff, sideline, and approach phases.",
                    contentAr: "مطابقة الطائرات لحدود الضوضاء المعتمدة في الملحق 16 لمنظمة الإيكاو أثناء الإقلاع والاقتراب ومحاذاة المدارج."
                )
            ]
        ),
        GACARPart(
            id: "39",
            partNumber: "GACAR Part 39",
            titleEn: "Airworthiness Directives (ADs)",
            titleAr: "توجيهات صلاحية الطيران الإلزامية (ADs)",
            category: .maintenance,
            summaryEn: "Mandatory compliance with safety directives issued by GACA or state of design to correct unsafe conditions.",
            summaryAr: "التطبيق الإلزامي لتوجيهات السلامة وتعديلات الصيانة لمعالجة أي خلل فني في الطائرات.",
            keySections: [
                GACARSection(
                    sectionCode: "39.7",
                    titleEn: "Mandatory AD Compliance",
                    titleAr: "إلزامية الامتثال لتوجيهات الصلاحية",
                    contentEn: "No person may operate an aircraft to which an Airworthiness Directive applies, unless in compliance with that AD.",
                    contentAr: "يُحظر تشغيل أي طائرة يَنطبق عليها توجيه صلاحية صادر ما لم يتم تنفيذه وتوثيقه بالكامل."
                )
            ]
        ),
        GACARPart(
            id: "43",
            partNumber: "GACAR Part 43",
            titleEn: "Maintenance, Preventive Maintenance, Rebuilding, and Alteration",
            titleAr: "الصيانة والصيانة الوقائية والتعديل",
            category: .maintenance,
            summaryEn: "Governs maintenance procedures, authorized personnel, logbook entries, and return to service approval.",
            summaryAr: "قواعد تنفيذ الصيانة والصيانة الوقائية وسجلات الطائرات والتصريح بإعادة الطائرة للخدمة.",
            keySections: [
                GACARSection(
                    sectionCode: "43.9",
                    titleEn: "Maintenance Record Entries",
                    titleAr: "تسجيل قيود الصيانة في السجلات",
                    contentEn: "Every maintenance action must be logged with description of work, date, technician certificate number, and signature.",
                    contentAr: "توثيق كل عمل صيانة مع وصف الإجراء والتاريخ ورقم رخصة الفني المعتمد وتوقيعه."
                ),
                GACARSection(
                    sectionCode: "43.11",
                    titleEn: "Return to Service Authorization",
                    titleAr: "التصريح بإعادة الطائرة للخدمة",
                    contentEn: "Aircraft cannot be operated following maintenance until approved for return to service by an authorized inspector.",
                    contentAr: "لا يجوز تشغيل الطائرة بعد الصيانة إلا بعد اعتماد إعادة الخدمة من مهندس مرخص."
                )
            ]
        ),
        GACARPart(
            id: "45",
            partNumber: "GACAR Part 45",
            titleEn: "Identification and Registration Marking",
            titleAr: "علامات التسجيل والتعريف للطائرات",
            category: .operations,
            summaryEn: "Rules for painting and displaying Saudi registration marks (HZ-xxx) and data plates.",
            summaryAr: "قواعد وضع لوحة البيانات وطلاء علامة التسجيل الوطنية السعودية (HZ-xxx) على الطائرات.",
            keySections: [
                GACARSection(
                    sectionCode: "45.21",
                    titleEn: "Display of Marks",
                    titleAr: "عرض علامات التسجيل",
                    contentEn: "Saudi aircraft must carry nationality mark 'HZ' followed by registration letters, painted in Roman capital letters without ornamentation.",
                    contentAr: "يجب أن تحمل الطائرات السعودية رمز الدولة HZ متبوعاً بحروف التسجيل وبخط واضح وبحجم قياسي."
                )
            ]
        ),
        GACARPart(
            id: "47",
            partNumber: "GACAR Part 47",
            titleEn: "Aircraft Registration",
            titleAr: "تسجيل الطائرات في السجل المدني",
            category: .operations,
            summaryEn: "Eligibility and procedures for registering civil aircraft in the Kingdom of Saudi Arabia.",
            summaryAr: "شروط الأهلية وإجراءات قيد الطائرات في السجل المدني السعودي للطائرات.",
            keySections: [
                GACARSection(
                    sectionCode: "47.3",
                    titleEn: "Registration Eligibility",
                    titleAr: "شروط أهلية تسجيل الطائرة",
                    contentEn: "Aircraft must be owned by Saudi citizen, resident, or entity registered in KSA, and not registered under foreign laws.",
                    contentAr: "يشترط أن تكون الطائرة مملوكة لمواطن سعودي أو مقيم أو شركة مسجلة بالمملكة، وغير مسجلة بدولة أخرى."
                )
            ]
        ),
        GACARPart(
            id: "49",
            partNumber: "GACAR Part 49",
            titleEn: "Recording of Aircraft Titles and Security Documents",
            titleAr: "تسجيل صكوك ملكية الطائرات والرهون والحقوق المالية",
            category: .maintenance,
            summaryEn: "Recording and registration of aircraft ownership deeds, leases, mortgages, and security interests in the GACA Civil Aircraft Registry.",
            summaryAr: "توثيق وتسجيل صكوك الملكية وعقود الإيجار والرهونات المالية المترتبة على الطائرات في السجل الوطني للطائرات.",
            keySections: [
                GACARSection(
                    sectionCode: "49.17",
                    titleEn: "Conveyances and Encumbrances",
                    titleAr: "توثيق الرهون والتصرفات الناقلة للملكية",
                    contentEn: "No conveyance or encumbrance affecting title to a registered aircraft is valid against third parties until recorded with GACA.",
                    contentAr: "لا يحتج بأي بيع أو رهن أو تصرف مالي ناقل لملكية الطائرة في مواجهة الغير إلا بعد قيده وتوثيقه رسمياً لدى الهيئة."
                )
            ]
        ),

        // MARK: - Division III: Personnel & Licensing
        GACARPart(
            id: "60",
            partNumber: "GACAR Part 60",
            titleEn: "Flight Simulation Training Devices (FSTD)",
            titleAr: "أجهزة المحاكاة والتدريب التشبيهي",
            category: .licensing,
            summaryEn: "Evaluation, qualification, and ongoing certification of full flight simulators (Level A-D) and flight training devices.",
            summaryAr: "تقييم واعتماد وصلاحية مشبهات الطيران الكاملة وأجهزة التدريب التشبيهي.",
            keySections: [
                GACARSection(
                    sectionCode: "60.15",
                    titleEn: "Simulator Qualification Levels",
                    titleAr: "مستويات اعتماد المشبهات",
                    contentEn: "Specifies aerodynamic fidelity, visual systems, and motion cues required for Level C and D full flight simulators.",
                    contentAr: "المعايير البصرية والحركية اللازمة لاعتماد مشبهات الطيران الكاملة من المستوى C و D."
                )
            ]
        ),
        GACARPart(
            id: "61",
            partNumber: "GACAR Part 61",
            titleEn: "Certification: Pilots, Flight Instructors, and Ground Instructors",
            titleAr: "إصدار الشهادات: الطيارون والمدربون",
            category: .licensing,
            summaryEn: "Defines requirements for issuing Private Pilot (PPL), Commercial Pilot (CPL), Airline Transport Pilot (ATPL), instrument ratings, and instructor certificates.",
            summaryAr: "شروط وإجراءات إصدار رخص الطيار الخاص، التجاري، طيار النقل الجوي، وأهليات الطيران الآلي والتدريب.",
            keySections: [
                GACARSection(
                    sectionCode: "61.57",
                    titleEn: "Recent Flight Experience: Pilot in Command",
                    titleAr: "الخبرة الجوية الحديثة لقائد الطائرة",
                    contentEn: "To carry passengers: at least 3 takeoffs and 3 landings within the preceding 90 days in same category/class. Night requires full stop.",
                    contentAr: "لحمل الركاب: 3 إقلاعات و3 هبوطات خلال الـ 90 يوماً الماضية على نفس الفئة والنوع. ليلاً يلزم التوقف الكامل."
                ),
                GACARSection(
                    sectionCode: "61.103",
                    titleEn: "Eligibility Requirements for Private Pilot Certificate (PPL)",
                    titleAr: "شروط رخصة طيار خاص",
                    contentEn: "Minimum age 17, English language proficiency, Class 2 medical, and 40 logged flight hours (20 dual, 10 solo).",
                    contentAr: "العمر 17 عاماً، إتقان الإنجليزية، شهادة طبية فئة 2، وسجل 40 ساعة طيران منها 20 مزدوج و10 فردي."
                ),
                GACARSection(
                    sectionCode: "61.129",
                    titleEn: "Aeronautical Experience: Commercial Pilot Certificate (CPL)",
                    titleAr: "الخبرة الجوية لرخصة طيار تجاري",
                    contentEn: "Requires at least 200 hours of flight time, including 100 hours PIC and 50 hours cross-country flight time.",
                    contentAr: "يلزم 200 ساعة طيران كحد أدنى، تشمل 100 ساعة كقائد طائرة و50 ساعة طيران عبر البلاد."
                ),
                GACARSection(
                    sectionCode: "61.159",
                    titleEn: "Aeronautical Experience: Airline Transport Pilot (ATPL)",
                    titleAr: "شروط رخصة طيار نقل جوي",
                    contentEn: "Requires at least 1,500 hours of flight time including 500 hours cross-country, 100 hours night, and 75 hours instrument time.",
                    contentAr: "يلزم 1,500 ساعة طيران كحد أدنى، منها 500 ساعة ملاحة عبر البلاد و100 ساعة ليلي و75 ساعة طيران آلي."
                )
            ]
        ),
        GACARPart(
            id: "63",
            partNumber: "GACAR Part 63",
            titleEn: "Certification: Flight Crewmembers Other Than Pilots",
            titleAr: "شهادات أعضاء طاقم القيادة من غير الطيارين",
            category: .licensing,
            summaryEn: "Certification standards for flight engineers and flight navigators.",
            summaryAr: "شروط وإجراءات إصدار رخص مهندسي الطيران والملاحين الجويين.",
            keySections: [
                GACARSection(
                    sectionCode: "63.31",
                    titleEn: "Flight Engineer Eligibility",
                    titleAr: "شروط رخصة مهندس طيران",
                    contentEn: "Requires passing aeronautical knowledge and practical exams on aircraft systems, performance, and emergencies.",
                    contentAr: "اجتياز الاختبارات النظرية والعملية على أنظمة الطائرة والتعامل مع الطوارئ."
                )
            ]
        ),
        GACARPart(
            id: "64",
            partNumber: "GACAR Part 64",
            titleEn: "Cabin Crewmember Certification and Training",
            titleAr: "ترخيص وتدريب وتأهيل طاقم الضيافة الجوية (الملاحين)",
            category: .licensing,
            summaryEn: "Certification standards, initial and recurrent safety training, emergency procedures, and duty limitations for cabin crewmembers.",
            summaryAr: "شروط إصدار شهادات كفاءة طاقم الضيافة الجوية وبرامج التدريب على حالات الطوارئ والإخلاء والحدود التشغيلية.",
            keySections: [
                GACARSection(
                    sectionCode: "64.15",
                    titleEn: "Cabin Safety & Emergency Evacuation Training",
                    titleAr: "تدريب السلامة وإجراءات الإخلاء في الطوارئ",
                    contentEn: "Cabin crew must complete annual recurrent emergency drills including door operation, ditching, slide deployment, and firefighting.",
                    contentAr: "اجتياز التدريب السنوي الإلزامي على تشغيل مخارج الطوارئ ومزلاجات النجاة ومكافحة الحرائق والإخلاء السريع للركاب."
                )
            ]
        ),
        GACARPart(
            id: "65",
            partNumber: "GACAR Part 65",
            titleEn: "Certification: Airmen Other Than Flight Crewmembers",
            titleAr: "شهادات الملاحين وموظفي العمليات الأرضية",
            category: .licensing,
            summaryEn: "Licensing rules for aircraft dispatchers, air traffic control tower operators, and parachute riggers.",
            summaryAr: "رخص مرحلي الطيران ومراقبي الحركة الجوية وموضبي مظلات الهبوط.",
            keySections: [
                GACARSection(
                    sectionCode: "65.53",
                    titleEn: "Aircraft Dispatcher Eligibility",
                    titleAr: "شروط رخصة مرحل جوي",
                    contentEn: "Minimum age 21, meteorology and navigation knowledge, and completion of GACA-approved dispatcher syllabus.",
                    contentAr: "العمر 21 عاماً، الإلمام بالأرصاد والملاحة الجوية، وإكمال دورة ترحيل معتمدة من GACA."
                )
            ]
        ),
        GACARPart(
            id: "66",
            partNumber: "GACAR Part 66",
            titleEn: "Aircraft Maintenance Engineer Licenses (AMEL)",
            titleAr: "تراخيص مهندسي وفنيي صيانة الطائرات",
            category: .licensing,
            summaryEn: "Standards for Categories A, B1 (Mechanical), B2 (Avionics), and C certifying maintenance personnel.",
            summaryAr: "فئات ومعايير إصدار رخص مهندسي صيانة الطائرات (ميكانيكا وإلكترونيات الطيران).",
            keySections: [
                GACARSection(
                    sectionCode: "66.25",
                    titleEn: "Basic Knowledge & Experience Requirements",
                    titleAr: "الخبرة والمعرفة الفنية المطلوبة",
                    contentEn: "Defines practical hangar experience and modular examination pass criteria across airframes, turbine engines, and avionics.",
                    contentAr: "سنوات الخبرة العملية في حظائر الطائرات واجتياز اختبارات المواد المعتمدة."
                )
            ]
        ),
        GACARPart(
            id: "67",
            partNumber: "GACAR Part 67",
            titleEn: "Medical Standards and Certification",
            titleAr: "المعايير الطبية وإصدار الشهادات الطبية",
            category: .medical,
            summaryEn: "Medical standards and validity durations for Class 1, Class 2, and Class 3 aviation medical certificates.",
            summaryAr: "المعايير الطبية وفترات الصلاحية للشهادات الطبية فئة 1 (تجاري)، فئة 2 (خاص)، وفئة 3 (مراقبة).",
            keySections: [
                GACARSection(
                    sectionCode: "67.13",
                    titleEn: "Class 1 Medical Duration",
                    titleAr: "صلاحية الشهادة الطبية الفئة الأولى",
                    contentEn: "Valid for 12 months for pilots under 40; 6 months for pilots 40 and older in multi-crew commercial airline operations.",
                    contentAr: "صالحة 12 شهراً لمن دون 40 عاماً؛ و6 أشهر للطيارين البالغين 40 عاماً فأكثر في خطوط الطيران."
                ),
                GACARSection(
                    sectionCode: "67.23",
                    titleEn: "Class 2 Medical Duration",
                    titleAr: "صلاحية الشهادة الطبية الفئة الثانية",
                    contentEn: "Valid for 60 months (5 years) for private pilots under 40, and 24 months for pilots 40 and older.",
                    contentAr: "صالحة لمدة 5 سنوات للطيارين دون 40 عاماً، و24 شهراً لمن أتم 40 عاماً فأكثر."
                )
            ]
        ),
        GACARPart(
            id: "68",
            partNumber: "GACAR Part 68",
            titleEn: "Aviation Security Personnel Certification",
            titleAr: "ترخيص واعتماد كوادر ومفتشي أمن الطيران",
            category: .licensing,
            summaryEn: "Qualifications, training, vetting, and certification requirements for aviation security screeners, supervisors, and AVSEC auditors.",
            summaryAr: "معايير التأهيل والفحص الأمني وإصدار تراخيص مفتشي أمن الطيران والمشرفين ومراجعي أمن المطارات.",
            keySections: [
                GACARSection(
                    sectionCode: "68.9",
                    titleEn: "AVSEC Screener Competency & Recertification",
                    titleAr: "كفاءة واختبارات تجديد ترخيص مفتشي الأمن",
                    contentEn: "Aviation security personnel operating X-ray, explosive trace detection, or physical screening must pass periodic GACA proficiency tests.",
                    contentAr: "إلزام مفتشي الأجهزة الأمنية ومعدات الكشف عن المتفجرات باجتياز اختبارات الأداء والكفاءة الدورية الصادرة عن الهيئة."
                )
            ]
        ),

        // MARK: - Division IV: Flight Rules & Airspace
        GACARPart(
            id: "71",
            partNumber: "GACAR Part 71",
            titleEn: "Designation of Airspace and Air Traffic Routes",
            titleAr: "تصنيف وتحديد المجال الجوي والممرات الجوية",
            category: .airports,
            summaryEn: "Classification of airspace (Classes A, B, C, D, E, G), control zones, and designated ATS routes in Saudi Arabia.",
            summaryAr: "تصنيفات المجال الجوي ومناطق المراقبة والممرات الجوية الدولية والداخلية في المملكة.",
            keySections: [
                GACARSection(
                    sectionCode: "71.3",
                    titleEn: "Airspace Classes in Saudi FIR",
                    titleAr: "فئات المجال الجوي في إقليم الطيران السعودي",
                    contentEn: "Class A airspace applies from FL150 to FL600 where all flights are IFR and subject to ATC clearance.",
                    contentAr: "المجال الجوي الفئة A يمتد من FL150 حتى FL600 وتخضع فيه كافة الرحلات لتعليمات المراقبة الجوية وقواعد IFR."
                )
            ]
        ),
        GACARPart(
            id: "77",
            partNumber: "GACAR Part 77",
            titleEn: "Objects Affecting Navigable Airspace",
            titleAr: "العوائق المؤثرة على سلامة المجال الجوي",
            category: .airports,
            summaryEn: "Standards for determining obstructions to air navigation and notification of proposed construction or towers.",
            summaryAr: "معايير رصد وتحديد العوائق والمباني والأبراج الشاهقة وإشعار سلطات الطيران قبل تشييدها.",
            keySections: [
                GACARSection(
                    sectionCode: "77.13",
                    titleEn: "Obstacle Marking & Lighting",
                    titleAr: "إنارة وتحديد العوائق الجوية",
                    contentEn: "Towers and structures exceeding 200 ft AGL or penetrating airport approach slopes must display aviation red/white hazard lights.",
                    contentAr: "إلزامية تركيب إضاءة تحذيرية باللون الأحمر أو الأبيض على الأبراج والمباني التي تتجاوز 200 قدم أو تعترض مسارات الهبوط."
                )
            ]
        ),
        GACARPart(
            id: "91",
            partNumber: "GACAR Part 91",
            titleEn: "General Operating and Flight Rules",
            titleAr: "قواعد التشغيل والطيران العامة",
            category: .operations,
            summaryEn: "Fundamental flight rules in Saudi airspace: VFR/IFR minima, fuel reserves, altimeter settings, airspeed limits, and pilot responsibility.",
            summaryAr: "قواعد الطيران الأساسية: حدود الطقس، احتياطي الوقود، ضبط مقياس الارتفاع، السرعات الجوية، ومسؤولية قائد الطائرة.",
            keySections: [
                GACARSection(
                    sectionCode: "91.3",
                    titleEn: "Responsibility and Authority of Pilot in Command",
                    titleAr: "مسؤولية وصلاحيات قائد الطائرة",
                    contentEn: "The pilot in command is directly responsible for, and is final authority as to, operation of the aircraft. In emergency, PIC may deviate from any rule.",
                    contentAr: "قائد الطائرة هو المسؤول المباشر وصاحب السلطة النهائية لسلامة الطائرة، وله حق الانحراف عن أي قاعدة في الطوارئ."
                ),
                GACARSection(
                    sectionCode: "91.117",
                    titleEn: "Aircraft Speed Limitations",
                    titleAr: "حدود السرعة الجوية",
                    contentEn: "Maximum indicated airspeed below 3,050 m (10,000 ft) AMSL is 250 knots. Within 4 NM of Class C/D airport: maximum 200 knots.",
                    contentAr: "السرعة القصوى تحت 10,000 قدم هي 250 عقدة، وضمن 4 أميال بحرية من مطارات الفئة C/D لا تتجاوز 200 عقدة."
                ),
                GACARSection(
                    sectionCode: "91.119",
                    titleEn: "Minimum Safe Altitudes: General",
                    titleAr: "الحد الأدنى للارتفاعات الآمنة",
                    contentEn: "Over congested areas: 1,000 ft above highest obstacle within 600 m radius. Elsewhere: 500 ft above surface.",
                    contentAr: "فوق المناطق المزدحمة: 1,000 قدم فوق أعلى عائق ضمن دائرة 600 متر. في غيرها: 500 قدم عن السطح."
                ),
                GACARSection(
                    sectionCode: "91.151",
                    titleEn: "Fuel Requirements for Flight in VFR Conditions",
                    titleAr: "احتياطي الوقود للطيران البصري VFR",
                    contentEn: "Requires fuel to fly to first landing destination and then continue for at least 30 minutes by day or 45 minutes by night.",
                    contentAr: "يلزم وقود للوصول إلى الوجهة الأولى ثم مواصلة الطيران لمدة 30 دقيقة نهاراً أو 45 دقيقة ليلاً بسرعة العبور."
                ),
                GACARSection(
                    sectionCode: "91.155",
                    titleEn: "Basic VFR Weather Minimums (Minima)",
                    titleAr: "الحد الأدنى لطقس الطيران البصري VFR",
                    contentEn: "Basic VFR weather minimums and minima in controlled airspace: below 3,050 m (10,000 ft) AMSL requires 5 km flight visibility, cloud clearance and separation 300 m (1,000 ft) vertically, 1,500 m horizontally.",
                    contentAr: "الحد الأدنى لطقس الطيران البصري VFR في الأجواء المراقبة: تحت 3,050 متراً (10,000 قدم) AMSL يتطلب رؤية جوية لا تقل عن 5 كم؛ ومسافة فاصلة والابتعاد عن السحب 300 متر رأسياً و1,500 متر أفقياً."
                ),
                GACARSection(
                    sectionCode: "91.167",
                    titleEn: "Fuel Requirements for Flight in IFR Conditions",
                    titleAr: "احتياطي الوقود للطيران الآلي IFR",
                    contentEn: "Must carry fuel to destination, fly to alternate airport, and continue for 45 minutes at normal cruising speed.",
                    contentAr: "يلزم وقود للوصول إلى الوجهة ثم المطار البديل والتحليق لمدة 45 دقيقة بسرعة العبور العادية."
                ),
                GACARSection(
                    sectionCode: "91.205",
                    titleEn: "Instrument and Equipment Requirements",
                    titleAr: "المعدات والأجهزة الإلزامية للطيران",
                    contentEn: "Mandatory VFR day equipment (ATOMATOFLAMES), VFR night equipment (FLAPS), and IFR instruments (GRABCARD).",
                    contentAr: "الأجهزة والمعدات الإلزامية للطيران البصري نهاراً وليلاً وللطيران الآلي (مؤشر الاتجاه، الأفق الاصطناعي، ومعدات الراديو)."
                )
            ]
        ),
        GACARPart(
            id: "93",
            partNumber: "GACAR Part 93",
            titleEn: "Special Air Traffic Rules",
            titleAr: "قواعد الحركة الجوية الخاصة",
            category: .operations,
            summaryEn: "Prescribes special procedures for high-density airports, VFR flight corridors, and prohibited airspace in Saudi Arabia.",
            summaryAr: "إجراءات الطيران في المطارات ذات الكثافة العالية والممرات البصرية الخاصة والمناطق المحظورة.",
            keySections: [
                GACARSection(
                    sectionCode: "93.5",
                    titleEn: "Prohibited & Restricted Areas",
                    titleAr: "المناطق المحظورة والمقيدة",
                    contentEn: "Prohibits unauthorized flight inside Mecca Haram airspace and specified security/military zones.",
                    contentAr: "حظر الطيران قطعياً فوق الحرم المكي الشريف والمناطق الأمنية والعسكرية دون تصريح خاص."
                )
            ]
        ),
        GACARPart(
            id: "95",
            partNumber: "GACAR Part 95",
            titleEn: "IFR Altitudes and Route Minimums",
            titleAr: "الحد الأدنى لارتفاعات مسارات الطيران الآلي (IFR)",
            category: .operations,
            summaryEn: "Prescribes Minimum Enroute Altitudes (MEA), Minimum Obstruction Clearance Altitudes (MOCA), and changeover points within Saudi airspace.",
            summaryAr: "يحدد الحد الأدنى للارتفاعات الملاحية على المسارات الجوية والارتفاعات الآمنة فوق التضاريس ونقاط تبديل الترددات بالمملكة.",
            keySections: [
                GACARSection(
                    sectionCode: "95.17",
                    titleEn: "Minimum Enroute Altitude (MEA) Compliance",
                    titleAr: "الالتزام بالحد الأدنى لارتفاع المسار (MEA)",
                    contentEn: "Except when cleared by ATC, no pilot may operate an aircraft along a route below the prescribed MEA, guaranteeing terrain clearance and radio reception.",
                    contentAr: "يحظر الطيران على المسارات المعتمدة دون الارتفاع المحدد (MEA) لضمان التغطية اللاسلكية واستلام الإشارات الملاحية وخلو التضاريس."
                )
            ]
        ),
        GACARPart(
            id: "97",
            partNumber: "GACAR Part 97",
            titleEn: "Standard Instrument Approach Procedures (SIAP)",
            titleAr: "إجراءات الاقتراب الآلي القياسية (SIAP)",
            category: .operations,
            summaryEn: "Governs the establishment and operational adherence to ILS, RNP, VOR/DME, and visual transitions for aerodromes in the Kingdom.",
            summaryAr: "يحدد إجراءات الاقتراب الآلي القياسي للهبوط (ILS, RNP, VOR) والحدود الدنيا للرؤية والارتفاع المسموح به للمدرج.",
            keySections: [
                GACARSection(
                    sectionCode: "97.10",
                    titleEn: "Landing Minima & Approach Operations",
                    titleAr: "الحدود الدنيا للهبوط والاقتراب الآلي",
                    contentEn: "Pilots may not descend below Decision Altitude (DA) or Minimum Descent Altitude (MDA) unless visual references for the runway are distinctly visible.",
                    contentAr: "يحظر النزول تحت ارتفاع اتخاذ القرار (DA) أو الارتفاع الأدنى (MDA) ما لم تكن علامات المدرج المرئية واضحة لقائد الطائرة."
                )
            ]
        ),
        GACARPart(
            id: "99",
            partNumber: "GACAR Part 99",
            titleEn: "Security Control of Air Traffic (ADIZ)",
            titleAr: "الرقابة الأمنية على الحركة الجوية ومنطقة تشخيص الطيران",
            category: .airports,
            summaryEn: "Rules for operating in the Saudi Air Defense Identification Zone (ADIZ), flight plan requirements, transponder modes, and position reporting.",
            summaryAr: "قواعد وإجراءات الدخول والعبور في منطقة التشخيص الأمني للدفاع الجوي (ADIZ) وخطة الطيران الإلزامية وتشغيل المستجيب.",
            keySections: [
                GACARSection(
                    sectionCode: "99.11",
                    titleEn: "Flight Plan and Transponder Requirements in ADIZ",
                    titleAr: "خطة الطيران والمستجيب في منطقة ADIZ",
                    contentEn: "Aircraft entering or operating within the Saudi ADIZ must file an approved IFR/DVFR flight plan and operate an altitude-encoding Mode C or Mode S transponder.",
                    contentAr: "وجوب تقديم خطة طيران معتمدة وتشغيل مستجيب تحديد الهوية بالارتفاع (Mode C / Mode S) عند دخول منطقة التشخيص الأمني بالمملكة."
                )
            ]
        ),
        GACARPart(
            id: "101",
            partNumber: "GACAR Part 101",
            titleEn: "Moored Balloons, Kites, Amateur Rockets, and Unmanned Free Balloons",
            titleAr: "المناطيد والطائرات الورقية والصواريخ الهاوية",
            category: .operations,
            summaryEn: "Safety standards and airspace clearance for tethered balloons, meteorological balloons, and model rockets.",
            summaryAr: "شروط إطلاق بالونات الأرصاد والمناطيد والصواريخ التجريبية في الأجواء.",
            keySections: [
                GACARSection(
                    sectionCode: "101.7",
                    titleEn: "Notice Requirements",
                    titleAr: "إشعار المراقبة الجوية",
                    contentEn: "Operators must notify nearest ATC facility at least 24 hours prior to operating tethered balloons or rockets.",
                    contentAr: "إشعار برج المراقبة قبل 24 ساعة على الأقل من إطلاق أي مناطيد أو صواريخ هوائية."
                )
            ]
        ),
        GACARPart(
            id: "102",
            partNumber: "GACAR Part 102",
            titleEn: "Commercial Operations of Unmanned Aircraft",
            titleAr: "تشغيل الطائرات بدون طيار للأغراض التجارية المتقدمة",
            category: .uas,
            summaryEn: "Certification, operational safety cases, and BVLOS (Beyond Visual Line of Sight) authorizations for commercial drone fleets in Saudi Arabia.",
            summaryAr: "تراخيص التشغيل التجاري المتقدم للطائرات المسيرة، والطيران خارج مدى الرؤية البصرية (BVLOS)، ونقل البضائع والمراقبة الجوية.",
            keySections: [
                GACARSection(
                    sectionCode: "102.7",
                    titleEn: "BVLOS and Swarm Operations Authorization",
                    titleAr: "تصاريح الطيران خارج نطاق الرؤية البصرية (BVLOS)",
                    contentEn: "Commercial drone operators conducting BVLOS or multi-drone operations must hold a GACA Part 102 Operating Certificate and approved safety risk assessment.",
                    contentAr: "اشتراط الحصول على شهادة مشغل تجاري وخطة تقييم مخاطر معتمدة لتشغيل الدرونز خارج مدى الرؤية أو في المناطق المأهولة."
                )
            ]
        ),
        GACARPart(
            id: "103",
            partNumber: "GACAR Part 103",
            titleEn: "Ultralight Vehicles",
            titleAr: "الطائرات الشراعية فائقة الخفة",
            category: .operations,
            summaryEn: "Rules for single-occupant recreational ultralight vehicles (microlights, paramotors, powered paragliders).",
            summaryAr: "قواعد تشغيل الطائرات الشراعية الخفيفة والباراموتور والباراجلايدر للأغراض الترفيهية.",
            keySections: [
                GACARSection(
                    sectionCode: "103.9",
                    titleEn: "Daylight Operations Only",
                    titleAr: "حظر الطيران الليلي للطائرات الخفيفة",
                    contentEn: "Ultralight vehicles may only be operated between sunrise and sunset, clear of clouds, and outside congested areas.",
                    contentAr: "يُحظر طيران الطائرات الشراعية الخفيفة ليلاً ويقتصر تشغيلها بين شروق الشمس وغروبها بعيداً عن التجمعات السكانية."
                )
            ]
        ),
        GACARPart(
            id: "105",
            partNumber: "GACAR Part 105",
            titleEn: "Parachute Operations",
            titleAr: "عمليات القفز المظلي",
            category: .operations,
            summaryEn: "Rules governing sport and demonstration skydiving and parachute jumping in Saudi airspace.",
            summaryAr: "لوائح القفز المظلي الرياضي والعروض المظلية وتصاريح إسقاط المظليين.",
            keySections: [
                GACARSection(
                    sectionCode: "105.15",
                    titleEn: "ATC Notification & Radio Communications",
                    titleAr: "إشعار المراقبة الجوية والاتصال اللاسلكي",
                    contentEn: "Jump aircraft must maintain continuous two-way radio contact with ATC and obtain clearance prior to jumper exit.",
                    contentAr: "إلزامية البقاء على اتصال لاسلكي مستمر مع المراقبة وأخذ الإذن قبل قفز المظليين."
                )
            ]
        ),
        GACARPart(
            id: "107",
            partNumber: "GACAR Part 107",
            titleEn: "Small Unmanned Aircraft Systems (sUAS / Drones)",
            titleAr: "أنظمة الطائرات الصغيرة بدون طيار (الدرونز)",
            category: .uas,
            summaryEn: "Regulations for commercial and recreational drones under 25 kg: remote pilot license, altitude limit, and night flight.",
            summaryAr: "لوائح طائرات الدرونز دون 25 كجم: رخص الطيار عن بعد، قيود الارتفاع، والطيران الليلي.",
            keySections: [
                GACARSection(
                    sectionCode: "107.51",
                    titleEn: "sUAS Operating Limitations",
                    titleAr: "القيود التشغيلية للدرونز",
                    contentEn: "Maximum groundspeed 87 knots (100 mph); maximum altitude 400 ft above ground level (AGL); yield right-of-way to manned aircraft.",
                    contentAr: "السرعة القصوى 87 عقدة؛ والارتفاع الأقصى 400 قدم فوق سطح الأرض (AGL)؛ وإعطاء الأفضلية دائماً للطائرات المأهولة."
                ),
                GACARSection(
                    sectionCode: "107.31",
                    titleEn: "Visual Line of Sight (VLOS)",
                    titleAr: "خط الرؤية البصري المباشر",
                    contentEn: "Remote pilot in command must maintain visual line of sight with the drone at all times without unaided vision devices.",
                    contentAr: "يجب على طيار الدرون إبقاء الطائرة ضمن خط الرؤية البصرية المباشرة بالعين المجردة دون أجهزة تقريب."
                )
            ]
        ),

        // MARK: - Division V: Commercial Air Transport Operations
        GACARPart(
            id: "109",
            partNumber: "GACAR Part 109",
            titleEn: "Indirect Air Carrier Security (Regulated Cargo Agents)",
            titleAr: "أمن وكلاء الشحن الجوي والناقلين غير المباشرين",
            category: .airports,
            summaryEn: "Security controls, screening mandates, secure storage, and chain of custody for freight forwarders and cargo shipping agents.",
            summaryAr: "المعايير الأمنية لوكلاء الشحن الجوي المعتمدين وسلسلة الإمداد الآمنة وتفتيش ومراقبة الطرود قبل شحنها جواً.",
            keySections: [
                GACARSection(
                    sectionCode: "109.5",
                    titleEn: "Regulated Cargo Screening and Verification",
                    titleAr: "فحص وتفتيش الشحنات والبضائع الجوية",
                    contentEn: "Regulated agents must subject all air freight from non-known shippers to 100% security screening before acceptance for civil transport.",
                    contentAr: "إلزام وكلاء الشحن بفحص كافة الشحنات الجوية بالمسح الأمني المعتمد وضمان سلامة الطرود من المواد المحظورة قبل قبولها."
                )
            ]
        ),
        GACARPart(
            id: "111",
            partNumber: "GACAR Part 111",
            titleEn: "Airport Security Programs and Operations",
            titleAr: "أمن المطارات والبرامج الأمنية للمطارات المدنية",
            category: .airports,
            summaryEn: "Mandatory security programs, access control, airside identification badges (AOA/SIDA), and perimeter security for Saudi civil aerodromes.",
            summaryAr: "البرامج الأمنية الإلزامية للمطارات وضوابط تصاريح الدخول للمناطق الحيوية (SIDA) وتأمين الأسوار وحماية الطائرات الرابضة.",
            keySections: [
                GACARSection(
                    sectionCode: "111.15",
                    titleEn: "Security Restricted Areas (SRA) Access",
                    titleAr: "الدخول إلى المناطق الأمنية المقيدة بالمطار",
                    contentEn: "Strict background check, electronic badge access, and vehicle screening required for all individuals entering airside restricted areas.",
                    contentAr: "تطبيق الفحص الأمني الصارم وإبراز التصاريح الإلكترونية المعتمدة للأفراد والمركبات عند دخول المنطقة الجوية المقيدة."
                )
            ]
        ),
        GACARPart(
            id: "112",
            partNumber: "GACAR Part 112",
            titleEn: "In-Flight Catering and Supply Chain Security",
            titleAr: "أمن الإعاشة والتموين وسلاسل الإمداد الجوي",
            category: .airports,
            summaryEn: "Security controls, tamper-evident sealing, kitchen vetting, and delivery transport for in-flight meals and cabin supplies.",
            summaryAr: "المعايير الأمنية لشركات التموين والإعاشة الجوية، وفحص الوجبات، وسلامة شاحنات التموين والأختام الأمنية على عربات الطائرات.",
            keySections: [
                GACARSection(
                    sectionCode: "112.8",
                    titleEn: "Catering Cart Sealing and Delivery",
                    titleAr: "تأمين وختم عربات الإعاشة والوجبات",
                    contentEn: "All catering carts and supplies dispatched to passenger aircraft must be sealed with numbered tamper-evident seals verified upon ramp transfer.",
                    contentAr: "إلزام منشآت التموين بوضع أختام أمنية مشفرة ومرقمة على عربات الطعام وتفتيش شاحنات الرفع قبل اقترابها من الطائرة."
                )
            ]
        ),
        GACARPart(
            id: "115",
            partNumber: "GACAR Part 115",
            titleEn: "Air Carrier Security Programs",
            titleAr: "البرامج الأمنية للناقلين الجويين الوطنيين",
            category: .operations,
            summaryEn: "Security management programs, flight deck access security, unruly passenger containment, and unlawful interference defense for Saudi air operators.",
            summaryAr: "البرامج الأمنية للشركات الجوية، وحماية قمرة القيادة، والتعامل مع الركاب المشاغبين، وإجراءات مكافحة التهديدات غير المشروعة.",
            keySections: [
                GACARSection(
                    sectionCode: "115.19",
                    titleEn: "Flight Deck Door Access & Cockpit Security",
                    titleAr: "تأمين باب قمرة القيادة ومنع الدخول غير المصرح",
                    contentEn: "The flight deck door must remain closed and locked from engine startup to shutdown, allowing entry only through secured video verification protocols.",
                    contentAr: "إحكام إغلاق وقفل باب قمرة القيادة طوال الرحلة وعدم فتحه إلا وفق بروتوكولات التحقق البصري والإشارات الأمنية المتفق عليها."
                )
            ]
        ),
        GACARPart(
            id: "118",
            partNumber: "GACAR Part 118",
            titleEn: "Aviation Security Quality Control and Oversight",
            titleAr: "الرقابة وضمان الجودة لأمن الطيران (AVSEC QC)",
            category: .operations,
            summaryEn: "Establishes National Civil Aviation Security Quality Control Program (NCASQCP) audits, undercover testing, and compliance monitoring across the Kingdom.",
            summaryAr: "البرنامج الوطني لضمان جودة أمن الطيران المدني، وإجراء الاختبارات التسللية والمراجعات التفتيشية للمطارات والناقلين.",
            keySections: [
                GACARSection(
                    sectionCode: "118.5",
                    titleEn: "Security Audits, Inspections, and Tests",
                    titleAr: "التفتيش والتدقيق واختبارات الجاهزية الأمنية",
                    contentEn: "GACA AVSEC inspectors possess unrestricted authority to audit facilities, inspect baggage systems, and conduct covert security testing.",
                    contentAr: "تخويل مفتشي أمن الطيران صلاحيات التفتيش والمراجعة الميدانية وتنفيذ اختبارات سرية لتقييم كفاءة وجاهزية الإجراءات الأمنية."
                )
            ]
        ),
        GACARPart(
            id: "119",
            partNumber: "GACAR Part 119",
            titleEn: "Certification: Air Carriers and Commercial Operators",
            titleAr: "شهادات المشغلين الجويين وشركات الطيران",
            category: .operations,
            summaryEn: "Requirements for obtaining an Air Operator Certificate (AOC) for scheduled and charter airlines.",
            summaryAr: "شروط الحصول على شهادة المشغل الجوي (AOC) وإدارات العمليات الجوية والصيانة المعتمدة.",
            keySections: [
                GACARSection(
                    sectionCode: "119.65",
                    titleEn: "Required Management Personnel",
                    titleAr: "القيادات الإدارية الإلزامية لشركات الطيران",
                    contentEn: "AOC holders must maintain qualified full-time personnel: Director of Operations, Chief Pilot, Director of Maintenance, and Chief Inspector.",
                    contentAr: "يلزم كل شركة طيران تعيين مدير للعمليات، وكبير للطيارين، ومدير للصيانة، وكبير للمفتشين بدوام كامل."
                )
            ]
        ),
        GACARPart(
            id: "121",
            partNumber: "GACAR Part 121",
            titleEn: "Operating Requirements: Domestic, Flag, and Supplemental Operations",
            titleAr: "متطلبات تشغيل رحلات الخطوط الجوية المنتظمة",
            category: .operations,
            summaryEn: "The commercial airline standard: crew flight duty limitations, dispatch releases, ETOPS, passenger briefings, and emergency equipment.",
            summaryAr: "معايير عمليات خطوط الطيران التجارية الكبرى: ساعات عمل وراحة الطيارين، الترحيل الجوي، ومعدات الطوارئ.",
            keySections: [
                GACARSection(
                    sectionCode: "121.471",
                    titleEn: "Flight Time Limitations & Rest Requirements",
                    titleAr: "أوقات الطيران وفترات الراحة الإلزامية للطيارين",
                    contentEn: "Mandates maximum daily flight time (typically 8-9 hours), cumulative monthly limits, and minimum 10 consecutive hours of rest.",
                    contentAr: "يحدد ساعات الطيران اليومية وساعات الراحة الإلزامية (10 ساعات متواصلة) للوقاية من إجهاد الطيارين."
                ),
                GACARSection(
                    sectionCode: "121.639",
                    titleEn: "Fuel Requirements for Dispatch",
                    titleAr: "احتياطي الوقود لاعتماد الرحلات الجوية التجارية",
                    contentEn: "Must carry fuel to destination, fly to most distant alternate, and fly for 45 minutes at normal cruising consumption.",
                    contentAr: "تعبئة وقود كافٍ للوجهة والوصول إلى أبعد مطار بديل ومواصلة الطيران لمدة 45 دقيقة بسرعة العبور."
                )
            ]
        ),
        GACARPart(
            id: "125",
            partNumber: "GACAR Part 125",
            titleEn: "Certification: Large Airplanes (20+ Passengers)",
            titleAr: "تشغيل الطائرات الكبيرة الخاصة (20 راكباً فأكثر)",
            category: .operations,
            summaryEn: "Governs private carriage operations in large transport airplanes not operated as common air carriers.",
            summaryAr: "قواعد تشغيل الطائرات النفاثة الكبيرة الخاصة ورجال الأعمال بسعة 20 راكباً فأكثر دون طرح تذاكر تجارية.",
            keySections: [
                GACARSection(
                    sectionCode: "125.287",
                    titleEn: "Crewmember Testing & Checkride Requirements",
                    titleAr: "اختبارات كفاءة أطقم الطائرات الكبيرة",
                    contentEn: "Requires initial and recurrent proficiency checks every 12 months for PIC and SIC in approved flight simulators.",
                    contentAr: "إلزامية الخضوع لاختبارات كفاءة نصف سنوية وسنوية لقادة الطائرات ومساعديهم على مشبهات الطيران."
                )
            ]
        ),
        GACARPart(
            id: "126",
            partNumber: "GACAR Part 126",
            titleEn: "General Aviation Operations of Foreign Registered Aircraft",
            titleAr: "تشغيل الطائرات الأجنبية الخاصة والعامة بالمملكة",
            category: .operations,
            summaryEn: "Requirements for corporate, private, and state foreign-registered aircraft flying into or operating within the airspace of Saudi Arabia.",
            summaryAr: "الاشتراطات التشغيلية والفنية لطائرات الطيران العام والخاص الأجنبية أثناء الهبوط أو العبور في الأجواء السعودية.",
            keySections: [
                GACARSection(
                    sectionCode: "126.3",
                    titleEn: "Saudi Overflight and Landing Authorizations",
                    titleAr: "تصاريح العبور والهبوط للطائرات الأجنبية",
                    contentEn: "Foreign-registered general aviation aircraft must obtain GACA flight clearance, demonstrate valid TCAS II/RVSM approvals, and adhere to GACAR flight rules.",
                    contentAr: "اشتراط الحصول على تصريح مسبق من الهيئة وتوفر معايير RVSM ونظام منع التصادم TCAS وشهادة تأمين سارية قبل دخول الأجواء."
                )
            ]
        ),
        GACARPart(
            id: "129",
            partNumber: "GACAR Part 129",
            titleEn: "Operations: Foreign Air Carriers",
            titleAr: "عمليات شركات الطيران الأجنبية",
            category: .operations,
            summaryEn: "Rules and authorizations for foreign airlines operating international flights to/from airports in Saudi Arabia.",
            summaryAr: "شروط وتصاريح تشغيل شركات الطيران الدولية والأجنبية القادمة والمغادرة عبر مطارات المملكة.",
            keySections: [
                GACARSection(
                    sectionCode: "129.11",
                    titleEn: "Foreign Air Carrier Operating Specifications",
                    titleAr: "المواصفات التشغيلية للناقل الأجنبي",
                    contentEn: "Foreign operators must hold valid GACA Part 129 operations specifications and adhere to ICAO Annex safety standards.",
                    contentAr: "حصول الناقل الأجنبي على مواصفات تشغيلية معتمدة من GACA والامتثال لمعايير الإيكاو."
                )
            ]
        ),
        GACARPart(
            id: "131",
            partNumber: "GACAR Part 131",
            titleEn: "Commercial Operations of Free Balloons and Gliders",
            titleAr: "العمليات التجارية للمناطيد الحرة والطائرات الشراعية",
            category: .operations,
            summaryEn: "Safety standards, pilot privileges, weather minimums, and commercial passenger-carrying rules for hot air balloons and gliders in tourist areas.",
            summaryAr: "معايير السلامة ورخص الطيارين والحدود الجوية الدنيا لتشغيل مناطيد الركاب السياحية والطائرات الشراعية للأغراض التجارية.",
            keySections: [
                GACARSection(
                    sectionCode: "131.9",
                    titleEn: "Surface Wind Limitations for Commercial Balloon Flights",
                    titleAr: "حدود سرعة الرياح السطحية لإطلاق المناطيد",
                    contentEn: "No commercial passenger balloon flight may launch when surface wind velocity exceeds 10 knots or when gust spreads exceed 5 knots.",
                    contentAr: "يحظر إطلاق مناطيد نقل الركاب السياحية إذا تجاوزت سرعة الرياح السطحية 10 عقد أو كانت هناك هبات مفاجئة تزيد على 5 عقد."
                )
            ]
        ),
        GACARPart(
            id: "133",
            partNumber: "GACAR Part 133",
            titleEn: "Rotorcraft External-Load Operations",
            titleAr: "عمليات الحمولات الخارجية للطائرات العمودية",
            category: .operations,
            summaryEn: "Safety standards for helicopters carrying external sling loads, construction hoisting, or human external cargo.",
            summaryAr: "شروط استخدام طائرات الهليكوبتر في رفع الحمولات المعلقة وأعمال الإنشاءات ونقل الأفراد خارجياً.",
            keySections: [
                GACARSection(
                    sectionCode: "133.35",
                    titleEn: "Congested Area External Load Operations",
                    titleAr: "الحمولات المعلقة فوق المناطق المأهولة",
                    contentEn: "Requires safety plan approval and multi-engine helicopter capabilities when lifting external loads over cities.",
                    contentAr: "خطة أمان معتمدة ومروحية بمحركين عند رفع حمولات خارجية فوق المدن والمناطق السكنية."
                )
            ]
        ),
        GACARPart(
            id: "135",
            partNumber: "GACAR Part 135",
            titleEn: "Commuter and On-Demand Operations (Air Taxi / Charters)",
            titleAr: "عمليات التاكسي الجوي والرحلات العارضة (Charters)",
            category: .operations,
            summaryEn: "Operating standards for commercial air charter, on-demand executive jet charter, and small aircraft operations.",
            summaryAr: "معايير تشغيل طائرات التاكسي الجوي والرحلات العارضة وطائرات رجال الأعمال الخاصة المستأجرة.",
            keySections: [
                GACARSection(
                    sectionCode: "135.267",
                    titleEn: "Flight Time Limitations for Charter Crew",
                    titleAr: "ساعات الطيران لطواقم الرحلات العارضة",
                    contentEn: "Daily flight time limits (8 hours for single pilot, 10 hours for two-pilot crew) with required rest buffers.",
                    contentAr: "ساعات الطيران اليومية للطيارين (8 ساعات للطيار المنفرد، 10 ساعات للطاقم الثنائي) مع راحة لا تقل عن 10 ساعات."
                ),
                GACARSection(
                    sectionCode: "135.209",
                    titleEn: "VFR Fuel Supply for Air Taxi",
                    titleAr: "احتياطي الوقود للطيران البصري التجاري",
                    contentEn: "Requires fuel to fly to destination and then at least 30 minutes by day or 45 minutes by night.",
                    contentAr: "الوقود حتى نقطة الهبوط الأولى بالإضافة إلى 30 دقيقة نهاراً أو 45 دقيقة ليلاً."
                )
            ]
        ),
        GACARPart(
            id: "136",
            partNumber: "GACAR Part 136",
            titleEn: "Commercial Air Tours and Aerial Sightseeing",
            titleAr: "الجولات الجوية السياحية والمسح والتصوير الجوي",
            category: .operations,
            summaryEn: "Operating restrictions, minimum safe altitudes, briefing cards, and floatation gear requirements for commercial sightseeing and aerial tourism.",
            summaryAr: "لوائح رحلات المشاهدة السياحية والرحلات الاستعراضية وتصاريح التصوير الجوي والارتفاعات الدنيا فوق المعالم الوطنية.",
            keySections: [
                GACARSection(
                    sectionCode: "136.7",
                    titleEn: "Minimum Altitudes and Passenger Briefings",
                    titleAr: "الارتفاعات الدنيا وإحاطة ركاب الجولات السياحية",
                    contentEn: "Commercial sightseeing flights must maintain at least 1,500 ft AGL over congested scenic areas and provide life preservers when operating beyond gliding distance from shore.",
                    contentAr: "الالتزام بعدم النزول عن 1500 قدم فوق المناطق المأهولة وتوفير سترات النجاة وإحاطة الركاب بمخارج الطوارئ قبل الإقلاع."
                )
            ]
        ),
        GACARPart(
            id: "137",
            partNumber: "GACAR Part 137",
            titleEn: "Agricultural Aircraft Operations",
            titleAr: "عمليات الطيران الزراعي ورش المحاصيل",
            category: .operations,
            summaryEn: "Rules for aerial dispensing of agricultural chemicals, pest control, and crop dusting in Saudi Arabia.",
            summaryAr: "شروط استخدام الطائرات في الرش الزراعي والمبيدات الحشرية ومكافحة الآفات الزراعية.",
            keySections: [
                GACARSection(
                    sectionCode: "137.37",
                    titleEn: "Maneuvers Over Congested Areas",
                    titleAr: "التحليق المنخفض فوق المناطق الزراعية",
                    contentEn: "Strict protocols to prevent chemical drift or low-altitude hazards to uninvolved persons or livestock.",
                    contentAr: "ضوابط منع تسرب المواد الكيميائية وحماية الأشخاص والمواشي أثناء التحليق المنخفض."
                )
            ]
        ),
        GACARPart(
            id: "139",
            partNumber: "GACAR Part 139",
            titleEn: "Certification of Aerodromes",
            titleAr: "شهادات واعتماد المطارات المدنية",
            category: .airports,
            summaryEn: "Standards for airport rescue and firefighting (ARFF), runway friction, wildlife hazard management, and emergency plans.",
            summaryAr: "شروط وإجراءات ترخيص المطارات: خدمات الإطفاء والإنقاذ (ARFF)، سلامة المدارج، ومكافحة مخاطر الطيور.",
            keySections: [
                GACARSection(
                    sectionCode: "139.319",
                    titleEn: "Aircraft Rescue and Firefighting (ARFF)",
                    titleAr: "خدمات الإطفاء والإنقاذ بالمطار",
                    contentEn: "Prescribes ARFF response time (maximum 3 minutes to midpoint of farthest runway) and required vehicle agent capacity.",
                    contentAr: "زمن استجابة فرق الإطفاء والإنقاذ بحد أقصى 3 دقائق لأبعد نقطة في المدرج مع كميات الرغوة والماء الإلزامية."
                )
            ]
        ),
        GACARPart(
            id: "141",
            partNumber: "GACAR Part 141",
            titleEn: "Pilot Schools",
            titleAr: "أكاديميات ومعاهد تدريب الطيران",
            category: .licensing,
            summaryEn: "Certification standards for structured flight training academies, chief instructors, and examining authority.",
            summaryAr: "معايير ترخيص أكاديميات تدريب الطيران، تعيين كبار المدربين، وصلاحيات الاختبارات المعتمدة.",
            keySections: [
                GACARSection(
                    sectionCode: "141.35",
                    titleEn: "Chief Instructor Qualifications",
                    titleAr: "شروط كبير مدربي الطيران",
                    contentEn: "Chief flight instructor must possess Airline Transport Pilot or Commercial Pilot license and extensive instructional experience.",
                    contentAr: "خبرة تدريبية واسعة ورخصة طيار تجاري أو خطوط طيران لتولي منصب كبير المدربين."
                )
            ]
        ),
        GACARPart(
            id: "142",
            partNumber: "GACAR Part 142",
            titleEn: "Training Centers",
            titleAr: "مراكز تدريب الطيران المتقدم",
            category: .licensing,
            summaryEn: "Standards for specialized simulator training centers providing airline type-rating and recurrent courses.",
            summaryAr: "شروط مراكز التدريب المتقدم المعتمدة على مشبهات الطيران لإصدار أهليات النوع (Type Ratings).",
            keySections: [
                GACARSection(
                    sectionCode: "142.47",
                    titleEn: "Simulator Training Curriculum",
                    titleAr: "مناهج التدريب التشبيهي المعتمدة",
                    contentEn: "Simulator curricula must be approved by GACA prior to conducting credit-bearing pilot recurrent or conversion courses.",
                    contentAr: "اعتماد مناهج التدريب التشبيهي من GACA قبل احتساب الساعات التدريبية للطيارين."
                )
            ]
        ),
        GACARPart(
            id: "145",
            partNumber: "GACAR Part 145",
            titleEn: "Approved Maintenance Organizations (AMO)",
            titleAr: "مراكز صيانة الطائرات المعتمدة (AMO)",
            category: .maintenance,
            summaryEn: "Certification requirements for domestic and international aircraft maintenance repair stations.",
            summaryAr: "معايير ترخيص ورش ومراكز صيانة الطائرات والمحركات والقطع المعتمدة من الهيئة.",
            keySections: [
                GACARSection(
                    sectionCode: "145.211",
                    titleEn: "Quality Assurance System",
                    titleAr: "نظام ضمان الجودة في الصيانة",
                    contentEn: "AMOs must maintain an independent quality audit system to ensure all maintenance meets manufacturer standards.",
                    contentAr: "إلزامية وجود نظام تدقيق جودة مستقل لضمان مطابقة أعمال الصيانة لمواصفات الشركات المصنعة."
                )
            ]
        ),
        GACARPart(
            id: "147",
            partNumber: "GACAR Part 147",
            titleEn: "Aviation Maintenance Technician Schools",
            titleAr: "معاهد تدريب فنيي صيانة الطائرات",
            category: .maintenance,
            summaryEn: "Curriculum standards, shop facilities, and instructor ratios for certifying aircraft maintenance technician schools.",
            summaryAr: "معايير معاهد صيانة الطائرات وتجهيز الورش العملية ومناهج تأهيل المهندسين والفنيين.",
            keySections: [
                GACARSection(
                    sectionCode: "147.21",
                    titleEn: "General Curriculum Requirements",
                    titleAr: "المناهج الفنية المعتمدة",
                    contentEn: "Requires practical workshop hours covering airframe systems, turbine powerplants, and electrical fundamentals.",
                    contentAr: "ساعات تدريب عملية مكثفة في ورش هياكل ومحركات الطائرات والدوائر الكهربائية."
                )
            ]
        ),
        GACARPart(
            id: "149",
            partNumber: "GACAR Part 149",
            titleEn: "Aviation Clubs and Air Show Organizations",
            titleAr: "تنظيم أندية الطيران والفعاليات والعروض الجوية",
            category: .operations,
            summaryEn: "Certification of sport aviation organizations, flight demonstration teams, air show waivers, and aerobatic safety corridors.",
            summaryAr: "ترخيص نوادي الطيران الرياضي، واعتماد ممرات العروض الجوية، ومعايير السلامة والمسافات الفاصلة عن الجمهور في المهرجانات.",
            keySections: [
                GACARSection(
                    sectionCode: "149.12",
                    titleEn: "Air Show Crowd Separation & Safety Lines",
                    titleAr: "خطوط الأمان ومسافات الفصل عن الجمهور في العروض",
                    contentEn: "Aerobatic maneuvers during sanctioned air shows must maintain strictly enforced lateral and vertical buffer lines separating aircraft from spectators.",
                    contentAr: "حظر تنفيذ المناورات البهلوانية باتجاه الجمهور وإلزام الطيارين بالبقاء خلف خط الأمان (Show Line) المعتمد من الهيئة."
                )
            ]
        ),
        GACARPart(
            id: "151",
            partNumber: "GACAR Part 151",
            titleEn: "Aerodrome Development and Infrastructure Standards",
            titleAr: "تطوير وتخطيط البنية التحتية للمطارات المدنية",
            category: .airports,
            summaryEn: "Planning, master planning, runway geometry, pavement strength (PCN/ACN), and obstacle limitation surfaces (OLS) for civil aerodromes.",
            summaryAr: "المخطط العام للمطارات، وتصميم المدارج، وقوة تحمل الرصف (PCN)، ومسافات الأمان وأسطح حظر العوائق المحيطة بالمطار.",
            keySections: [
                GACARSection(
                    sectionCode: "151.15",
                    titleEn: "Runway Pavement Classification & PCN",
                    titleAr: "تصنيف متانة أرضيات المدارج ورقم PCN",
                    contentEn: "Aerodromes must publish certified Pavement Classification Numbers (PCN) and ensure aircraft tire pressures do not exceed structural limits.",
                    contentAr: "نشر بيانات متانة المدرج المعتمدة (PCN) والتأكد من توافق أوزان وضغط إطارات الطائرات مع الطاقة الاستيعابية للأرضيات."
                )
            ]
        ),
        GACARPart(
            id: "153",
            partNumber: "GACAR Part 153",
            titleEn: "Aerodrome Ground Operations and Safety Management",
            titleAr: "إدارة وتشغيل ساحات الطيران وسلامة المهابط",
            category: .airports,
            summaryEn: "Airside driving, apron management, Foreign Object Debris (FOD) mitigation, wildlife hazard management, and runway friction monitoring.",
            summaryAr: "إدارة حركة ساحة الطائرات والمهابط، والوقاية من الأجسام الغريبة (FOD)، وخطة مكافحة خطر الطيور والحياة الفطرية في المطارات.",
            keySections: [
                GACARSection(
                    sectionCode: "153.21",
                    titleEn: "Runway Incursion Prevention and FOD Controls",
                    titleAr: "منع توغل المدارج ومكافحة الأجسام الغريبة (FOD)",
                    contentEn: "Aerodrome operators must conduct continuous runway sweepings, monitor friction coefficients, and mandate runway crossing permits.",
                    contentAr: "إلزام إدارة المطار بالمسح المستمر للمدارج وقياس معامل الاحتكاك وتطبيق إجراءات صارمة لمنع التوغل الخاطئ للمدرج."
                )
            ]
        ),
        GACARPart(
            id: "155",
            partNumber: "GACAR Part 155",
            titleEn: "Aerodrome Rescue and Fire Fighting Services (ARFF)",
            titleAr: "خدمات الإطفاء والإنقاذ بالمطارات (ARFF)",
            category: .airports,
            summaryEn: "Airport fire category classification (CAT 1 to CAT 10), rapid response time limits (under 3 minutes), foam agent reserves, and crash-rescue personnel.",
            summaryAr: "فئات الإطفاء والإنقاذ بالمطارات (من الفئة 1 حتى 10)، وزمن الاستجابة السريع (أقل من 3 دقائق)، ومخزون مواد الرغوة والمياه.",
            keySections: [
                GACARSection(
                    sectionCode: "155.5",
                    titleEn: "ARFF Response Time and Operational Readiness",
                    titleAr: "زمن استجابة فرق الإطفاء والجاهزية الميدانية",
                    contentEn: "ARFF emergency vehicles must demonstrate response times of not more than 3 minutes to the midpoint of the farthest operational runway.",
                    contentAr: "وجوب وصول مركبات الإطفاء والإنقاذ إلى أي نقطة في مهبط الطائرات التشغيلي خلال مدة زمنية لا تتجاوز 3 دقائق من إطلاق الإنذار."
                )
            ]
        ),
        GACARPart(
            id: "157",
            partNumber: "GACAR Part 157",
            titleEn: "Notice of Construction, Alteration, or Deactivation of Aerodromes",
            titleAr: "الإخطار بإنشاء أو تعديل أو إغلاق المطارات والمهابط",
            category: .airports,
            summaryEn: "Procedures for submitting advance notices to GACA prior to establishing, expanding, modifying, or permanently decommissioning airfields and heliports.",
            summaryAr: "إجراءات إشعار الهيئة العامة للطيران المدني قبل البدء في إنشاء أو تعديل أو هدم أو إغلاق أي مطار أو مهبط طائرات عام أو خاص.",
            keySections: [
                GACARSection(
                    sectionCode: "157.3",
                    titleEn: "Advance Notice of Aerodrome Construction",
                    titleAr: "الإخطار المسبق بإنشاء المهابط والمطارات",
                    contentEn: "Proponents must submit notice to GACA at least 90 days before beginning construction, alteration, or deactivation of any landing area.",
                    contentAr: "تقديم إشعار رسمي مكتوب للهيئة قبل 90 يوماً على الأقل من بدء أي أعمال إنشائية أو تعديلات على مهابط ومطارات المملكة."
                )
            ]
        ),
        GACARPart(
            id: "161",
            partNumber: "GACAR Part 161",
            titleEn: "Airport Noise and Environmental Access Restrictions",
            titleAr: "قيود الضوضاء وحماية البيئة بالمطارات",
            category: .airports,
            summaryEn: "Studies, night curfew procedures, noise contour modeling, and community consultations for implementing airport operational restrictions.",
            summaryAr: "دراسات النمذجة الصوتية وحظر الطيران الليلي وتقييم الأثر البيئي قبل فرض قيود على تشغيل الطائرات بالمطارات.",
            keySections: [
                GACARSection(
                    sectionCode: "161.9",
                    titleEn: "Mandatory Noise Assessment and Curfew Approvals",
                    titleAr: "تقييم الضوضاء واعتماد أوقات الحظر الليلي",
                    contentEn: "Aerodrome operators may not implement Stage 2/3 aircraft bans or night noise restrictions without prior cost-benefit evaluation approved by GACA.",
                    contentAr: "حظر فرض قيود تشغيلية أو منع هبوط الطائرات ليلاً دون دراسة الجدوى وتحديد البصمة الصوتية وموافقة الهيئة المسبقة."
                )
            ]
        ),

        // MARK: - Division VI: Air Navigation & Air Traffic Control
        GACARPart(
            id: "170",
            partNumber: "GACAR Part 170",
            titleEn: "Air Traffic Services",
            titleAr: "خدمات المراقبة والحركة الجوية",
            category: .airports,
            summaryEn: "Standards for provision of air traffic control (aerodrome, approach, area control) and flight information services.",
            summaryAr: "معايير تقديم خدمات المراقبة الجوية (برج المطار، الاقتراب، ومركز المراقبة الجوية) وخدمات معلومات الطيران.",
            keySections: [
                GACARSection(
                    sectionCode: "170.15",
                    titleEn: "ATC Separation Standards",
                    titleAr: "معايير الفصل بين الطائرات",
                    contentEn: "Horizontal and vertical separation minima (typically 1,000 ft vertical below FL290 and in RVSM airspace).",
                    contentAr: "المسافات الفاصلة بين الطائرات أفقياً ورأسياً (1,000 قدم رأسياً في أجواء RVSM)."
                )
            ]
        ),
        GACARPart(
            id: "171",
            partNumber: "GACAR Part 171",
            titleEn: "Aeronautical Telecommunication and Navigation Facilities",
            titleAr: "منظومات الملاحة والاتصالات الجوية",
            category: .airports,
            summaryEn: "Certification and flight calibration of VOR, DME, ILS, and radar ground navigation facilities.",
            summaryAr: "معايير اعتماد والمعايرة الجوية لأجهزة الملاحة الأرضية (ILS, VOR, DME) ومحطات الرادار.",
            keySections: [
                GACARSection(
                    sectionCode: "171.23",
                    titleEn: "Flight Inspection of Navigation Aids",
                    titleAr: "الفحص والمعايرة الجوية للمساعدات الملاحية",
                    contentEn: "ILS glide path and localizer signals must undergo regular airborne flight check inspections for signal accuracy.",
                    contentAr: "المعايرة الدورية لأجهزة الهبوط الآلي ILS عبر طائرات فحص مخصصة لضمان دقة الإشارات."
                )
            ]
        ),
        GACARPart(
            id: "172",
            partNumber: "GACAR Part 172",
            titleEn: "Aeronautical Information Services (AIS)",
            titleAr: "خدمات معلومات الطيران (AIS)",
            category: .airports,
            summaryEn: "Production and distribution of the Aeronautical Information Publication (AIP-KSA), NOTAMs, and AICs.",
            summaryAr: "إصدار وتوزيع دليل معلومات الطيران السعودي (AIP-KSA) والإعلانات الملاحية (NOTAMs).",
            keySections: [
                GACARSection(
                    sectionCode: "172.9",
                    titleEn: "NOTAM Origination & Promulgation",
                    titleAr: "إصدار وتوزيع إعلانات NOTAM",
                    contentEn: "Immediate dissemination of NOTAMs concerning runway closures, navigational aid outages, and military firing exercises.",
                    contentAr: "نشر فوري لإعلانات NOTAM عند إغلاق المدارج أو تعطل الأجهزة الملاحية أو وجود تدريبات جوية."
                )
            ]
        ),
        GACARPart(
            id: "173",
            partNumber: "GACAR Part 173",
            titleEn: "Instrument Flight Procedure Design (PANS-OPS)",
            titleAr: "تصميم إجراءات الطيران الآلي (PANS-OPS)",
            category: .airports,
            summaryEn: "Design criteria for standard instrument departures (SID), standard terminal arrivals (STAR), and instrument approaches (RNP/ILS).",
            summaryAr: "معايير تصميم مسارات المغادرة والاقتراب الآلي المعياري (SID & STAR) وإجراءات الهبوط الدقيق.",
            keySections: [
                GACARSection(
                    sectionCode: "173.11",
                    titleEn: "Obstacle Clearance Altitudes (OCA/OCH)",
                    titleAr: "ارتفاعات خلو العوائق عند الاقتراب",
                    contentEn: "Determines minimum obstacle clearance margins during final instrument approach and missed approach segments.",
                    contentAr: "حساب الارتفاعات الآمنة والمسافات الفاصلة عن العوائق أثناء مرحلة الاقتراب والهبوط الالتفافي."
                )
            ]
        ),
        GACARPart(
            id: "175",
            partNumber: "GACAR Part 175",
            titleEn: "Aeronautical Charts",
            titleAr: "الخرائط الملاحية الجوية",
            category: .airports,
            summaryEn: "Standards for aerodrome obstacle charts, VFR sectional charts, en-route high/low IFR charts, and terminal charts.",
            summaryAr: "مواصفات وإعداد خرائط الطيران البصري والخرائط الملاحية للارتفاعات العالية والمنخفضة.",
            keySections: [
                GACARSection(
                    sectionCode: "175.7",
                    titleEn: "Chart Symbology and Geodetic Datum",
                    titleAr: "رموز الخرائط والنظام الجيوديسي",
                    contentEn: "All Saudi aeronautical charts must reference WGS-84 coordinate datum and standard ICAO aeronautical symbols.",
                    contentAr: "اعتماد النظام الجيوديسي العالمي WGS-84 والرموز الملاحية القياسية في كافة الخرائط الجوية."
                )
            ]
        ),
        GACARPart(
            id: "177",
            partNumber: "GACAR Part 177",
            titleEn: "Carriage of Dangerous Goods by Air",
            titleAr: "نقل البضائع الخطرة جواً",
            category: .operations,
            summaryEn: "Rules aligning with ICAO Technical Instructions for classification, packaging, labeling, and handling of hazardous materials on aircraft.",
            summaryAr: "لوائح تصنيف وتغليف وتوثيق ونقل المواد والبضائع الخطرة على متن الطائرات في السعودية.",
            keySections: [
                GACARSection(
                    sectionCode: "177.21",
                    titleEn: "Notification to Captain (NOTOC)",
                    titleAr: "إشعار قائد الطائرة بالبضائع الخطرة (NOTOC)",
                    contentEn: "Pilot in command must receive written notification specifying proper shipping name, UN number, class, and cargo location before departure.",
                    contentAr: "تسليم قائد الطائرة إشعاراً كتابياً (NOTOC) يوضح نوع وكمية وموقع البضائع الخطرة المشحونة على متن الطائرة."
                )
            ]
        ),
        GACARPart(
            id: "179",
            partNumber: "GACAR Part 179",
            titleEn: "Aeronautical Meteorological Services",
            titleAr: "خدمات الأرصاد الجوية للملاحة والطيران المدني",
            category: .operations,
            summaryEn: "Provision of aviation weather forecasts, METAR/SPECI reports, TAF terminal forecasts, SIGMET warnings, and meteorological briefings.",
            summaryAr: "تنظيم تقديم خدمات ومعلومات الأرصاد الجوية للملاحة، وتقارير METAR وTAF وتحذيرات SIGMET للظواهر الجوية الخطرة.",
            keySections: [
                GACARSection(
                    sectionCode: "179.15",
                    titleEn: "Dissemination of METAR, TAF, and SIGMET Reports",
                    titleAr: "إصدار وبث تقارير METAR وTAF وتحذيرات SIGMET",
                    contentEn: "Certified meteorological service providers must ensure continuous automated or manual observation and immediate dissemination of hazardous weather.",
                    contentAr: "إلزام مراكز الأرصاد بالرصد المستمر وبث تقارير الطقس الدورية والتحذير الفوري من العواصف الرعدية ومطبات الهواء الشديدة."
                )
            ]
        )
    ]
}

