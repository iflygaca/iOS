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
        )
    ]
}

