import SwiftUI

struct AviationToolsView: View {
    @Binding var currentLanguage: AppLanguage
    @State private var selectedToolTab: Int = 1 // 0: METAR Weather, 1: Exam Quiz & Flashcards, 2: Fuel & Crosswind
    
    // METAR weather state
    @State private var selectedAirport: METARReport = METARService.saudiAirports[0]
    
    // Quiz & Flashcard state
    @State private var studyMode: StudyMode = .quiz // .quiz or .flashcard
    @State private var selectedQuizCategory: GACARCategory? = nil
    @State private var currentQuestionIndex: Int = 0
    @State private var selectedAnswerIndex: Int? = nil
    @State private var showAnswerFeedback: Bool = false
    @State private var userScore: Int = 0
    @State private var quizCompleted: Bool = false
    
    // Flashcard 3D flip state
    @State private var isCardFlipped: Bool = false
    
    // Calculator state
    @State private var cruiseFuelBurnGPH: String = "10.0"
    @State private var flightTimeHours: String = "2.5"
    @State private var isNightFlight: Bool = false
    
    @State private var windSpeed: String = "15"
    @State private var windDirection: String = "310"
    @State private var runwayHeading: String = "340"

    enum StudyMode: String, CaseIterable, Identifiable {
        case quiz = "Exam Quiz"
        case flashcard = "Flashcards"
        var id: String { rawValue }
        
        var arabicName: String {
            switch self {
            case .quiz: return "اختبار تجريبي"
            case .flashcard: return "بطاقات استذكار"
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Segmented Control Header
                Picker("", selection: $selectedToolTab) {
                    Text(currentLanguage == .arabic ? "طقس METAR" : "METAR Weather").tag(0)
                    Text(currentLanguage == .arabic ? "الاختبار والبطاقات" : "Quiz & Flashcards").tag(1)
                    Text(currentLanguage == .arabic ? "الحاسبات" : "Calculators").tag(2)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)

                ScrollView {
                    VStack(spacing: 20) {
                        if selectedToolTab == 0 {
                            metarWeatherSection
                        } else if selectedToolTab == 1 {
                            quizAndFlashcardsSection
                        } else {
                            calculatorsSection
                        }
                    }
                    .padding(16)
                }
            }
            .navigationTitle(currentLanguage == .arabic ? "أدوات الطيران والاختبارات" : "Aviation Tools & Prep")
        }
        .environment(\.layoutDirection, currentLanguage.isRTL ? .rightToLeft : .leftToRight)
    }

    // MARK: - 1. METAR Weather Section
    private var metarWeatherSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(currentLanguage == .arabic ? "اختر المطار لمشاهدة التقرير الجوي (METAR)" : "Select Saudi Airport METAR")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(METARService.saudiAirports) { airport in
                        Button(action: {
                            withAnimation {
                                selectedAirport = airport
                            }
                        }) {
                            VStack(spacing: 4) {
                                Text(airport.icaoCode)
                                    .font(.system(size: 15, weight: .bold, design: .monospaced))
                                Text(airport.flightCategory.rawValue)
                                    .font(.caption2.weight(.black))
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(airport.flightCategory.color)
                                    .foregroundColor(.white)
                                    .cornerRadius(4)
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(selectedAirport.icaoCode == airport.icaoCode ? Color.blue.opacity(0.15) : Color.primary.opacity(0.04))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(selectedAirport.icaoCode == airport.icaoCode ? Color.blue : Color.clear, lineWidth: 2)
                                    )
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            
            // Raw METAR Card
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "cloud.sun.fill")
                        .foregroundColor(.orange)
                    Text(currentLanguage == .arabic ? selectedAirport.airportNameAr : selectedAirport.airportNameEn)
                        .font(.system(size: 16, weight: .bold))
                    Spacer()
                    Text(selectedAirport.flightCategory.rawValue)
                        .font(.system(size: 12, weight: .black))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(selectedAirport.flightCategory.color)
                        .foregroundColor(.white)
                        .cornerRadius(6)
                }
                
