import SwiftUI

struct QuizService {
    static let gacarQuestions: [QuizQuestion] = [
        // MARK: - 1. Licensing & Certification (GACAR Part 61)
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
            explanationEn: "GACAR 61.57 mandates at least 3 takeoffs and 3 landings to a full stop or touch-and-go within the preceding 90 days in the same category, class, and type (if a type rating is required).",
            explanationAr: "تشترط لائحة GACAR 61.57 إجراء 3 إقلاعات و3 هبوطات على الأقل خلال الـ 90 يوماً الماضية على نفس الفئة والنوع."
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

        // MARK: - 2. Flight Operations (GACAR Part 91)
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
            explanationEn: "VFR cruising altitudes above 3,000 ft AGL follow the rule: Easterly courses (000°-179°) fly Odd thousands + 500 ft MSL; Westerly courses (180°-359°) fly Even thousands + 500 ft MSL.",
            explanationAr: "ارتفاعات VFR فوق 3,000 قدم: للاتجاهات الشرقية (000-179) نطير آلاف فردية + 500 قدم، وللاتجاهات الغربية (180-359) آلاف زوجية + 500 قدم."
        ),
        QuizQuestion(
            category: .operations,
            questionEn: "Which acronym represents required equipment for Day VFR under GACAR Part 91.205?",
            questionAr: "ما هو الاختصار الممثل للمعدات المطلوبة لطيران VFR نهاراً وفق GACAR 91.205؟",
            optionsEn: ["TOMATOFLAMES", "ATOMATOFLAMES", "FLAPS", "GRABCARD"],
            optionsAr: ["TOMATOFLAMES", "ATOMATOFLAMES", "FLAPS", "GRABCARD"],
            correctOptionIndex: 1,
            gacarReference: "GACAR Part 91.205",
            explanationEn: "ATOMATOFLAMES covers: Airspeed indicator, Tachometer, Oil pressure, Manifold pressure, Altimeter, Temp gauge, Oil temp, Fuel gauge, Landing gear pos, Anti-collision lights, Magnetic compass, ELT, Seatbelts.",
            explanationAr: "يشمل الاختصار: مؤشر السرعة، مقياس الدوران، ضغط الزيت، مؤشر الارتفاع، حرارة المحرك، مؤشر الوقود، البوصلة، حزام الأمان وجهاز ELT."
        ),

        // MARK: - 3. Medical Standards (GACAR Part 67)
        QuizQuestion(
            category: .medical,
            questionEn: "How long is a Class 1 Medical Certificate valid for a commercial pilot under 40 years of age?",
            questionAr: "ما هي مدة صلاحية الشهادة الطبية الفئة الأولى لطيار تجاري يقل عمره عن 40 عاماً؟",
            optionsEn: ["6 calendar months", "12 calendar months", "24 calendar months", "60 calendar months"],
            optionsAr: ["6 أشهر تقويمية", "12 شهراً تقويمياً", "24 شهراً تقويمياً", "60 شهراً تقويمياً"],
            correctOptionIndex: 1,
            gacarReference: "GACAR Part 67.13",
            explanationEn: "Under GACAR Part 67, Class 1 medicals are valid for 12 calendar months for pilots under age 40, and 6 calendar months for pilots age 40 and older.",
            explanationAr: "وفق GACAR Part 67، الفئة الأولى صالحة لمدة 12 شهراً للطيارين دون 40 عاماً، و6 أشهر للطيارين البالغين 40 عاماً فأكثر."
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

        // MARK: - 4. Drones / UAS (GACAR Part 107)
        QuizQuestion(
            category: .uas,
            questionEn: "Under GACAR Part 107.51, what is the maximum permissible altitude for small drones above ground level (AGL)?",
            questionAr: "وفق GACAR Part 107.51، ما هو الارتفاع الأقصى المسموح به للدرونز الصغير فوق سطح الأرض (AGL)؟",
            optionsEn: ["200 feet AGL", "300 feet AGL", "400 feet AGL", "500 feet AGL"],
            optionsAr: ["200 قدم AGL", "300 قدم AGL", "400 قدم AGL", "500 قدم AGL"],
            correctOptionIndex: 2,
            gacarReference: "GACAR Part 107.51",
            explanationEn: "GACAR Part 107 limits drone flight ceiling to 400 feet AGL unless flown within a 400-foot radius of a structure.",
            explanationAr: "تحدد لائحة GACAR Part 107 الحد الأقصى لارتفاع تشغيل الدرونز بـ 400 قدم فوق سطح الأرض."
        ),
        QuizQuestion(
            category: .uas,
            questionEn: "What is the maximum allowed groundspeed for a remote pilot operating under GACAR Part 107?",
            questionAr: "ما هي السرعة الأرضية القصوى المسموح بها لطيار الدرونز عن بعد وفق GACAR Part 107؟",
            optionsEn: ["50 knots (57 mph)", "70 knots (80 mph)", "87 knots (100 mph)", "100 knots (115 mph)"],
            optionsAr: ["50 عقدة", "70 عقدة", "87 عقدة (100 ميل/ساعة)", "100 عقدة"],
            correctOptionIndex: 2,
            gacarReference: "GACAR Part 107.51",
            explanationEn: "The maximum groundspeed permitted under GACAR Part 107 is 87 knots (100 mph).",
            explanationAr: "السرعة الأرضية القصوى المسموح بها بموجب GACAR Part 107 هي 87 عقدة (100 ميل في الساعة)."
        ),

        // MARK: - 5. Airports & Airspace (Saudi AIP & Part 139)
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
        )
    ]
}
