import SwiftUI

struct QuizService {
    static let gacarQuestions: [QuizQuestion] = [
        // MARK: - 1. Licensing & Certification (GACAR Part 61 & Part 65)
        QuizQuestion(
            category: .licensing,
            questionEn: "Under GACAR Part 61.103, what is the minimum total flight time required for a Private Pilot Certificate (PPL)?",
            questionAr: "وفقاً للائحة GACAR Part 61.103، ما هي ساعات الطيران الدنيا المطلوبة للحصول على رخصة طيار خاص (PPL)؟",
            optionsEn: ["30 hours", "40 hours", "50 hours", "60 hours"],
            optionsAr: ["30 ساعة", "40 ساعة", "50 ساعة", "60 ساعة"],
            correctOptionIndex: 1,
            gacarReference: "GACAR Part 61.103",
            explanationEn: "GACAR Part 61 requires a minimum of 40 total flight hours, which must include at least 20 hours of dual flight instruction and 10 hours of solo flight time.",
            explanationAr: "تتطلب لائحة GACAR Part 61 ما لا يقل عن 40 ساعة طيران إجمالية، تشمل 20 ساعة تدريب مزدوج مع مدرب و10 ساعات طيران منفرد."
        ),
        QuizQuestion(
            category: .licensing,
            questionEn: "To act as Pilot in Command (PIC) carrying passengers under GACAR 61.57, what recency of experience is required?",
            questionAr: "لكي تعمل كقائد طائرة (PIC) وتنقل ركاباً وفق GACAR 61.57، ما هي الخبرة الحديثة المطلوبة؟",
            optionsEn: [
                "3 takeoffs & landings within preceding 90 days in same category/class",
                "5 takeoffs & landings within preceding 60 days",
                "Flight review within preceding 6 months",
                "10 hours flight time within preceding 30 days"
            ],
            optionsAr: [
                "3 إقلاعات وهبوطات خلال الـ 90 يوماً الماضية على نفس الفئة والدرجة",
                "5 إقلاعات وهبوطات خلال الـ 60 يوماً الماضية",
                "مراجعة طيران خلال الـ 6 أشهر الماضية",
                "10 ساعات طيران خلال الـ 30 يوماً الماضية"
            ],
            correctOptionIndex: 0,
            gacarReference: "GACAR Part 61.57",
            explanationEn: "GACAR 61.57 mandates at least 3 takeoffs and 3 landings to a full stop or touch-and-go within the preceding 90 days in the same category, class, and type (if a type rating is required). For night passenger carriage, the 3 landings must be to a full stop at night.",
            explanationAr: "تشترط لائحة GACAR 61.57 إجراء 3 إقلاعات و3 هبوطات على الأقل خلال الـ 90 يوماً الماضية على نفس الفئة والنوع. وللطيران الليلي بالركاب يجب أن تكون الهبوطات الثلاثة كاملة (Full Stop) ليلاً."
        ),
        QuizQuestion(
            category: .licensing,
            questionEn: "Under GACAR Part 61.129, how many total flight hours are required for a Commercial Pilot Certificate (CPL)?",
            questionAr: "وفق GACAR Part 61.129، كم عدد ساعات الطيران الإجمالية المطلوبة لرخصة طيار تجاري (CPL)؟",
            optionsEn: ["150 hours", "200 hours", "250 hours", "500 hours"],
            optionsAr: ["150 ساعة", "200 ساعة", "250 ساعة", "500 ساعة"],
            correctOptionIndex: 1,
            gacarReference: "GACAR Part 61.129",
            explanationEn: "GACAR 61.129 specifies a minimum of 200 total aeronautical experience hours for an airplane rating, including 100 hours of PIC time and 50 hours cross-country time.",
            explanationAr: "تحدد GACAR 61.129 حداً أدنى 200 ساعة خبرة طيران لفئة الطائرات، تشمل 100 ساعة كقائد طائرة و50 ساعة طيران عبر البلاد."
        ),
        QuizQuestion(
            category: .licensing,
            questionEn: "Under GACAR Part 61.159, what is the minimum total flight time required for an Airline Transport Pilot (ATPL) airplane multi-engine certificate?",
            questionAr: "وفق GACAR Part 61.159، كم الحد الأدنى لساعات الطيران المطلوبة لرخصة طيار خط جوي (ATPL) لطائرة متعددة المحركات؟",
            optionsEn: ["1,000 hours", "1,200 hours", "1,500 hours", "2,000 hours"],
            optionsAr: ["1,000 ساعة", "1,200 ساعة", "1,500 ساعة", "2,000 ساعة"],
            correctOptionIndex: 2,
            gacarReference: "GACAR Part 61.159",
            explanationEn: "An applicant for an Airline Transport Pilot License (ATPL) must have at least 1,500 hours of total flight time, including 500 hours cross-country, 100 hours night flight, and 75 hours instrument time.",
            explanationAr: "يشترط للحصول على رخصة طيار خط جوي (ATPL) إتمام 1,500 ساعة طيران إجمالية على الأقل، تشمل 500 ساعة عبر البلاد، و100 ساعة طيران ليلي، و75 ساعة طيران آلي."
        ),
        QuizQuestion(
            category: .licensing,
            questionEn: "Under GACAR Part 65.53, what is the minimum age required for an Aircraft Dispatcher Certificate in Saudi Arabia?",
            questionAr: "وفق GACAR Part 65.53، ما هو الحد الأدنى للعمر المطلوب لإصدار رخصة مرحل جوي (Dispatcher) في المملكة؟",
            optionsEn: ["18 years", "21 years", "23 years", "25 years"],
            optionsAr: ["18 سنة", "21 سنة", "23 سنة", "25 سنة"],
            correctOptionIndex: 1,
            gacarReference: "GACAR Part 65.53",
            explanationEn: "To be eligible for an Aircraft Dispatcher Certificate under GACAR Part 65, an applicant must be at least 21 years of age and pass the aeronautical knowledge and practical exams.",
            explanationAr: "يشترط للحصول على رخصة مرحل جوي معتمد وفق لائحة GACAR Part 65 ألا يقل عمر المتقدم عن 21 عاماً واجتياز الامتحانات النظرية والعملية المقررة."
        ),

        // MARK: - 2. Flight Operations & Airspace Rules (GACAR Part 91)
        QuizQuestion(
            category: .operations,
            questionEn: "What is the minimum VFR fuel reserve required for a NIGHT flight under GACAR Part 91.151?",
            questionAr: "ما هو الحد الأدنى لاحتياطي وقود VFR المطلوب لرحلة ليلية وفق GACAR Part 91.151؟",
            optionsEn: ["20 minutes", "30 minutes", "45 minutes", "60 minutes"],
            optionsAr: ["20 دقيقة", "30 دقيقة", "45 دقيقة", "60 دقيقة"],
            correctOptionIndex: 2,
            gacarReference: "GACAR Part 91.151",
            explanationEn: "Night VFR operations in Saudi airspace require enough fuel to reach the destination plus at least 45 minutes of reserve at normal cruising speed (Day VFR requires 30 minutes).",
            explanationAr: "تتطلب رحلات VFR الليلية بالمجال الجوي السعودي وقوداً كافياً للوصول للوجهة + 45 دقيقة احتياطي على الأقل بسرعة العبور (بينما النهار 30 دقيقة)."
        ),
        QuizQuestion(
            category: .operations,
            questionEn: "Under GACAR 91.159, what cruising altitude rule applies to a VFR flight on a magnetic course of 090° (Easterly)?",
            questionAr: "وفق GACAR 91.159، ما هي قاعدة الارتفاع المطبقة لرحلة VFR اتجاهها المغناطيسي 090 درجة (شرقاً)؟",
            optionsEn: [
                "Odd thousand foot altitude + 500 feet (e.g. 5,500 ft, 7,500 ft)",
                "Even thousand foot altitude + 500 feet (e.g. 4,500 ft, 6,500 ft)",
                "Any odd thousand foot altitude (e.g. 5,000 ft)",
                "Any altitude requested by pilot"
            ],
            optionsAr: [
                "ارتفاع آلاف فردي + 500 قدم (مثل 5,500 قدم، 7,500 قدم)",
                "ارتفاع آلاف زوجي + 500 قدم (مثل 4,500 قدم، 6,500 قدم)",
                "أي ارتفاع آلاف فردي (مثل 5,000 قدم)",
                "أي ارتفاع يطلبه الطيار"
            ],
            correctOptionIndex: 0,
            gacarReference: "GACAR Part 91.159",
            explanationEn: "VFR cruising altitudes above 3,000 ft AGL follow the hemispheric rule: Easterly magnetic courses (000°-179°) fly Odd thousands + 500 ft MSL; Westerly magnetic courses (180°-359°) fly Even thousands + 500 ft MSL.",
            explanationAr: "ارتفاعات VFR فوق 3,000 قدم عن سطح الأرض: للاتجاهات المغناطيسية الشرقية (000-179) نطير آلافاً فردية + 500 قدم، وللاتجاهات الغربية (180-359) آلافاً زوجية + 500 قدم."
        ),
        QuizQuestion(
            category: .operations,
            questionEn: "Which acronym represents required equipment for Day VFR flight under GACAR Part 91.205?",
            questionAr: "ما هو الاختصار الممثل للمعدات المطلوبة لطيران VFR نهاراً وفق GACAR 91.205؟",
            optionsEn: ["TOMATOFLAMES", "ATOMATOFLAMES", "FLAPS", "GRABCARD"],
            optionsAr: ["TOMATOFLAMES", "ATOMATOFLAMES", "FLAPS", "GRABCARD"],
            correctOptionIndex: 1,
            gacarReference: "GACAR Part 91.205",
            explanationEn: "ATOMATOFLAMES covers: Airspeed indicator, Tachometer, Oil pressure, Manifold pressure, Altimeter, Temp gauge, Oil temp, Fuel gauge, Landing gear position indicator, Anti-collision lights, Magnetic compass, ELT, and Seatbelts.",
            explanationAr: "يشمل الاختصار: مؤشر السرعة، مقياس الدوران، ضغط الزيت، مؤشر الارتفاع، حرارة المحرك، مؤشر الوقود، البوصلة، حزام الأمان، وجهاز الاستغاثة ELT."
        ),
        QuizQuestion(
            category: .operations,
            questionEn: "Under GACAR 91.117, what is the maximum speed permitted below 10,000 feet MSL in Saudi airspace?",
            questionAr: "وفق لائحة GACAR 91.117، ما هي السرعة الجوية القصوى المسموح بها تحت 10,000 قدم فوق سطح البحر في المملكة؟",
            optionsEn: ["200 knots IAS", "250 knots IAS", "280 knots IAS", "Mach 0.82"],
            optionsAr: ["200 عقدة IAS", "250 عقدة IAS", "280 عقدة IAS", "ماخ 0.82"],
            correctOptionIndex: 1,
            gacarReference: "GACAR Part 91.117",
            explanationEn: "Under GACAR 91.117, no aircraft may operate below 10,000 feet MSL at an indicated airspeed of more than 250 knots (unless authorized by ATC or flight manual minimum safe speed). Within 4 NM of Class C/D airspace at or below 2,500 ft AGL, the speed limit is 200 knots.",
            explanationAr: "تحت 10,000 قدم، السرعة الجوية المبينة القصوى هي 250 عقدة. وضمن مسافة 4 أميال بحرية من مطارات الفئة C أو D وعلى ارتفاع 2,500 قدم أو أقل، فالحد الأقصى هو 200 عقدة."
        ),
        QuizQuestion(
            category: .operations,
            questionEn: "What is the minimum safe altitude over a congested city or settlement under GACAR Part 91.119?",
            questionAr: "ما هو الحد الأدنى للارتفاع الآمن للطيران فوق المدن والمناطق المأهولة وفق GACAR Part 91.119؟",
            optionsEn: [
                "500 ft above highest obstacle",
                "1,000 ft above highest obstacle within a 600-meter (2,000 ft) radius",
                "1,500 ft above the ground",
                "2,000 ft above sea level"
            ],
            optionsAr: [
                "500 قدم فوق أعلى عائق",
                "1,000 قدم فوق أعلى عائق ضمن دائرة نصف قطرها 600 متر (2,000 قدم)",
                "1,500 قدم فوق سطح الأرض",
                "2,000 قدم فوق مستوى سطح البحر"
            ],
            correctOptionIndex: 1,
            gacarReference: "GACAR Part 91.119",
            explanationEn: "GACAR 91.119 specifies that over any congested area of a city, town, or settlement, an aircraft must maintain at least 1,000 feet above the highest obstacle within a horizontal radius of 600 meters (2,000 feet).",
            explanationAr: "تشترط لائحة GACAR 91.119 الطيران على ارتفاع لا يقل عن 1,000 قدم فوق أعلى عائق ضمن مسافة أفقية 600 متر في المناطق السكنية والمأهولة."
        ),
        QuizQuestion(
            category: .operations,
            questionEn: "Under GACAR 91.211, when is supplemental oxygen mandatory for flight crew members in unpressurized aircraft?",
            questionAr: "وفق GACAR 91.211، متى يصبح الأكسجين الإضافي إلزامياً لطاقم الطيران في الطائرات غير المضغوطة؟",
            optionsEn: [
                "At all altitudes above 8,000 ft",
                "Above 12,500 ft MSL for flights exceeding 30 minutes, and continuously above 14,000 ft MSL",
                "Only above 18,000 ft MSL",
                "Continuously above 10,000 ft MSL"
            ],
            optionsAr: [
                "عند جميع الارتفاعات فوق 8,000 قدم",
                "فوق 12,500 قدم عند البقاء لأكثر من 30 دقيقة، وبشكل مستمر فوق 14,000 قدم",
                "فقط فوق 18,000 قدم",
                "بشكل مستمر فوق 10,000 قدم"
            ],
            correctOptionIndex: 1,
            gacarReference: "GACAR Part 91.211",
            explanationEn: "Flight crew must use supplemental oxygen for the part of flight that exceeds 30 minutes between 12,500 ft MSL and 14,000 ft MSL, and continuously at all cabin pressure altitudes above 14,000 ft MSL. Above 15,000 ft MSL, oxygen must also be provided to passengers.",
            explanationAr: "يجب على طاقم القيادة استخدام الأكسجين للفترات التي تزيد عن 30 دقيقة بين 12,500 و14,000 قدم، وبشكل دائم ومستمر فوق 14,000 قدم. وفوق 15,000 قدم يلزم تزويد الركاب أيضاً."
        ),
        QuizQuestion(
            category: .operations,
            questionEn: "Under GACAR 91.167, what is the fuel requirement for an IFR flight in Saudi Arabia?",
            questionAr: "وفق GACAR 91.167، ما هو احتياطي الوقود الإلزامي لرحلة طيران آلي (IFR) في المملكة؟",
            optionsEn: [
                "Fuel to destination + 30 minutes reserve",
                "Fuel to destination + alternate airport + 45 minutes reserve at normal cruise",
                "Fuel to destination + 60 minutes holding",
                "Fuel for 2 hours flight only"
            ],
            optionsAr: [
                "وقود للوجهة + 30 دقيقة احتياطي",
                "وقود للوجهة + المطار البديل + 45 دقيقة احتياطي بسرعة العبور العادية",
                "وقود للوجهة + 60 دقيقة انتظار",
                "وقود لساعتي طيران فقط"
            ],
            correctOptionIndex: 1,
            gacarReference: "GACAR Part 91.167",
            explanationEn: "Under GACAR 91.167, an IFR aircraft must carry enough fuel to fly to the intended destination airport, then fly to the alternate airport (if required), and thereafter continue for 45 minutes at normal cruising speed.",
            explanationAr: "توجب GACAR 91.167 حمل وقود كافٍ للوصول إلى مطار الوجهة الأولى، ثم الطيران إلى المطار البديل المحدد، ومواصلة الطيران لمدة 45 دقيقة إضافية بسرعة العبور."
        ),

        // MARK: - 3. Aviation Medical Certification (GACAR Part 67)
        QuizQuestion(
            category: .medical,
            questionEn: "How long is a Class 1 Medical Certificate valid for a commercial airline pilot under 40 years of age?",
            questionAr: "ما هي مدة صلاحية الشهادة الطبية الفئة الأولى لطيار خطوط جوية يقل عمره عن 40 عاماً؟",
            optionsEn: ["6 calendar months", "12 calendar months", "24 calendar months", "60 calendar months"],
            optionsAr: ["6 أشهر تقويمية", "12 شهراً تقويمياً", "24 شهراً تقويمياً", "60 شهراً تقويمياً"],
            correctOptionIndex: 1,
            gacarReference: "GACAR Part 67.13",
            explanationEn: "Under GACAR Part 67, Class 1 medicals are valid for 12 calendar months for pilots under age 40, and 6 calendar months for pilots age 40 and older who operate in single-pilot commercial transport or age 60+ in airline operations.",
            explanationAr: "وفق GACAR Part 67، الفئة الأولى صالحة لمدة 12 شهراً للطيارين دون 40 عاماً، وتتقلص إلى 6 أشهر للطيارين البالغين 40 عاماً فأكثر في خطوط النقل الجوي التجاري."
        ),
        QuizQuestion(
            category: .medical,
            questionEn: "What is the validity period of a Class 2 Medical Certificate for a Private Pilot under age 40?",
            questionAr: "ما هي مدة صلاحية الشهادة الطبية الفئة الثانية لطيار خاص دون سن 40؟",
            optionsEn: ["12 calendar months", "24 calendar months", "36 calendar months", "60 calendar months (5 years)"],
            optionsAr: ["12 شهراً تقويمياً", "24 شهراً تقويمياً", "36 شهراً تقويمياً", "60 شهراً تقويمياً (5 سنوات)"],
            correctOptionIndex: 3,
            gacarReference: "GACAR Part 67.23",
            explanationEn: "Class 2 medical certificates remain valid for 60 calendar months (5 years) for pilots under 40, and 24 calendar months for pilots 40 or older.",
            explanationAr: "تبقى الشهادة الطبية الفئة الثانية صالحة لمدة 60 شهراً (5 سنوات) للطيارين دون 40 عاماً، و24 شهراً للطيارين بعمر 40 أو أكثر."
        ),
        QuizQuestion(
            category: .medical,
            questionEn: "Which class of medical certificate is required for Air Traffic Controllers under GACAR Part 67?",
            questionAr: "ما هي فئة الشهادة الطبية المطلوبة لمراقبي الحركة الجوية (ATC) وفق GACAR Part 67؟",
            optionsEn: ["Class 1 Medical", "Class 2 Medical", "Class 3 Medical", "No medical required"],
            optionsAr: ["فئة أولى (Class 1)", "فئة ثانية (Class 2)", "فئة ثالثة (Class 3)", "لا يشترط شهادة طبية"],
            correctOptionIndex: 2,
            gacarReference: "GACAR Part 67.33",
            explanationEn: "Air traffic control tower operators and radar controllers require a Class 3 Medical Certificate under GACAR Part 67.33, valid for 24 months (or 12 months for controllers 40 and older).",
            explanationAr: "يشترط لمراقبي الحركة الجوية الحصول على شهادة طبية من الفئة الثالثة (Class 3) بموجب GACAR 67.33، وتكون صالحة لمدة سنتين (أو سنة واحدة لمن أتم 40 عاماً)."
        ),

        // MARK: - 4. Drones / UAS (GACAR Part 107)
        QuizQuestion(
            category: .uas,
            questionEn: "Under GACAR Part 107.51, what is the maximum permissible altitude for small drones above ground level (AGL)?",
            questionAr: "وفق GACAR Part 107.51، ما هو الارتفاع الأقصى المسموح به للدرونز الصغير فوق سطح الأرض (AGL)؟",
            optionsEn: ["200 feet AGL", "300 feet AGL", "400 feet AGL", "500 feet AGL"],
            optionsAr: ["200 قدم AGL", "300 قدم AGL", "400 قدم AGL", "500 قدم AGL"],
            correctOptionIndex: 2,
            gacarReference: "GACAR Part 107.51",
            explanationEn: "GACAR Part 107 limits drone flight ceiling to 400 feet AGL unless flown within a 400-foot radius of a structure and not flown higher than 400 feet above the structure's immediate uppermost limit.",
            explanationAr: "تحدد لائحة GACAR Part 107 الحد الأقصى لارتفاع تشغيل الدرونز بـ 400 قدم فوق سطح الأرض ما لم تكن ملاصقة لمبنى وتطير ضمن نطاق 400 قدم من سطحه."
        ),
        QuizQuestion(
            category: .uas,
            questionEn: "What is the maximum allowed groundspeed for a remote pilot operating under GACAR Part 107?",
            questionAr: "ما هي السرعة الأرضية القصوى المسموح بها لطيار الدرونز عن بعد وفق GACAR Part 107؟",
            optionsEn: ["50 knots (57 mph)", "70 knots (80 mph)", "87 knots (100 mph)", "100 knots (115 mph)"],
            optionsAr: ["50 عقدة", "70 عقدة", "87 عقدة (100 ميل/ساعة)", "100 عقدة"],
            correctOptionIndex: 2,
            gacarReference: "GACAR Part 107.51",
            explanationEn: "The maximum groundspeed permitted under GACAR Part 107 is 87 knots (100 miles per hour).",
            explanationAr: "السرعة الأرضية القصوى المسموح بها بموجب GACAR Part 107 هي 87 عقدة (100 ميل في الساعة)."
        ),
        QuizQuestion(
            category: .uas,
            questionEn: "Under GACAR Part 107.29, what equipment is mandatory for drone operations during civil twilight and night?",
            questionAr: "وفق GACAR 107.29، ما التجهيز الإلزامي لطيران الدرونز أثناء الشفق والليل؟",
            optionsEn: [
                "Forward landing headlight",
                "Anti-collision lighting visible for at least 3 statute miles with a flash rate",
                "Audible siren alarm",
                "Dual remote transmitters"
            ],
            optionsAr: [
                "كشاف هبوط أمامي",
                "إضاءة مضادة للتصادم مرئية لمسافة لا تقل عن 3 أميال بمعدل وميض كافٍ",
                "صفارة إنذار مسموعة",
                "جهازا إرسال لاسلكي مزدوجان"
            ],
            correctOptionIndex: 1,
            gacarReference: "GACAR Part 107.29",
            explanationEn: "Night drone operations require anti-collision lighting that has a flash rate sufficient to avoid collisions and is visible for at least 3 statute miles.",
            explanationAr: "تشترط لائحة الدرونز الليلية تركيب أضواء مضادة للتصادم ذات وميض مميز مرئية لمدى لا يقل عن 3 أميال أرضية."
        ),

        // MARK: - 5. Commercial Air Transport (GACAR Part 121 & Part 135)
        QuizQuestion(
            category: .operations,
            questionEn: "Under GACAR Part 121.619 (the '1-2-3 Rule'), when is an alternate airport NOT required for an IFR flight dispatch?",
            questionAr: "وفق GACAR 121.619 (قاعدة 1-2-3)، متى لا يلزم تحديد مطار بديل لترحيل رحلة IFR تجارية؟",
            optionsEn: [
                "Always required for all commercial IFR flights",
                "If for 1 hour before to 1 hour after ETA, ceiling is at least 2,000 ft and visibility is at least 3 statute miles",
                "If weather is clear at departure airport",
                "If flight duration is under 45 minutes"
            ],
            optionsAr: [
                "المطار البديل إلزامي دائماً لجميع الرحلات التجارية",
                "إذا كان السقف الجوي قبل موعد الوصول بساعة وبعده بساعة لا يقل عن 2,000 قدم والرؤية 3 أميال على الأقل",
                "إذا كان الطقس صافياً بمطار المغادرة",
                "إذا كانت مدة الرحلة أقل من 45 دقيقة"
            ],
            correctOptionIndex: 1,
            gacarReference: "GACAR Part 121.619",
            explanationEn: "The standard 1-2-3 Rule dictates: From 1 hour before to 1 hour after estimated arrival time, if the destination ceiling is at least 2,000 ft above airport elevation and visibility is at least 3 statute miles (approx. 5,000m), an alternate airport is not required.",
            explanationAr: "قاعدة (1-2-3): قبل ساعة من الوصول المتوقع وحتى ساعة بعده، إذا كان السحاب على ارتفاع 2,000 قدم على الأقل والرؤية لا تقل عن 3 أميال بحرية، لا يُشترط إدراج مطار بديل في الترحيل الجوي."
        ),
        QuizQuestion(
            category: .operations,
            questionEn: "Under GACAR Part 121.391, what is the minimum required ratio of flight attendants to passenger seats on commercial airliners?",
            questionAr: "وفق GACAR 121.391، ما هو الحد الأدنى الإلزامي لنسبة طاقم الضيافة (المضيفين) لعدد مقاعد الركاب؟",
            optionsEn: [
                "1 flight attendant per 30 passenger seats",
                "1 flight attendant for 20-50 seats, and 1 additional for each 50 passenger seats (or fraction thereof)",
                "1 flight attendant per 100 passengers on board",
                "2 flight attendants minimum on all jet aircraft"
            ],
            optionsAr: [
                "مضيف واحد لكل 30 مقعد ركاب",
                "مضيف واحد للطائرات من 20 إلى 50 مقعداً، ومضيف إضافي لكل 50 مقعداً إضافياً أو جزء منها",
                "مضيف واحد لكل 100 راكب على متن الطائرة",
                "مضيفان على الأقل لجميع الطائرات النفاثة"
            ],
            correctOptionIndex: 1,
            gacarReference: "GACAR Part 121.391",
            explanationEn: "For aircraft having a seating capacity of more than 20 but less than 51 passengers, 1 flight attendant is required. For more than 50 passengers, 2 flight attendants plus 1 additional flight attendant for each unit (or part of a unit) of 50 passenger seats above 100.",
            explanationAr: "يلزم مضيف واحد للطائرات سعة 20-50 مقعداً، ومضيفان لسعة 51-100 مقعد، ثم مضيف إضافي لكل 50 مقعداً أو جزء منها فوق الـ 100 مقعد."
        ),

        // MARK: - 6. Airworthiness & Maintenance (GACAR Part 43 & Part 66)
        QuizQuestion(
            category: .maintenance,
            questionEn: "Under GACAR Part 91.409, when is a 100-hour inspection required in addition to an annual inspection?",
            questionAr: "وفق GACAR 91.409، متى يكون فحص الـ 100 ساعة إلزامياً بالإضافة إلى الفحص السنوي؟",
            optionsEn: [
                "For all privately owned aircraft",
                "When the aircraft carries passengers for hire or is used for flight instruction for hire",
                "Only when requested by the insurance underwriter",
                "After every severe turbulence encounter"
            ],
            optionsAr: [
                "لجميع الطائرات الخاصة دون استثناء",
                "عند تشغيل الطائرة لنقل ركاب بأجر أو استخدامها لتدريب الطيران بمقابل مادي",
                "فقط بناءً على طلب شركة التأمين",
                "بعد كل مطب هوائي شديد"
            ],
            correctOptionIndex: 1,
            gacarReference: "GACAR Part 91.409",
            explanationEn: "A 100-hour inspection is required for aircraft operated for hire carrying any person other than a crewmember, or used for flight instruction for hire provided by a flight school.",
            explanationAr: "يلزم فحص الـ 100 ساعة عند تشغيل الطائرة لنقل أشخاص بأجر تجاري، أو في مدارس ومعاهد الطيران المستخدمة للتدريب العملي بمقابل."
        ),
        QuizQuestion(
            category: .maintenance,
            questionEn: "Under GACAR Part 66, what aircraft maintenance engineering license category covers electrical, instrument, and radio systems?",
            questionAr: "وفق لائحة GACAR Part 66، أي فئة من رخص صيانة الطائرات تختص بالأنظمة الكهربائية والآلات وإلكترونيات الطيران؟",
            optionsEn: ["Category A", "Category B1 (Mechanical)", "Category B2 (Avionics)", "Category C (Base Maintenance)"],
            optionsAr: ["الفئة A (صيانة الخط)", "الفئة B1 (ميكانيكا وهياكل)", "الفئة B2 (إلكترونيات الطيران Avionics)", "الفئة C (صيانة الحظيرة الكبرى)"],
            correctOptionIndex: 2,
            gacarReference: "GACAR Part 66.3",
            explanationEn: "Category B2 AMEL entitles the holder to issue certificates of release to service following maintenance on avionic and electrical systems, radar, autoflight, and instrument systems.",
            explanationAr: "تمنح رخصة المهندس فئة B2 صلاحية اعتماد وصيانة منظومات إلكترونيات الطيران (Avionics)، والأنظمة الكهربائية، واللاسلكي، والرادارات، والطيار الآلي."
        ),
        QuizQuestion(
            category: .maintenance,
            questionEn: "Under GACAR 91.207, emergency locator transmitter (ELT) batteries must be replaced or recharged when:",
            questionAr: "وفق GACAR 91.207، يجب استبدال أو إعادة شحن بطاريات جهاز الإرسال للطوارئ (ELT) عند:",
            optionsEn: [
                "Every 6 months regardless of use",
                "When the transmitter has been in use for more than 1 cumulative hour or 50% of its useful life has expired",
                "Only during the annual airworthiness certificate renewal",
                "Whenever the aircraft flies abroad"
            ],
            optionsAr: [
                "كل 6 أشهر بصرف النظر عن الاستخدام",
                "عند تشغيل الجهاز لأكثر من ساعة تراكمية واحدة أو انتهاء 50% من العمر التشغيلي للبطارية",
                "فقط عند تجديد شهادة الصلاحية السنوية",
                "عند الطيران خارج المملكة فقط"
            ],
            correctOptionIndex: 1,
            gacarReference: "GACAR Part 91.207",
            explanationEn: "ELT batteries must be replaced or recharged when the transmitter has been in use for more than 1 cumulative hour, or when 50 percent of their useful life has expired as established by the manufacturer.",
            explanationAr: "يجب تغيير بطاريات جهاز الـ ELT إذا جرى تشغيله لأكثر من ساعة تراكمية، أو إذا استنفد 50% من عمره الافتراضي المدون على ملصق البطارية."
        ),

        // MARK: - 7. Airports, Navaids & Saudi Airspace (Part 139 & AIP)
        QuizQuestion(
            category: .airports,
            questionEn: "In Saudi Arabia, what color are airport beacon lights for a civil land airport?",
            questionAr: "في السعودية، ما هي ألوان منارة المطار الضوئية (Airport Beacon) للمطارات المدنية الأرضية؟",
            optionsEn: [
                "Flashing White and Green",
                "Flashing White and Yellow",
                "Flashing Red and Green",
                "Steady Green"
            ],
            optionsAr: [
                "أبيض وأخضر متناوب",
                "أبيض وأصفر متناوب",
                "أحمر وأخضر متناوب",
                "أخضر ثابت"
            ],
            correctOptionIndex: 0,
            gacarReference: "Saudi AIP / GACAR 139",
            explanationEn: "Civil land airports in Saudi Arabia use a rotating airport beacon flashing alternating White and Green flashes.",
            explanationAr: "تستخدم المطارات المدنية الأرضية بالسعودية منارة ضوئية دوارة تومض باللونين الأبيض والأخضر متناوباً."
        ),
        QuizQuestion(
            category: .airports,
            questionEn: "What class of airspace covers upper Saudi airspace from FL150 to FL600 where all traffic is IFR?",
            questionAr: "ما هو تصنيف المجال الجوي الذي يغطي الأجواء السعودية العليا من FL150 حتى FL600 وتخضع فيه الرحلات لقواعد IFR فقط؟",
            optionsEn: ["Class A Airspace", "Class B Airspace", "Class C Airspace", "Class G Airspace"],
            optionsAr: ["المجال الجوي فئة A", "المجال الجوي فئة B", "المجال الجوي فئة C", "المجال الجوي فئة G"],
            correctOptionIndex: 0,
            gacarReference: "GACAR Part 71 / Saudi AIP",
            explanationEn: "In the Jeddah (OEJD) Flight Information Region (FIR), Class A airspace is established from FL150 to FL600. All operations must be conducted under Instrument Flight Rules (IFR) and subject to ATC separation.",
            explanationAr: "في إقليم معلومات الطيران السعودي (Jeddah FIR)، يُصنف المجال الجوي من مستوى الطيران FL150 حتى FL600 كفئة A، وتكون جميع الرحلات خاضعة لقواعد الطيران الآلي (IFR) وتوجيهات المراقبة الجوية."
        ),
        QuizQuestion(
            category: .airports,
            questionEn: "Under GACAR Part 139.315, what does the Aircraft Rescue and Firefighting (ARFF) Index determine?",
            questionAr: "وفق GACAR Part 139.315، ماذا يحدد مؤشر الإطفاء والإنقاذ بالمطار (ARFF Index)؟",
            optionsEn: [
                "The maximum length and fuselage width of aircraft that can be safely accommodated with fire protection",
                "The total number of runways at the airport",
                "The fuel storage tank capacity",
                "The perimeter fence security level"
            ],
            optionsAr: [
                "الحد الأقصى لطول الطائرة وعرض هيكلها المسموح به بناءً على كميات وسائط الإطفاء وعربات الإنقاذ المتاحة",
                "إجمالي عدد المدارج في المطار",
                "سعة خزانات وقود الطائرات بالمطار",
                "مستوى الحماية الأمنية لسور المطار"
            ],
            correctOptionIndex: 0,
            gacarReference: "GACAR Part 139.315",
            explanationEn: "The ARFF index (Categories 1 through 10) is determined by the overall length and fuselage width of the aircraft using the airport, which sets mandatory minimum extinguishing agents, foam, and rapid intervention vehicles.",
            explanationAr: "يحدد مؤشر الإطفاء والإنقاذ (من الفئة 1 إلى 10) مستوى جاهزية المطار من مركبات الإطفاء وكميات رغوة ومياه الإخماد وفقاً لأطوال الطائرات وأحجامها المجدولة."
        )
    ]
}