                Text(selectedAirport.rawText)
                    .font(.system(size: 13, weight: .semibold, design: .monospaced))
                    .foregroundColor(.green)
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.black.opacity(0.85))
                    .cornerRadius(8)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.primary.opacity(0.03))
            )
            
            // Decoded Grid
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                weatherDecodedCard(
                    icon: "wind",
                    title: currentLanguage == .arabic ? "الرياح" : "Wind",
                    value: selectedAirport.windInfo
                )
                weatherDecodedCard(
                    icon: "eye.fill",
                    title: currentLanguage == .arabic ? "الرؤية" : "Visibility",
                    value: selectedAirport.visibility
                )
                weatherDecodedCard(
                    icon: "thermometer.medium",
                    title: currentLanguage == .arabic ? "الحرارة / الندى" : "Temp / Dewpt",
                    value: "\(selectedAirport.temperature) / \(selectedAirport.dewPoint)"
                )
                weatherDecodedCard(
                    icon: "gauge",
                    title: currentLanguage == .arabic ? "الضغط الجوي" : "Altimeter",
                    value: selectedAirport.altimeter
                )
            }
        }
    }
    
    private func weatherDecodedCard(icon: String, title: String, value: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.system(size: 13, weight: .bold))
            }
            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.primary.opacity(0.04))
        )
    }

    // MARK: - 2. Quiz & Flashcards Master Section
    private var quizAndFlashcardsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Mode Picker: Quiz vs. Flashcards
            Picker("Study Mode", selection: $studyMode) {
                ForEach(StudyMode.allCases) { mode in
                    Text(currentLanguage == .arabic ? mode.arabicName : mode.rawValue).tag(mode)
                }
            }
            .pickerStyle(.segmented)
            
            // Category Filter Chips
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    Button(action: {
                        selectedQuizCategory = nil
                        resetQuiz()
                    }) {
                        Text(currentLanguage == .arabic ? "كافة المواد" : "All Topics")
                            .font(.caption.weight(.bold))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Capsule().fill(selectedQuizCategory == nil ? Color.blue : Color.primary.opacity(0.06)))
                            .foregroundColor(selectedQuizCategory == nil ? .white : .primary)
                    }
                    
                    ForEach(GACARCategory.allCases) { cat in
                        Button(action: {
                            selectedQuizCategory = cat
                            resetQuiz()
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: cat.iconName)
                                    .font(.caption2)
                                Text(currentLanguage == .arabic ? cat.arabicName : cat.rawValue)
                            }
                            .font(.caption.weight(.bold))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Capsule().fill(selectedQuizCategory == cat ? Color.blue : Color.primary.opacity(0.06)))
                            .foregroundColor(selectedQuizCategory == cat ? .white : .primary)
                        }
                    }
                }
            }
            
            let questions = activeQuestions
            
            if questions.isEmpty {
                Text(currentLanguage == .arabic ? "لا توجد أسئلة لهذه الفئة حالياً." : "No questions available for this category.")
                    .foregroundColor(.secondary)
                    .padding()
            } else if quizCompleted {
                // Quiz Results Summary Card
                quizResultsSummaryView(totalQuestions: questions.count)
            } else if studyMode == .quiz {
                // Exam Quiz Mode
                renderQuizQuestionView(questions: questions)
            } else {
                // Interactive 3D Flashcard Mode
                renderFlashcardView(questions: questions)
            }
        }
    }
    
    private var activeQuestions: [QuizQuestion] {
        if let category = selectedQuizCategory {
            return QuizService.gacarQuestions.filter { $0.category == category }
        }
        return QuizService.gacarQuestions
    }
    
    private func resetQuiz() {
        currentQuestionIndex = 0
        selectedAnswerIndex = nil
        showAnswerFeedback = false
        userScore = 0
        quizCompleted = false
        isCardFlipped = false
    }

    // MARK: - Quiz Question View
    private func renderQuizQuestionView(questions: [QuizQuestion]) -> some View {
        let question = questions[min(currentQuestionIndex, questions.count - 1)]
        
        return VStack(alignment: .leading, spacing: 16) {
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: question.category.iconName)
                    Text(currentLanguage == .arabic ? question.category.arabicName : question.category.rawValue)
                }
                .font(.caption.weight(.bold))
                .foregroundColor(.blue)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Capsule().fill(Color.blue.opacity(0.12)))
                
                Spacer()
                
                Text("\(currentLanguage == .arabic ? "سؤال" : "Q") \(currentQuestionIndex + 1)/\(questions.count)")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundColor(.secondary)
            }
            
            // Question Card
            VStack(alignment: .leading, spacing: 10) {
                Text(question.gacarReference)
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .foregroundColor(.blue)
                
                Text(currentLanguage == .arabic ? question.questionAr : question.questionEn)
                    .font(.system(size: 16, weight: .bold))
                    .lineSpacing(4)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.blue.opacity(0.06))
            )
            
            // Options
            let options = currentLanguage == .arabic ? question.optionsAr : question.optionsEn
            ForEach(0..<options.count, id: \.self) { index in
                Button(action: {
                    guard !showAnswerFeedback else { return }
                    selectedAnswerIndex = index
                    showAnswerFeedback = true
                    if index == question.correctOptionIndex {
                        userScore += 1
                    }
                }) {
                    HStack {
                        Text(options[index])
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.primary)
                        Spacer()
                        
                        if showAnswerFeedback {
                            if index == question.correctOptionIndex {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            } else if index == selectedAnswerIndex {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .padding(14)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(optionBackgroundColor(for: index, correct: question.correctOptionIndex))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(optionBorderColor(for: index, correct: question.correctOptionIndex), lineWidth: 1)
                            )
                    )
                }
                .buttonStyle(.plain)
            }
            
            // Explanation & Next Button
            if showAnswerFeedback {
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Image(systemName: "lightbulb.fill")
                            .foregroundColor(.yellow)
                        Text(currentLanguage == .arabic ? "الشرح والتوضيح:" : "Regulatory Explanation:")
                            .font(.system(size: 13, weight: .bold))
                    }
                    
                    Text(currentLanguage == .arabic ? question.explanationAr : question.explanationEn)
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                        .lineSpacing(3)
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.primary.opacity(0.04))
                )
                
                Button(action: {
                    showAnswerFeedback = false
                    selectedAnswerIndex = nil
                    if currentQuestionIndex + 1 < questions.count {
                        currentQuestionIndex += 1
                    } else {
                        quizCompleted = true
                    }
                }) {
                    HStack {
                        Spacer()
                        Text(currentQuestionIndex + 1 < questions.count ?
                             (currentLanguage == .arabic ? "السؤال التالي" : "Next Question") :
                             (currentLanguage == .arabic ? "عرض النتيجة النهائي" : "View Final Score"))
                            .font(.system(size: 15, weight: .bold))
                        Image(systemName: "arrow.right")
                        Spacer()
                    }
                    .padding(12)
                    .background(Capsule().fill(Color.blue))
                    .foregroundColor(.white)
                }
            }
        }
    }

    // MARK: - Flashcard View (3D Flip Animation)
    private func renderFlashcardView(questions: [QuizQuestion]) -> some View {
        let question = questions[min(currentQuestionIndex, questions.count - 1)]
        
        return VStack(spacing: 20) {
            HStack {
                Text("\(currentLanguage == .arabic ? "بطاقة" : "Card") \(currentQuestionIndex + 1)/\(questions.count)")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundColor(.secondary)
                Spacer()
                Text(currentLanguage == .arabic ? "اضغط للقلب 🔄" : "Tap card to flip 🔄")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.blue)
            }
            
            // 3D Flip Card
            ZStack {
                if !isCardFlipped {
                    // Front of Card: Question
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Text(question.gacarReference)
                                .font(.system(size: 12, weight: .bold, design: .monospaced))
                                .foregroundColor(.blue)
                            Spacer()
                            Image(systemName: question.category.iconName)
                                .foregroundColor(.secondary)
                        }
                        
                        Text(currentLanguage == .arabic ? question.questionAr : question.questionEn)
                            .font(.system(size: 18, weight: .bold))
                            .lineSpacing(6)
                        
                        Spacer()
                        
                        HStack {
                            Spacer()
                            Text(currentLanguage == .arabic ? "اضغط لعرض الإجابة والشرح 👈" : "Tap to reveal answer & GACAR rule 👈")
                                .font(.caption.weight(.bold))
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, minHeight: 220, alignment: .topLeading)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.blue.opacity(0.08))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.blue.opacity(0.3), lineWidth: 1.5)
                            )
                    )
                } else {
                    // Back of Card: Answer & Explanation
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundColor(.green)
                            Text(currentLanguage == .arabic ? "الإجابة الصحيحة:" : "Correct Answer:")
                                .font(.caption.weight(.bold))
                                .foregroundColor(.green)
                            Spacer()
                            Text(question.gacarReference)
                                .font(.system(size: 11, weight: .bold, design: .monospaced))
                                .foregroundColor(.blue)
                        }
                        
                        let correctText = currentLanguage == .arabic ?
                        question.optionsAr[question.correctOptionIndex] :
                        question.optionsEn[question.correctOptionIndex]
                        
                        Text(correctText)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.green)
                        
                        Divider()
                        
                        Text(currentLanguage == .arabic ? question.explanationAr : question.explanationEn)
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                            .lineSpacing(4)
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, minHeight: 220, alignment: .topLeading)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.green.opacity(0.08))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.green.opacity(0.3), lineWidth: 1.5)
                            )
                    )
                }
            }
            .rotation3DEffect(.degrees(isCardFlipped ? 180 : 0), axis: (x: 0.0, y: 1.0, z: 0.0))
            .onTapGesture {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    isCardFlipped.toggle()
                }
            }
            
            // Navigation Controls
            HStack(spacing: 20) {
                Button(action: {
                    if currentQuestionIndex > 0 {
                        isCardFlipped = false
                        currentQuestionIndex -= 1
                    }
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text(currentLanguage == .arabic ? "السابق" : "Previous")
                    }
                    .font(.system(size: 14, weight: .bold))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Capsule().fill(Color.primary.opacity(0.06)))
                }
                .disabled(currentQuestionIndex == 0)
                
                Spacer()
                
                Button(action: {
                    if currentQuestionIndex + 1 < questions.count {
                        isCardFlipped = false
                        currentQuestionIndex += 1
                    }
                }) {
                    HStack {
                        Text(currentLanguage == .arabic ? "التالي" : "Next")
                        Image(systemName: "chevron.right")
                    }
                    .font(.system(size: 14, weight: .bold))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Capsule().fill(Color.blue))
                    .foregroundColor(.white)
                }
                .disabled(currentQuestionIndex + 1 >= questions.count)
            }
        }
    }

    // MARK: - Quiz Results Summary
    private func quizResultsSummaryView(totalQuestions: Int) -> some View {
        let percentage = Int((Double(userScore) / Double(totalQuestions)) * 100.0)
        let isPassed = percentage >= 70
        
        return VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(isPassed ? Color.green.opacity(0.15) : Color.red.opacity(0.15))
                    .frame(width: 90, height: 90)
                Image(systemName: isPassed ? "trophy.fill" : "exclamationmark.triangle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(isPassed ? .green : .red)
            }
            
            Text(isPassed ?
                 (currentLanguage == .arabic ? "تهانينا! لقد اجتزت الاختبار ✈️" : "Congratulations! You Passed ✈️") :
                 (currentLanguage == .arabic ? "يرجى مراجعة لوائح GACAR والمحاولة مجدداً" : "Keep studying GACAR rules & try again"))
                .font(.title3.weight(.bold))
            
            VStack(spacing: 6) {
                Text("\(percentage)%")
                    .font(.system(size: 44, weight: .heavy, design: .monospaced))
                    .foregroundColor(isPassed ? .green : .red)
                
                Text("\(currentLanguage == .arabic ? "النتيجة:" : "Score:") \(userScore) / \(totalQuestions)")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.secondary)
            }
            
            Button(action: resetQuiz) {
                HStack {
                    Image(systemName: "arrow.counterclockwise")
                    Text(currentLanguage == .arabic ? "إعادة الاختبار" : "Restart Quiz")
                }
                .font(.system(size: 15, weight: .bold))
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Capsule().fill(Color.blue))
                .foregroundColor(.white)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.primary.opacity(0.04))
        )
    }

    private func optionBackgroundColor(for index: Int, correct: Int) -> Color {
        guard showAnswerFeedback else {
            return Color.primary.opacity(0.04)
        }
        if index == correct {
            return Color.green.opacity(0.15)
        }
        if index == selectedAnswerIndex {
            return Color.red.opacity(0.15)
        }
        return Color.primary.opacity(0.03)
    }
    
    private func optionBorderColor(for index: Int, correct: Int) -> Color {
        guard showAnswerFeedback else {
            return Color.primary.opacity(0.08)
        }
        if index == correct {
            return Color.green
        }
        if index == selectedAnswerIndex {
            return Color.red
        }
        return Color.clear
    }

    // MARK: - 3. Calculators Section
    private var calculatorsSection: some View {
        VStack(alignment: .leading, spacing: 24) {
            // 1. VFR Fuel Reserve Calculator (GACAR Part 91.151)
            VStack(alignment: .leading, spacing: 12) {
                Text(currentLanguage == .arabic ? "حاسبة الوقود لرحلات VFR (GACAR 91.151)" : "GACAR 91.151 VFR Fuel Calculator")
                    .font(.headline)
                
                VStack(spacing: 10) {
                    HStack {
                        Text(currentLanguage == .arabic ? "معدل استهلاك الوقود (جالون/ساعة):" : "Cruising Fuel Burn (GPH):")
                            .font(.subheadline)
                        Spacer()
                        TextField("GPH", text: $cruiseFuelBurnGPH)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    HStack {
                        Text(currentLanguage == .arabic ? "زمن الطيران إلى الوجهة (ساعات):" : "Flight Time to Destination (hrs):")
                            .font(.subheadline)
                        Spacer()
                        TextField("Hours", text: $flightTimeHours)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    Toggle(isOn: $isNightFlight) {
                        Text(currentLanguage == .arabic ? "رحلة ليلية (Night VFR - 45 دقيقة احتياطي)" : "Night VFR Flight (45 min reserve)")
                            .font(.subheadline.weight(.semibold))
                    }
                    
                    let gph = Double(cruiseFuelBurnGPH) ?? 10.0
                    let flightHours = Double(flightTimeHours) ?? 2.5
                    let reserveMinutes: Double = isNightFlight ? 45.0 : 30.0
                    let tripFuel = gph * flightHours
                    let reserveFuel = gph * (reserveMinutes / 60.0)
                    let totalFuelRequired = tripFuel + reserveFuel
                    
                    Divider()
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text(currentLanguage == .arabic ? "إجمالي الوقود المطلوب:" : "Total Required Fuel:")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(String(format: "%.1f GAL", totalFuelRequired))
                                .font(.system(size: 20, weight: .bold, design: .monospaced))
                                .foregroundColor(.blue)
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text(currentLanguage == .arabic ? "وقود الرحلة / الاحتياطي:" : "Trip / Reserve Fuel:")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(String(format: "%.1f / %.1f GAL", tripFuel, reserveFuel))
                                .font(.system(size: 13, weight: .semibold, design: .monospaced))
                        }
                    }
                }
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.blue.opacity(0.05))
                )
            }
            
            // 2. Crosswind Calculator
            VStack(alignment: .leading, spacing: 12) {
                Text(currentLanguage == .arabic ? "حاسبة مركبة الرياح الجانبية (Crosswind)" : "Crosswind Component Calculator")
                    .font(.headline)
                
                VStack(spacing: 10) {
                    HStack {
                        Text(currentLanguage == .arabic ? "سرعة الرياح (عقدة):" : "Wind Speed (kts):")
                            .font(.subheadline)
                        Spacer()
                        TextField("Kts", text: $windSpeed)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 70)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    HStack {
                        Text(currentLanguage == .arabic ? "اتجاه الرياح (درجة):" : "Wind Direction (°):")
                            .font(.subheadline)
                        Spacer()
                        TextField("Deg", text: $windDirection)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 70)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    HStack {
                        Text(currentLanguage == .arabic ? "اتجاه المدرج (درجة):" : "Runway Heading (°):")
                            .font(.subheadline)
                        Spacer()
                        TextField("Rwy", text: $runwayHeading)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 70)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    let ws = Double(windSpeed) ?? 15.0
                    let wd = Double(windDirection) ?? 310.0
                    let rwy = Double(runwayHeading) ?? 340.0
                    let (crosswind, headwind) = METARService.calculateCrosswind(windSpeed: ws, windDirection: wd, runwayHeading: rwy)
                    
                    Divider()
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text(currentLanguage == .arabic ? "الرياح الجانبية (Crosswind):" : "Crosswind Component:")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(String(format: "%.1f KTS", crosswind))
                                .font(.system(size: 18, weight: .bold, design: .monospaced))
                                .foregroundColor(crosswind > 15 ? .orange : .green)
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text(currentLanguage == .arabic ? "الرياح الأمامية (Headwind):" : "Headwind Component:")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(String(format: "%.1f KTS", headwind))
                                .font(.system(size: 18, weight: .bold, design: .monospaced))
                                .foregroundColor(.blue)
                        }
                    }
                }
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.primary.opacity(0.04))
                )
            }
        }
    }
}
