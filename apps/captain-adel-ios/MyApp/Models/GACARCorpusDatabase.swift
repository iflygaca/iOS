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
                    titleEn: "Basic VFR Weather Minimums",
                    titleAr: "الحد الأدنى لطقس الطيران البصري VFR",
                    contentEn: "Below 10,000 ft AMSL in controlled airspace: minimum 5 km flight visibility; cloud clearance 300 m (1,000 ft) vertically, 1,500 m horizontally.",
                    contentAr: "تحت 10,000 قدم في الأجواء المراقبة: رؤية جوية لا تقل عن 5 كم؛ والابتعاد عن السحب 300 متر رأسياً و1,500 متر أفقياً."
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
                    sectionCode: "121.619",
                    titleEn: "Alternate Airport for Destination: IFR (1-2-3 Rule)",
                    titleAr: "المطار البديل لوجهة الهبوط: قواعد IFR (قاعدة 1-2-3)",
                    contentEn: "No alternate airport is required if for at least 1 hour before and 1 hour after estimated time of arrival, the ceiling is at least 2,000 feet above airport elevation and visibility is at least 3 statute miles (5 km).",
                    contentAr: "لا يشترط تحديد مطار بديل إذا كانت تقارير وتوقعات الطقس تشير إلى أن السقف الغيمي لا يقل عن 2,000 قدم فوق ارتفاع المطار والرؤية لا تقل عن 3 أميال قانونية (5 كم) لمدة ساعة واحدة قبل وساعة واحدة بعد وقت الوصول المقدر."
                ),
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
            id: "3",
            partNumber: "GACAR Part 3",
            titleEn: "General Requirements & Compliance",
            titleAr: "المتطلبات العامة والامتثال للأنظمة",
            category: .operations,
            summaryEn: "Foundational rules requiring compliance with aviation regulations, safety directives, and reporting obligations.",
            summaryAr: "القواعد الأساسية الملزمة بالامتثال للوائح الطيران المدني وتوجيهات السلامة الصادرة عن الهيئة العامة للطيران المدني.",
            keySections: [
                GACARSection(
                    sectionCode: "3.5",
                    titleEn: "Falsification, Reproduction, or Alteration",
                    titleAr: "تزوير أو تحريف السجلات والشهادات",
                    contentEn: "Strict prohibition against making fraudulent or intentionally false statements on any application, logbook, or certificate.",
                    contentAr: "حظر تام للإدلاء بأي بيانات غير صحيحة أو تزوير السجلات وسجلات الطيران والرخص والشهادات المعتمدة."
                )
            ]
        ),
        GACARPart(
            id: "7",
            partNumber: "GACAR Part 7",
            titleEn: "Aviation Safety Review & Oversight",
            titleAr: "مراجعة ورقابة السلامة الجوية",
            category: .operations,
            summaryEn: "Procedures for aviation safety audits, inspections, and regulatory compliance reviews by GACA inspectors.",
            summaryAr: "إجراءات التدقيق والرقابة الميدانية والتفتيش الدوري على المشغلين ومرافق الطيران المدني.",
            keySections: [
                GACARSection(
                    sectionCode: "7.11",
                    titleEn: "Access for Inspection",
                    titleAr: "صلاحيات التفتيش والرقابة الميدانية",
                    contentEn: "Authorizes GACA inspectors unrestricted access to aircraft, facilities, and records to verify continued compliance.",
                    contentAr: "منح مفتشي الهيئة العامة للطيران المدني صلاحية الدخول غير المقيد للطائرات والمنشآت والسجلات للتحقق من الامتثال."
                )
            ]
        ),
        GACARPart(
            id: "11",
            partNumber: "GACAR Part 11",
            titleEn: "General Rulemaking Procedures",
            titleAr: "إجراءات سن وتعديل اللوائح التنظيمية",
            category: .operations,
            summaryEn: "Public petitioning, notice of proposed rulemaking, and exemption procedures under GACA administrative law.",
            summaryAr: "آلية إصدار وتعديل لوائح الطيران المدني وتقديم الالتماسات وطلبات الاستثناءات النظامية.",
            keySections: [
                GACARSection(
                    sectionCode: "11.25",
                    titleEn: "Petitions for Exemption",
                    titleAr: "طلبات الاستثناء النظامي",
                    contentEn: "Detailed criteria and safety risk assessment required when petitioning GACA for regulatory exemptions.",
                    contentAr: "المعايير وتقييم مخاطر السلامة المطلوب عند التقدم بطلب استثناء من أحكام أي لائحة تنفيذية."
                )
            ]
        ),
        GACARPart(
            id: "26",
            partNumber: "GACAR Part 26",
            titleEn: "Continued Airworthiness & Safety Improvements",
            titleAr: "استمرارية الجدارة الجوية والتحسينات الإلزامية",
            category: .maintenance,
            summaryEn: "Requirements for transport category airplanes: aging aircraft systems, damage tolerance, and fuel tank safety.",
            summaryAr: "متطلبات طائرات النقل التجاري لمواجهة تقادم الهياكل والأنظمة والوقاية من اشتعال خزانات الوقود وتعب المعادن.",
            keySections: [
                GACARSection(
                    sectionCode: "26.33",
                    titleEn: "Fuel Tank Flammability Reduction",
                    titleAr: "الحد من قابلية اشتعال خزانات الوقود",
                    contentEn: "Mandates nitrogen inerting systems or ignition mitigation means for center fuel tanks.",
                    contentAr: "إلزامية تركيب أنظمة خمول النيتروجين أو وسائل خفض قابلية الاشتعال لخزانات الوقود المركزية."
                )
            ]
        ),
        GACARPart(
            id: "31",
            partNumber: "GACAR Part 31",
            titleEn: "Airworthiness Standards: Manned Free Balloons",
            titleAr: "معايير الجدارة الجوية: المناطيد المأهولة الحرة",
            category: .maintenance,
            summaryEn: "Design, envelope integrity, burners, and control systems for commercial and private manned hot air balloons.",
            summaryAr: "معايير تصميم ومتانة غلاف المنطاد ومواقد الاحتراق وأنظمة التحكم في مناطيد الهواء الساخن السياحية والخاصة.",
            keySections: [
                GACARSection(
                    sectionCode: "31.14",
                    titleEn: "Envelope Deflation Systems",
                    titleAr: "أنظمة تفريغ غلاف المنطاد في الطوارئ",
                    contentEn: "Requires rapid deflation systems to prevent dragging upon landing in windy desert conditions.",
                    contentAr: "اشتراط وجود أنظمة تفريغ سريع لمنع جر المنطاد على الأرض عند الهبوط في الظروف الصحراوية النشطة الرياح."
                )
            ]
        ),
        GACARPart(
            id: "34",
            partNumber: "GACAR Part 34",
            titleEn: "Fuel Venting & Exhaust Emission Requirements",
            titleAr: "معايير تصريف الوقود وانبعاثات عادم الطائرات",
            category: .maintenance,
            summaryEn: "Environmental prevention of intentional fuel venting and emission standards for turbine-powered aircraft.",
            summaryAr: "معايير حماية البيئة ومنع تصريف الوقود في الجو وضبط انبعاثات محركات الطائرات النفاثة والتوربينية.",
            keySections: [
                GACARSection(
                    sectionCode: "34.11",
                    titleEn: "Fuel Venting Prevention",
                    titleAr: "حظر تصريف الوقود غير المبرر",
                    contentEn: "Requires aircraft fuel systems to discharge no liquid fuel runoff during normal ground operations and taxiing.",
                    contentAr: "إلزام أنظمة وقود الطائرات بمنع أي تسرب أو تفريغ للوقود السائل أثناء العمليات الأرضية والتدريج."
                )
            ]
        ),
        GACARPart(
            id: "36",
            partNumber: "GACAR Part 36",
            titleEn: "Noise Standards: Aircraft Type & Airworthiness",
            titleAr: "معايير الضوضاء: طراز الطائرة وشهادة الصلاحية",
            category: .maintenance,
            summaryEn: "Acoustical certification standards for subsonic jets, supersonic aircraft, and helicopters under ICAO Annex 16.",
            summaryAr: "المعايير الصوتية والبيئية لقياس ضوضاء الطائرات النفاثة والمروحيات وفق الملحق السادس عشر لمنظمة الإيكاو.",
            keySections: [
                GACARSection(
                    sectionCode: "36.7",
                    titleEn: "Acoustical Change & Noise Measurement",
                    titleAr: "التغيرات الصوتية وقياس مستويات الضجيج",
                    contentEn: "Standards for measuring effective perceived noise level (EPNdB) during flyover, lateral, and approach.",
                    contentAr: "معايير قياس مستوى الضوضاء المدرك الفعلي (EPNdB) عند التحليق والاقتراب والمستوى الجانبي للمدرج."
                )
            ]
        ),
        GACARPart(
            id: "49",
            partNumber: "GACAR Part 49",
            titleEn: "Recording of Aircraft Titles & Security Documents",
            titleAr: "تسجيل صكوك ووثائق ملكية ورهن الطائرات",
            category: .operations,
            summaryEn: "Official recording of conveyances, leases, liens, and mortgages on civil aircraft registered in Saudi Arabia.",
            summaryAr: "إجراءات التوثيق الرسمي لعقود البيع والإيجار والرهون والامتيازات على الطائرات المسجلة في السجل السعودي.",
            keySections: [
                GACARSection(
                    sectionCode: "49.17",
                    titleEn: "Conveyances Recorded",
                    titleAr: "توثيق انتقال الملكية والرهون",
                    contentEn: "Requires notarized submission of bills of sale and financing contracts to establish legal validity against third parties.",
                    contentAr: "اشتراط تسجيل عقود البيع والتمويل رسمياً لدى الهيئة لإثبات حجيتها القانونية في مواجهة الغير."
                )
            ]
        ),
        GACARPart(
            id: "64",
            partNumber: "GACAR Part 64",
            titleEn: "Cabin Crew Licensing & Competency Standards",
            titleAr: "معايير وترخيص أطقم الضيافة والمقصورة",
            category: .licensing,
            summaryEn: "Initial qualification, recurrent safety training, emergency evacuations, and aeromedical standards for cabin crew.",
            summaryAr: "معايير التأهيل والتدريب السنوي وإجراءات الإخلاء في الطوارئ والمعايير الصحية لأطقم الضيافة الجوية.",
            keySections: [
                GACARSection(
                    sectionCode: "64.31",
                    titleEn: "Emergency Evacuation Duties",
                    titleAr: "واجبات الإخلاء في حالات الطوارئ",
                    contentEn: "Mandatory practical drill competencies including 90-second aircraft evacuation, slide deployment, and ditching.",
                    contentAr: "التدريبات العملية الإلزامية لإخلاء الطائرة في غضون 90 ثانية ونشر زلاقات النجاة والهبوط الاضطراري على الماء."
                )
            ]
        ),
        GACARPart(
            id: "68",
            partNumber: "GACAR Part 68",
            titleEn: "Remote Pilot Crew Medical Standards",
            titleAr: "المعايير الطبية لمشغلي الطائرات بدون طيار (الدرونز)",
            category: .licensing,
            summaryEn: "Medical fitness declarations, visual acuity, and cognitive fitness required for beyond visual line of sight (BVLOS) operations.",
            summaryAr: "معايير اللياقة الصحية والحدة البصرية والكفاءة الذهنية لمشغلي الدرونز في رحلات ما وراء مدى الرؤية البصرية (BVLOS).",
            keySections: [
                GACARSection(
                    sectionCode: "68.5",
                    titleEn: "Visual Acuity and Depth Perception",
                    titleAr: "الحدة البصرية وإدراك المسافات لمشغلي الدرونز",
                    contentEn: "Distant visual acuity of 20/20 corrected or uncorrected, with normal field of vision and color recognition.",
                    contentAr: "اشتراط حدة إبصار 20/20 بنظارة أو بدونها مع سلامة مجال الرؤية والتمييز الدقيق للألوان الملاحية."
                )
            ]
        ),
        GACARPart(
            id: "73",
            partNumber: "GACAR Part 73",
            titleEn: "Special Use Airspace",
            titleAr: "المجالات الجوية ذات الاستخدام الخاص والمحظورة",
            category: .airports,
            summaryEn: "Designation and operational rules for restricted, prohibited, danger, and military training airspaces across KSA.",
            summaryAr: "تحديد وتصنيف المناطق المحظورة والمقيدة ومناطق التدريب العسكري في الأجواء السعودية وقواعد عبورها.",
            keySections: [
                GACARSection(
                    sectionCode: "73.13",
                    titleEn: "Prohibited and Restricted Airspace Entry",
                    titleAr: "شروط دخول المناطق المقيدة والمحظورة",
                    contentEn: "No aircraft may operate within a prohibited area, or restricted area without explicit authorization from the controlling ATC agency.",
                    contentAr: "يحظر تماماً على أي طائرة دخول المناطق المحظورة أو المقيدة دون تصريح مسبق وتنسيق مباشر مع وحدة المراقبة الجوية المسؤولة."
                )
            ]
        ),
        GACARPart(
            id: "97",
            partNumber: "GACAR Part 97",
            titleEn: "Standard Instrument Procedures",
            titleAr: "إجراءات الطيران الآلي القياسية (SID / STAR / Approach)",
            category: .operations,
            summaryEn: "Establishment of standard instrument approach procedures, SIDs, STARs, and minimum takeoff visibility limits.",
            summaryAr: "اعتماد إجراءات المغادرة الآلية القياسية (SID) والوصول الآلي (STAR) وإجراءات الاقتراب الدقيق وغير الدقيق بالمطارات.",
            keySections: [
                GACARSection(
                    sectionCode: "97.10",
                    titleEn: "Takeoff Minimums and Obstacle Departure",
                    titleAr: "الحدود الدنيا للإقلاع ومسارات تجنب العوائق",
                    contentEn: "Defines standard climb gradients (200 ft/NM minimum) and takeoff weather minimums for commercial operators.",
                    contentAr: "تحديد معدلات الصعود القياسية لتفادي العوائق (200 قدم/ميل بحري كحد أدنى) والحدود الدنيا للأرصاد عند الإقلاع."
                )
            ]
        ),
        GACARPart(
            id: "99",
            partNumber: "GACAR Part 99",
            titleEn: "Security Control of Air Traffic (ADIZ)",
            titleAr: "المراقبة الأمنية للحركة الجوية ومنطقة تشخيص الدفاع الجوي",
            category: .operations,
            summaryEn: "Mandates flight plans, two-way radio communications, and transponder operation when entering the Saudi ADIZ.",
            summaryAr: "قواعد خطط الطيران الإلزامية والاتصال اللاسلكي وتشغيل أجهزة التعرف (Transponder) عند دخول منطقة تشخيص الدفاع الجوي.",
            keySections: [
                GACARSection(
                    sectionCode: "99.11",
                    titleEn: "Flight Plan and Position Reporting in ADIZ",
                    titleAr: "خطة الطيران والإبلاغ عن الموقع في منطقة ADIZ",
                    contentEn: "Requires IFR or Defense VFR (DVFR) flight plan and position reports prior to entering the Air Defense Identification Zone.",
                    contentAr: "إلزام تقديم خطة طيران IFR أو DVFR والإبلاغ عن الموقع قبل اختراق منطقة تشخيص الدفاع الجوي للمملكة."
                )
            ]
        ),
        GACARPart(
            id: "108",
            partNumber: "GACAR Part 108",
            titleEn: "Air Operator Security Programs",
            titleAr: "البرامج الأمنية للمشغلين الجويين",
            category: .operations,
            summaryEn: "Passenger screening, baggage inspection, cockpit door security, and in-flight security coordinator protocols.",
            summaryAr: "إجراءات تفتيش الركاب والأمتعة وتحصين أبواب قمرة القيادة وبروتوكولات منسق الأمن على متن الطائرات.",
            keySections: [
                GACARSection(
                    sectionCode: "108.9",
                    titleEn: "Flight Deck Security and Access Control",
                    titleAr: "أمن قمرة القيادة وضبط الدخول",
                    contentEn: "Reinforced flight deck door must remain locked from exterior during flight except for necessary physiological crew duties.",
                    contentAr: "إلزام إغلاق وقفل باب مقصورة القيادة المصفح طوال مدة الرحلة باستثناء الظروف التشغيلية الحتمية."
                )
            ]
        ),
        GACARPart(
            id: "109",
            partNumber: "GACAR Part 109",
            titleEn: "Indirect Air Carrier & Freight Forwarder Security",
            titleAr: "أمن وسطاء الشحن الجوي والطرود",
            category: .operations,
            summaryEn: "Security vetting, cargo screening, and chain of custody for air cargo transported on passenger or cargo flights.",
            summaryAr: "معايير الفحص الأمني للشحنات الجوية وسلسلة الحيازة الآمنة للبضائع المنقولة جواً على متن الطائرات التجارية.",
            keySections: [
                GACARSection(
                    sectionCode: "109.5",
                    titleEn: "Known Consignor & Cargo Screening",
                    titleAr: "نظام الشاحن المعتمد وتفتيش الشحنات",
                    contentEn: "All cargo originating from non-known consignors must undergo 100% explosive trace or X-ray screening.",
                    contentAr: "إخضاع جميع الشحنات غير الصادرة عن جهات شحن معتمدة للفحص الإشعاعي بنسبة 100% قبل التحميل."
                )
            ]
        ),
        GACARPart(
            id: "111",
            partNumber: "GACAR Part 111",
            titleEn: "Aviation Fuel Supply Quality & Safety Standards",
            titleAr: "معايير جودة وسلامة إمدادات وقود الطيران",
            category: .airports,
            summaryEn: "Quality assurance, filtration, water check testing, storage farm inspections, and airport fueling operations.",
            summaryAr: "ضمان جودة وقود الطائرات (Jet A-1 / Avgas) واختبارات نقاء المياه وتفتيش صهاريج ومحطات التزويد بالمطارات.",
            keySections: [
                GACARSection(
                    sectionCode: "111.15",
                    titleEn: "Fuel Quality Testing and Contamination Checks",
                    titleAr: "اختبارات نقاء الوقود وفحص الشوائب والرواسب",
                    contentEn: "Daily water detector capsule testing and filter differential pressure monitoring prior to aircraft fueling.",
                    contentAr: "الفحص اليومي بالكبسولات الكاشفة للماء ومراقبة فرق الضغط في فلاتر التزود بالوقود قبل تغذية الطائرات."
                )
            ]
        ),
        GACARPart(
            id: "115",
            partNumber: "GACAR Part 115",
            titleEn: "Ground Handling Services & Ramp Safety",
            titleAr: "خدمات المناولة الأرضية وسلامة ساحات الطائرات",
            category: .airports,
            summaryEn: "Certification of ground handlers, marshalling, pushback operations, ground support equipment (GSE), and FOD control.",
            summaryAr: "ترخيص شركات المناولة الأرضية وإجراءات الإرشاد والدفع الخلفي (Pushback) ومكافحة الأجسام الغريبة (FOD).",
            keySections: [
                GACARSection(
                    sectionCode: "115.22",
                    titleEn: "Foreign Object Debris (FOD) Prevention",
                    titleAr: "برامج الوقاية من الأجسام الغريبة (FOD)",
                    contentEn: "Mandatory regular sweeps and immediate clean-up protocols on aircraft stands and taxiway apron areas.",
                    contentAr: "حملات التمشيط اليومية الإلزامية وإزالة المخلفات الفورية من مواقف الطائرات ومسارات ساحات المطار."
                )
            ]
        ),
        GACARPart(
            id: "120",
            partNumber: "GACAR Part 120",
            titleEn: "Drug and Alcohol Testing Program",
            titleAr: "برنامج فحص المؤثرات العقلية والكحول لمنسوبي الطيران",
            category: .licensing,
            summaryEn: "Mandatory pre-employment, random, post-accident, and reasonable-suspicion testing for safety-sensitive personnel.",
            summaryAr: "الفحص الإلزامي قبل التوظيف والفحص العشوائي وبعد الحوادث للطيارين والمراقبين الجويين ومهندسي الصيانة.",
            keySections: [
                GACARSection(
                    sectionCode: "120.33",
                    titleEn: "Random Testing Protocols and Alcohol Limits",
                    titleAr: "ضوابط الفحص العشوائي ونسبة الكحول الصفرية",
                    contentEn: "Zero-tolerance policy: alcohol concentration above 0.00% or within 8 hours of flight duty constitutes immediate disqualification.",
                    contentAr: "سياسة عدم التهاون التام: حظر تعاطي أي نسبة كحول أو مهدئات خلال 8 ساعات قبل أداء واجبات الطيران."
                )
            ]
        ),
        GACARPart(
            id: "136",
            partNumber: "GACAR Part 136",
            titleEn: "Commercial Air Tours & Sightseeing Operations",
            titleAr: "عمليات الجولات الجوية السياحية واستطلاع المعالم",
            category: .operations,
            summaryEn: "Altitude minimums, environmental noise curfews, and passenger briefings for scenic flights around heritage sites.",
            summaryAr: "معايير الارتفاعات الآمنة والحد من الضجيج وإجراءات السلامة لرحلات الاستطلاع السياحي فوق المواقع التراثية (مثل العلا).",
            keySections: [
                GACARSection(
                    sectionCode: "136.17",
                    titleEn: "Minimum Altitudes Over Sensitive Heritage Zones",
                    titleAr: "الحد الأدنى للارتفاع فوق المناطق الأثرية المحمية",
                    contentEn: "Mandates minimum 2,000 feet AGL over protected national heritage sites except on designated approved visual flight paths.",
                    contentAr: "حظر الطيران تحت ارتفاع 2,000 قدم فوق سطح الأرض في المواقع التراثية المحمية إلا في مسارات معتمدة مسبقاً."
                )
            ]
        ),
        GACARPart(
            id: "143",
            partNumber: "GACAR Part 143",
            titleEn: "Flight Training Devices & Aviation Ground Schools",
            titleAr: "أجهزة المحاكاة والتدريب والمدارس الأرضية للطيران",
            category: .licensing,
            summaryEn: "Certification standards for Full Flight Simulators (FFS Levels A-D) and Flight Training Devices (FTD).",
            summaryAr: "معايير اعتماد وتقييم أجهزة المحاكاة التشبيهية الكاملة (FFS من الفئة A إلى D) وأجهزة التدريب التشبيهي.",
            keySections: [
                GACARSection(
                    sectionCode: "143.9",
                    titleEn: "Level D Full Flight Simulator Certification",
                    titleAr: "اعتماد أجهزة المحاكاة التشبيهية الكاملة الفئة D",
                    contentEn: "Full motion 6-degrees-of-freedom, high-fidelity day/night visual systems, and validation against aircraft flight test data.",
                    contentAr: "اشتراط حركة كاملة بـ 6 درجات حرية ورؤية بصرية نهارية/ليلية متطابقة مع بيانات اختبار الطيران الحقيقية للطائرة."
                )
            ]
        ),
        GACARPart(
            id: "149",
            partNumber: "GACAR Part 149",
            titleEn: "Recreational & Light Sport Aviation Organizations",
            titleAr: "منظمات وأندية الطيران الترفيهي والرياضي الخفيف",
            category: .operations,
            summaryEn: "Oversight, safety management, airworthiness standards, and pilot certifications for sport aviation clubs.",
            summaryAr: "قواعد الإشراف وإدارة السلامة وإصدار التراخيص لأندية الطيران الشراعي والرياضي الخفيف في المملكة.",
            keySections: [
                GACARSection(
                    sectionCode: "149.12",
                    titleEn: "Operating Sites and Flight Envelopes",
                    titleAr: "مواقع الأنشطة ومجالات الطيران الترفيهي",
                    contentEn: "Operations restricted to designated approved club airfields outside controlled terminal airspace (CTR/TMA).",
                    contentAr: "حصر أنشطة الطيران الترفيهي في المهابط والأندية المعتمدة خارج نطاق المجالات الجوية الخاضعة للمراقبة للمطارات الدولية."
                )
            ]
        ),
        GACARPart(
            id: "151",
            partNumber: "GACAR Part 151",
            titleEn: "Airport Development & Master Planning Aid",
            titleAr: "المخططات الشاملة وتطوير وتوسعة المطارات",
            category: .airports,
            summaryEn: "Master plan submission, runway capacity projections, obstacle limitation surfaces, and terminal expansion standards.",
            summaryAr: "إعداد المخططات الشاملة لتوسعة المطارات ومطارات الرؤية 2030 وتحديد أسطح تحديد العوائق وسعة المدارج.",
            keySections: [
                GACARSection(
                    sectionCode: "151.8",
                    titleEn: "Airport Master Plan Approval",
                    titleAr: "اعتماد المخطط الرئيسي لتطوير المطار",
                    contentEn: "Requires 20-year traffic forecasts, environmental impact assessment, and GACA approval before major civil construction.",
                    contentAr: "اشتراط دراسات حركة الطيران لـ 20 عاماً وتقييم الأثر البيئي واعتماد الهيئة قبل البدء في أعمال الإنشاءات الكبرى."
                )
            ]
        ),
        GACARPart(
            id: "152",
            partNumber: "GACAR Part 152",
            titleEn: "Airport Aid Programs & Infrastructure Grants",
            titleAr: "برامج دعم وتطوير البنية التحتية للمطارات",
            category: .airports,
            summaryEn: "Standards and auditing for infrastructure funding, runway resurfacing, navigation aids, and safety perimeter fencing.",
            summaryAr: "معايير التمويل والتدقيق على مشاريع سفلتة المدارج وتركيب المساعدات الملاحية والأسوار الأمنية للمطارات.",
            keySections: [
                GACARSection(
                    sectionCode: "152.14",
                    titleEn: "Safety Perimeter and Security Fencing",
                    titleAr: "الأسوار الأمنية وحماية حرم المطار",
                    contentEn: "Requires intrusion detection systems, anti-burrowing mesh, and constant perimeter patrols for all certified airports.",
                    contentAr: "إلزام تسييج حرم المطار بأنظمة استشعار الاختراق وشبك حماية أرضي ودوريات أمنية على مدار الساعة."
                )
            ]
        ),
        GACARPart(
            id: "156",
            partNumber: "GACAR Part 156",
            titleEn: "National Airport System Planning",
            titleAr: "التخطيط الاستراتيجي لمنظومة المطارات الوطنية",
            category: .airports,
            summaryEn: "Strategic integration of international hubs, regional feeder airports, and domestic tourist aerodromes.",
            summaryAr: "التكامل الاستراتيجي بين المطارات المحورية الدولية والمطارات الإقليمية ومطارات الوجهات السياحية الوطنية.",
            keySections: [
                GACARSection(
                    sectionCode: "156.4",
                    titleEn: "Airport Classification Criteria",
                    titleAr: "معايير تصنيف المطارات الوطنية",
                    contentEn: "Classifies aerodromes into Primary Hubs, Regional Gateways, and General Aviation Community Airfields.",
                    contentAr: "تصنيف المطارات في المملكة إلى مطارات محورية رئيسية، وبوابات إقليمية، ومطارات طيران عام تخدم المجتمعات المحلية."
                )
            ]
        ),
        GACARPart(
            id: "161",
            partNumber: "GACAR Part 161",
            titleEn: "Airport Noise & Access Restrictions",
            titleAr: "ضوابط وقيود الضوضاء ومواعيد العمل في المطارات",
            category: .airports,
            summaryEn: "Rules governing nighttime flight curfews, preferential runway noise abatement, and noise contour modeling.",
            summaryAr: "ضوابط حظر الطيران الليلي في المطارات الحضرية ومسارات خفض الضوضاء التفصيلية ونمذجة خرائط التلوث الصوتي.",
            keySections: [
                GACARSection(
                    sectionCode: "161.9",
                    titleEn: "Noise Abatement Departure Procedures (NADP)",
                    titleAr: "إجراءات المغادرة للحد من الضوضاء (NADP-1 / NADP-2)",
                    contentEn: "Mandates specific thrust reduction and flap retraction schedules to minimize aircraft noise over residential neighborhoods.",
                    contentAr: "تحديد بروتوكولات تقليل قوة الدفع ورفع القلابات لتفادي التأثير الصوتي فوق التجمعات السكنية المجاورة للمطار."
                )
            ]
        ),
        GACARPart(
            id: "174",
            partNumber: "GACAR Part 174",
            titleEn: "Aviation Meteorology Services (MET)",
            titleAr: "خدمات الأرصاد الجوية للطيران (METAR / TAF / SIGMET)",
            category: .airports,
            summaryEn: "Certification of aviation weather providers, automated weather stations (AWOS), TAF forecasting, and SIGMET advisories.",
            summaryAr: "ترخيص مقدمي خدمات أرصاد الطيران ومحطات الرصد الآلية (AWOS) وإصدار التنبؤات والتحذيرات الجوية من العواصف الرملية.",
            keySections: [
                GACARSection(
                    sectionCode: "174.15",
                    titleEn: "Sandstorm and Dust Phenomenon Advisories",
                    titleAr: "تحذيرات العواصف الرملية وانخفاض الرؤية",
                    contentEn: "Mandates immediate issuance of SIGMET and SPECI reports when blowing sand reduces visibility below 1,000 meters.",
                    contentAr: "إلزامية إصدار تقارير SIGMET فورية عند انخفاض الرؤية إلى أقل من 1,000 متر بسبب العواصف الرملية والعوالق الترابية."
                )
            ]
        ),
        GACARPart(
            id: "176",
            partNumber: "GACAR Part 176",
            titleEn: "Aeronautical Information Services (AIS / NOTAM)",
            titleAr: "خدمات معلومات الطيران وإصدار النوتام (NOTAM / AIP)",
            category: .airports,
            summaryEn: "Publishing Aeronautical Information Publication (AIP), NOTAM issuance, AIRAC cycles, and pre-flight briefing bulletins.",
            summaryAr: "نشر دليل معلومات الطيران السعودي (AIP) وإصدار إعلانات الطيارين (NOTAM) ودورات AIRAC لتحديث أنظمة الملاحة.",
            keySections: [
                GACARSection(
                    sectionCode: "176.20",
                    titleEn: "NOTAM Issuance and AIRAC Publication Cycles",
                    titleAr: "إصدار النوتام ودورات تحديث AIRAC (كل 28 يوماً)",
                    contentEn: "Strict 28-day AIRAC publication cycle for permanent changes in airspace, navigation aids, and instrument procedures.",
                    contentAr: "الالتزام التام بدورة AIRAC العالمية كل 28 يوماً لتحديث بيانات مسارات الملاحة والترددات والمطارات في أجهزة الطائرات."
                )
            ]
        ),
        GACARPart(
            id: "178",
            partNumber: "GACAR Part 178",
            titleEn: "Search and Rescue Organization (SAR)",
            titleAr: "خدمات ومنظومة البحث والإنقاذ الجوي",
            category: .operations,
            summaryEn: "Establishment of Rescue Coordination Centers (RCC), emergency locator transmitter (ELT 406 MHz) tracking, and desert rescue.",
            summaryAr: "تنظيم مراكز تنسيق الإنقاذ (RCC) ومتابعة إشارات أجهزة الاستغاثة (ELT بتردد 406 ميجاهرتز) وعمليات الإنقاذ في المناطق الصحراوية.",
            keySections: [
                GACARSection(
                    sectionCode: "178.11",
                    titleEn: "Emergency Locator Transmitter (ELT 406 MHz) Monitoring",
                    titleAr: "مراقبة أجهزة بث الاستغاثة في الطوارئ (ELT 406 MHz)",
                    contentEn: "Continuous 24/7 satellite monitoring via Cospas-Sarsat and direct alerting within 15 minutes of signal distress.",
                    contentAr: "المراقبة الفضائية المستمرة على مدار 24 ساعة عبر أقمار كوزباس-سارسات وإطلاق الاستجابة خلال 15 دقيقة من استلام إشارة الاستغاثة."
                )
            ]
        )
    ]
}
