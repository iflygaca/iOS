import SwiftUI

struct AviationToolsView: View {
    @Binding var currentLanguage: AppLanguage
    @State private var selectedToolTab: Int = 1 // 0: METAR Weather, 1: Exam Quiz & Flashcards, 2: FMC Calculators
    
    // METAR weather state
    @ObservedObject private var metarService = METARService.shared
    @State private var selectedAirportCode: String = "OERK"
    @State private var airportSearchQuery: String = ""

    private var filteredAirports: [METARReport] {
        let query = airportSearchQuery.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if query.isEmpty {
            return metarService.airports
        }
        return metarService.airports.filter {
            $0.icaoCode.lowercased().contains(query) ||
            $0.airportNameEn.lowercased().contains(query) ||
            $0.airportNameAr.contains(query)
        }
    }

    private var selectedAirport: METARReport {
        metarService.airports.first(where: { $0.icaoCode == selectedAirportCode }) ?? metarService.airports[0]
    }
    
    // Quiz & Flashcard state
    @State private var studyMode: StudyMode = .quiz
    @State private var selectedQuizCategory: GACARCategory? = nil
    @State private var currentQuestionIndex: Int = 0
    @State private var selectedAnswerIndex: Int? = nil
    @State private var showAnswerFeedback: Bool = false
    @State private var userScore: Int = 0
    @State private var quizCompleted: Bool = false
    
    // Flashcard 3D flip state
    @State private var isCardFlipped: Bool = false
    
    // Calculator 1: VFR Fuel
    @State private var cruiseFuelBurnGPH: String = "10.0"
    @State private var flightTimeHours: String = "2.5"
    @State private var isNightFlight: Bool = false
    
    // Calculator 2: Crosswind & Runway
    @State private var windSpeed: String = "18"
    @State private var windDirection: String = "320"
    @State private var runwayHeading: String = "350"

    // Calculator 3: Density Altitude & Performance
    @State private var elevationFt: String = "2047" // King Khalid Int'l (OERK) default
    @State private var oatCelsius: String = "42"   // Summer desert standard
    @State private var altimeterInHg: String = "29.85"

    // Calculator 4: Top of Descent (TOD)
    @State private var cruiseAltitudeFt: String = "36000"
    @State private var targetAltitudeFt: String = "3000"
    @State private var descentGroundspeedKts: String = "420"

    @Namespace private var modeNamespace

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
                // Header Telemetry Bar
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(currentLanguage == .arabic ? "أدوات الطيار وتجهيز الاختبارات" : "COCKPIT AVIONICS & EXAM PREP")
                            .font(.system(size: 13, weight: .black, design: .monospaced))
                            .foregroundColor(AvionicsTheme.ink)
                        Text(currentLanguage == .arabic ? "بيانات حية ومحاكاة عمليات FMC" : "Live METAR, FMC Calculators, GACAR Q&A")
                            .font(.system(size: 9.5, weight: .medium, design: .monospaced))
                            .foregroundColor(AvionicsTheme.teal)
                    }
                    Spacer()
                    Image(systemName: "gauge.with.needle.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(AvionicsTheme.mintCyanGradient)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(.ultraThinMaterial)
                .background(AvionicsTheme.panel.opacity(0.85))
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(AvionicsTheme.line),
                    alignment: .bottom
                )

                // Tactical Mode Segmented Switcher
                HStack(spacing: 4) {
                    modeTabButton(title: currentLanguage == .arabic ? "طقس METAR" : "METAR", index: 0)
                    modeTabButton(title: currentLanguage == .arabic ? "اختبار وبطاقات" : "PREP & FLASH", index: 1)
                    modeTabButton(title: currentLanguage == .arabic ? "حاسبات FMC" : "FMC CALCS", index: 2)
                }
                .padding(6)
                .background(AvionicsTheme.panel2)
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(AvionicsTheme.line),
                    alignment: .bottom
                )

                ScrollView {
                    VStack(spacing: 16) {
                        if selectedToolTab == 0 {
                            cockpitMetarSection
                        } else if selectedToolTab == 1 {
                            cockpitQuizAndFlashcardsSection
                        } else {
                            cockpitCalculatorsSection
                        }
                    }
                    .padding(14)
                }
                .refreshable {
                    await metarService.fetchLiveSaudiMETARs()
                }
                .background(CockpitBackdrop())
            }
            .background(AvionicsTheme.bg)
        }
        .preferredColorScheme(.dark)
        .environment(\.layoutDirection, currentLanguage.isRTL ? .rightToLeft : .leftToRight)
    }

    private func modeTabButton(title: String, index: Int) -> some View {
        let isSelected = selectedToolTab == index
        return Button(action: {
            Haptics.selection()
            withAnimation(.spring(response: 0.35, dampingFraction: 0.78)) {
                selectedToolTab = index
            }
        }) {
            Text(title)
                .font(.system(size: 11, weight: .bold, design: .monospaced))
                .foregroundColor(isSelected ? AvionicsTheme.bg : AvionicsTheme.inkDim)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 7)
                .background(
                    ZStack {
                        if isSelected {
                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                .fill(AvionicsTheme.mintCyanGradient)
                                .matchedGeometryEffect(id: "toolModeHighlight", in: modeNamespace)
                                .shadow(color: AvionicsTheme.cyan.opacity(0.4), radius: 6, x: 0, y: 2)
                        }
                    }
                )
        }
        .buttonStyle(.plain)
    }

    // MARK: - 1. Cockpit METAR Weather Section
    private var cockpitMetarSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Header with Live NOAA Status & Refresh
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(currentLanguage == .arabic ?
                         "محطات أرصاد المطارات السعودية (\(metarService.airports.count) مطاراً)" :
                         "\(metarService.airports.count) SAUDI CIVIL AERODROMES")
                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                        .foregroundColor(AvionicsTheme.ink)

                    Text(currentLanguage == .arabic ? "بيانات حية من شبكة الأرصاد العالمية و GACA" : "Real-time observations from NOAA / GACA")
                        .font(.system(size: 9))
                        .foregroundColor(AvionicsTheme.inkDim)
                }

                Spacer()

                // Live Badge
                HStack(spacing: 5) {
                    Circle()
                        .fill(metarService.isOfflineMode ? AvionicsTheme.inkDim : AvionicsTheme.mint)
                        .frame(width: 6, height: 6)
                    Text(metarService.isOfflineMode ? (currentLanguage == .arabic ? "احتياطي محلي" : "OFFLINE BASELINE") : "LIVE NOAA 📡")
                        .font(.system(size: 8.5, weight: .bold, design: .monospaced))
                        .foregroundColor(metarService.isOfflineMode ? AvionicsTheme.inkDim : AvionicsTheme.mint)
                }
                .padding(.horizontal, 7)
                .padding(.vertical, 3)
                .background(Capsule().fill(AvionicsTheme.panel2))
                .overlay(Capsule().stroke(metarService.isOfflineMode ? AvionicsTheme.line : AvionicsTheme.mint.opacity(0.4), lineWidth: 1))

                // Refresh Button
                Button(action: {
                    Haptics.light()
                    Task {
                        await metarService.fetchLiveSaudiMETARs()
                    }
                }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(AvionicsTheme.cyan)
                        .padding(6)
                        .background(Circle().fill(AvionicsTheme.panel2))
                }
                .buttonStyle(.pressable)
            }

            // Quick Airport Search Bar
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(AvionicsTheme.cyan)
                    .font(.system(size: 12))
                TextField(
                    currentLanguage == .arabic ? "بحث برمز ICAO أو اسم المطار (الرياض، جدة، نيوم)..." : "Search ICAO or city (OERK, OEJN, NEOM, Red Sea)...",
                    text: $airportSearchQuery
                )
                .font(.system(size: 11, design: .monospaced))
                .foregroundColor(AvionicsTheme.ink)

                if !airportSearchQuery.isEmpty {
                    Button(action: { airportSearchQuery = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(AvionicsTheme.inkDim)
                            .font(.system(size: 12))
                    }
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .background(RoundedRectangle(cornerRadius: 8).fill(AvionicsTheme.panel2))
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(AvionicsTheme.line, lineWidth: 1))
            
            // Airport Selector Chips
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(filteredAirports) { airport in
                        let isSelected = selectedAirportCode == airport.icaoCode
                        Button(action: {
                            Haptics.selection()
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                selectedAirportCode = airport.icaoCode
                            }
                        }) {
                            VStack(spacing: 3) {
                                Text(airport.icaoCode)
                                    .font(.system(size: 13.5, weight: .bold, design: .monospaced))
                                    .foregroundColor(isSelected ? AvionicsTheme.cyan : AvionicsTheme.ink)
                                Text(airport.flightCategory.rawValue)
                                    .font(.system(size: 8.5, weight: .black, design: .monospaced))
                                    .foregroundColor(airport.flightCategory.color)
                            }
                            .padding(.horizontal, 11)
                            .padding(.vertical, 7)
                            .background(Capsule().fill(isSelected ? AvionicsTheme.panel2 : AvionicsTheme.panel))
                            .overlay(
                                Capsule().stroke(
                                    isSelected ? AnyShapeStyle(AvionicsTheme.cyanTealGradient) : AnyShapeStyle(AvionicsTheme.line),
                                    lineWidth: isSelected ? 1.4 : 1
                                )
                            )
                            .shadow(color: isSelected ? AvionicsTheme.cyan.opacity(0.3) : .clear, radius: 8, x: 0, y: 3)
                        }
                        .buttonStyle(.pressable)
                    }
                }
            }
            
            // Raw METAR Terminal Card
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "antenna.radiowaves.left.and.right")
                        .foregroundColor(AvionicsTheme.cyan)
                    Text(currentLanguage == .arabic ? selectedAirport.airportNameAr : selectedAirport.airportNameEn)
                        .font(.system(size: 13.5, weight: .bold))
                        .foregroundColor(AvionicsTheme.ink)
                    Spacer()

                    if selectedAirport.isLive {
                        Text("LIVE")
                            .font(.system(size: 8, weight: .black, design: .monospaced))
                            .padding(.horizontal, 5)
                            .padding(.vertical, 2)
                            .background(Capsule().fill(AvionicsTheme.mint.opacity(0.18)))
                            .foregroundColor(AvionicsTheme.mint)
                    }

                    Text(selectedAirport.flightCategory.rawValue)
                        .font(.system(size: 10, weight: .black, design: .monospaced))
                        .padding(.horizontal, 7)
                        .padding(.vertical, 3)
                        .background(Capsule().fill(selectedAirport.flightCategory.color.opacity(0.2)))
                        .foregroundColor(selectedAirport.flightCategory.color)
                        .overlay(Capsule().stroke(selectedAirport.flightCategory.color, lineWidth: 1))
                }
                
                Text(selectedAirport.rawText)
                    .font(.system(size: 12.5, weight: .bold, design: .monospaced))
                    .foregroundColor(AvionicsTheme.mint)
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .fill(Color.black.opacity(0.92))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .stroke(AvionicsTheme.mint.opacity(0.3), lineWidth: 1)
                    )

                HStack {
                    Text(selectedAirport.flightCategory.arabicDescription)
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundColor(selectedAirport.flightCategory.color)
                    Spacer()
                    Text(selectedAirport.remarks)
                        .font(.system(size: 9.5))
                        .foregroundColor(AvionicsTheme.inkDim)
                }
            }
            .padding(12)
            .glassPanel(accent: AvionicsTheme.cyan, cornerRadius: 12, glow: false, tint: 0.6)

            // Decoded Avionics Grid
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                decodedGridCard(
                    icon: "wind",
                    title: currentLanguage == .arabic ? "الرياح (WIND)" : "WIND VECTOR",
                    value: selectedAirport.windInfo
                )
                decodedGridCard(
                    icon: "eye.fill",
                    title: currentLanguage == .arabic ? "الرؤية (VISIBILITY)" : "FLIGHT VISIBILITY",
                    value: selectedAirport.visibility
                )
                decodedGridCard(
                    icon: "thermometer.medium",
                    title: currentLanguage == .arabic ? "الحرارة / الندى" : "TEMP / DEWPOINT",
                    value: "\(selectedAirport.temperature) / \(selectedAirport.dewPoint)"
                )
                decodedGridCard(
                    icon: "gauge",
                    title: currentLanguage == .arabic ? "الضغط (QNH)" : "ALTIMETER (QNH)",
                    value: selectedAirport.altimeter
                )
            }
        }
    }
    
    private func decodedGridCard(icon: String, title: String, value: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(AvionicsTheme.mintCyanGradient)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 8.5, weight: .bold, design: .monospaced))
                    .foregroundColor(AvionicsTheme.inkDim)
                Text(value)
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundColor(AvionicsTheme.ink)
            }
            Spacer()
        }
        .padding(10)
        .glassPanel(accent: AvionicsTheme.teal, cornerRadius: 10, glow: false, tint: 0.65)
    }

    // MARK: - 2. Quiz & Flashcards Section
    private var cockpitQuizAndFlashcardsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Mode Switcher: Quiz vs. Flashcards
            Picker("Mode", selection: $studyMode) {
                ForEach(StudyMode.allCases) { mode in
                    Text(currentLanguage == .arabic ? mode.arabicName : mode.rawValue).tag(mode)
                }
            }
            .pickerStyle(.segmented)
            
            // Category Filter Chips
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    Button(action: {
                        Haptics.selection()
                        selectedQuizCategory = nil
                        resetQuiz()
                    }) {
                        Text(currentLanguage == .arabic ? "الكل" : "ALL TOPICS")
                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(
                                Capsule().fill(
                                    selectedQuizCategory == nil ? AnyShapeStyle(AvionicsTheme.mintCyanGradient) : AnyShapeStyle(AvionicsTheme.panel2)
                                )
                            )
                            .foregroundColor(selectedQuizCategory == nil ? AvionicsTheme.bg : AvionicsTheme.inkDim)
                            .overlay(
                                Capsule().stroke(selectedQuizCategory == nil ? Color.clear : AvionicsTheme.line, lineWidth: 1)
                            )
                    }
                    .buttonStyle(.pressable)

                    ForEach(GACARCategory.allCases) { cat in
                        Button(action: {
                            Haptics.selection()
                            selectedQuizCategory = cat
                            resetQuiz()
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: cat.iconName)
                                    .font(.system(size: 8))
                                Text(currentLanguage == .arabic ? cat.arabicName : cat.rawValue)
                                    .font(.system(size: 9.5, weight: .bold, design: .monospaced))
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 6)
                            .background(
                                Capsule().fill(
                                    selectedQuizCategory == cat ? AnyShapeStyle(AvionicsTheme.mintCyanGradient) : AnyShapeStyle(AvionicsTheme.panel2)
                                )
                            )
                            .foregroundColor(selectedQuizCategory == cat ? AvionicsTheme.bg : AvionicsTheme.inkDim)
                            .overlay(
                                Capsule().stroke(selectedQuizCategory == cat ? Color.clear : AvionicsTheme.line, lineWidth: 1)
                            )
                        }
                        .buttonStyle(.pressable)
                    }
                }
            }
            
            let questions = activeQuestions
            
            if questions.isEmpty {
                Text(currentLanguage == .arabic ? "لا توجد أسئلة لهذه الفئة حالياً." : "No questions available for this category.")
                    .foregroundColor(AvionicsTheme.inkDim)
                    .padding()
            } else if quizCompleted {
                cockpitQuizResultsSummaryView(totalQuestions: questions.count)
            } else if studyMode == .quiz {
                cockpitQuizQuestionView(questions: questions)
            } else {
                cockpitFlashcardView(questions: questions)
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

    // MARK: - Cockpit Quiz Question View
    private func cockpitQuizQuestionView(questions: [QuizQuestion]) -> some View {
        let question = questions[min(currentQuestionIndex, questions.count - 1)]
        
        return VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text(question.gacarReference)
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .foregroundColor(AvionicsTheme.cyan)
                    .padding(.horizontal, 7)
                    .padding(.vertical, 3)
                    .background(Capsule().fill(AvionicsTheme.cyan.opacity(0.12)))
                    .overlay(Capsule().stroke(AvionicsTheme.cyan.opacity(0.3), lineWidth: 1))

                Spacer()

                Text("Q \(currentQuestionIndex + 1)/\(questions.count)")
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .foregroundColor(AvionicsTheme.inkDim)
            }

            // Question Statement Card
            Text(currentLanguage == .arabic ? question.questionAr : question.questionEn)
                .font(.system(size: 14.5, weight: .bold))
                .foregroundColor(AvionicsTheme.ink)
                .lineSpacing(4)
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .glassPanel(accent: AvionicsTheme.cyan, cornerRadius: 12, glow: false, tint: 0.6)

            // Options
            let options = currentLanguage == .arabic ? question.optionsAr : question.optionsEn
            ForEach(0..<options.count, id: \.self) { index in
                Button(action: {
                    guard !showAnswerFeedback else { return }
                    selectedAnswerIndex = index
                    showAnswerFeedback = true
                    if index == question.correctOptionIndex {
                        userScore += 1
                        Haptics.success()
                    } else {
                        Haptics.warning()
                    }
                }) {
                    HStack {
                        Text(options[index])
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(AvionicsTheme.ink)
                        Spacer()

                        if showAnswerFeedback {
                            if index == question.correctOptionIndex {
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundColor(AvionicsTheme.mint)
                            } else if index == selectedAnswerIndex {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(AvionicsTheme.red)
                            }
                        }
                    }
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(cockpitOptionBg(index: index, correct: question.correctOptionIndex))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(cockpitOptionBorder(index: index, correct: question.correctOptionIndex), lineWidth: 1.2)
                    )
                }
                .buttonStyle(.pressable)
            }

            // Explanation & Next Action
            if showAnswerFeedback {
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Image(systemName: "shield.lefthalf.filled")
                            .foregroundColor(AvionicsTheme.cyan)
                        Text(currentLanguage == .arabic ? "السند النظامي في GACAR:" : "GACAR REGULATORY GROUNDING:")
                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                            .foregroundColor(AvionicsTheme.cyan)
                    }

                    Text(currentLanguage == .arabic ? question.explanationAr : question.explanationEn)
                        .font(.system(size: 12))
                        .foregroundColor(AvionicsTheme.inkDim)
                        .lineSpacing(3)
                }
                .padding(10)
                .glassPanel(accent: AvionicsTheme.cyan, cornerRadius: 10, glow: false, tint: 0.65)

                Button(action: {
                    Haptics.light()
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
                             (currentLanguage == .arabic ? "السؤال التالي" : "NEXT QUESTION") :
                             (currentLanguage == .arabic ? "النتيجة النهائية" : "VIEW SCORE"))
                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                        Image(systemName: "arrow.right")
                        Spacer()
                    }
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(AvionicsTheme.mintCyanGradient)
                    )
                    .foregroundColor(AvionicsTheme.bg)
                    .shadow(color: AvionicsTheme.cyan.opacity(0.35), radius: 10, x: 0, y: 4)
                }
                .buttonStyle(.pressable)
            }
        }
    }

    // MARK: - Cockpit Flashcard View (3D Flip)
    private func cockpitFlashcardView(questions: [QuizQuestion]) -> some View {
        let question = questions[min(currentQuestionIndex, questions.count - 1)]
        
        return VStack(spacing: 16) {
            HStack {
                Text("CARD \(currentQuestionIndex + 1)/\(questions.count)")
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .foregroundColor(AvionicsTheme.inkDim)
                Spacer()
                Text(currentLanguage == .arabic ? "انقر لقلب البطاقة 🔄" : "TAP TO FLIP 🔄")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundColor(AvionicsTheme.cyan)
            }
            
            // 3D Flip Card
            ZStack {
                if !isCardFlipped {
                    // Front of Card
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Text(question.gacarReference)
                                .font(.system(size: 12, weight: .bold, design: .monospaced))
                                .foregroundColor(AvionicsTheme.cyan)
                            Spacer()
                            Image(systemName: question.category.iconName)
                                .foregroundColor(AvionicsTheme.teal)
                        }
                        
                        Text(currentLanguage == .arabic ? question.questionAr : question.questionEn)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(AvionicsTheme.ink)
                            .lineSpacing(5)
                        
                        Spacer()
                        
                        HStack {
                            Spacer()
                            Text(currentLanguage == .arabic ? "عرض الإجابة والسند 👈" : "REVEAL GACAR CLAUSE 👈")
                                .font(.system(size: 10, weight: .bold, design: .monospaced))
                                .foregroundColor(AvionicsTheme.cyan)
                        }
                    }
                    .padding(18)
                    .frame(maxWidth: .infinity, minHeight: 200, alignment: .topLeading)
                    .glassPanel(accent: AvionicsTheme.cyan, cornerRadius: 14, tint: 0.55)
                } else {
                    // Back of Card
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundColor(AvionicsTheme.mint)
                            Text(currentLanguage == .arabic ? "الإجابة المعتمدة:" : "CORRECT CLAUSE:")
                                .font(.system(size: 10, weight: .bold, design: .monospaced))
                                .foregroundColor(AvionicsTheme.mint)
                            Spacer()
                            Text(question.gacarReference)
                                .font(.system(size: 11, weight: .bold, design: .monospaced))
                                .foregroundColor(AvionicsTheme.cyan)
                        }
                        
                        let correctText = currentLanguage == .arabic ?
                        question.optionsAr[question.correctOptionIndex] :
                        question.optionsEn[question.correctOptionIndex]
                        
                        Text(correctText)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(AvionicsTheme.mint)
                        
                        Divider().background(AvionicsTheme.line)
                        
                        Text(currentLanguage == .arabic ? question.explanationAr : question.explanationEn)
                            .font(.system(size: 12))
                            .foregroundColor(AvionicsTheme.inkDim)
                            .lineSpacing(3)
                    }
                    .padding(18)
                    .frame(maxWidth: .infinity, minHeight: 200, alignment: .topLeading)
                    .glassPanel(accent: AvionicsTheme.mint, cornerRadius: 14, tint: 0.6)
                }
            }
            .rotation3DEffect(.degrees(isCardFlipped ? 180 : 0), axis: (x: 0.0, y: 1.0, z: 0.0))
            .onTapGesture {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    isCardFlipped.toggle()
                }
            }
            
            // Navigation Controls
            HStack(spacing: 16) {
                Button(action: {
                    Haptics.light()
                    if currentQuestionIndex > 0 {
                        isCardFlipped = false
                        currentQuestionIndex -= 1
                    }
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text(currentLanguage == .arabic ? "السابق" : "PREV")
                    }
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 9)
                    .background(Capsule().fill(AvionicsTheme.panel2))
                    .overlay(Capsule().stroke(AvionicsTheme.line, lineWidth: 1))
                    .foregroundColor(AvionicsTheme.inkDim)
                }
                .buttonStyle(.pressable)
                .disabled(currentQuestionIndex == 0)

                Spacer()

                Button(action: {
                    Haptics.light()
                    if currentQuestionIndex + 1 < questions.count {
                        isCardFlipped = false
                        currentQuestionIndex += 1
                    }
                }) {
                    HStack {
                        Text(currentLanguage == .arabic ? "التالي" : "NEXT")
                        Image(systemName: "chevron.right")
                    }
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 9)
                    .background(Capsule().fill(AvionicsTheme.mintCyanGradient))
                    .foregroundColor(AvionicsTheme.bg)
                    .shadow(color: AvionicsTheme.cyan.opacity(0.35), radius: 8, x: 0, y: 3)
                }
                .buttonStyle(.pressable)
                .disabled(currentQuestionIndex + 1 >= questions.count)
            }
        }
    }

    // MARK: - Results Summary View
    private func cockpitQuizResultsSummaryView(totalQuestions: Int) -> some View {
        let percentage = Int((Double(userScore) / Double(totalQuestions)) * 100.0)
        let isPassed = percentage >= 70
        
        return VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(isPassed ? AvionicsTheme.mint.opacity(0.15) : AvionicsTheme.red.opacity(0.15))
                    .frame(width: 80, height: 80)
                Image(systemName: isPassed ? "checkmark.seal.fill" : "exclamationmark.triangle.fill")
                    .font(.system(size: 36))
                    .foregroundColor(isPassed ? AvionicsTheme.mint : AvionicsTheme.red)
            }
            
            Text(isPassed ?
                 (currentLanguage == .arabic ? "اجتزت المعايير بنجاح ✈️" : "GACAR KNOWLEDGE CRITERIA MET ✈️") :
                 (currentLanguage == .arabic ? "يرجى مراجعة لوائح GACAR وإعادة المحاولة" : "BELOW PASSING GRADE — REVIEW GACAR"))
                .font(.system(size: 14, weight: .bold, design: .monospaced))
                .foregroundColor(isPassed ? AvionicsTheme.mint : AvionicsTheme.amber)
            
            Text("\(percentage)%")
                .font(.system(size: 40, weight: .black, design: .monospaced))
                .foregroundColor(isPassed ? AvionicsTheme.mint : AvionicsTheme.red)
            
            Button(action: {
                Haptics.light()
                resetQuiz()
            }) {
                HStack {
                    Image(systemName: "arrow.counterclockwise")
                    Text(currentLanguage == .arabic ? "إعادة الاختبار" : "RESET EXAM")
                }
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .padding(.horizontal, 20)
                .padding(.vertical, 11)
                .background(Capsule().fill(AvionicsTheme.mintCyanGradient))
                .foregroundColor(AvionicsTheme.bg)
                .shadow(color: AvionicsTheme.cyan.opacity(0.4), radius: 10, x: 0, y: 4)
            }
            .buttonStyle(.pressable)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .glassPanel(accent: isPassed ? AvionicsTheme.mint : AvionicsTheme.red, cornerRadius: 14)
    }

    private func cockpitOptionBg(index: Int, correct: Int) -> Color {
        guard showAnswerFeedback else { return AvionicsTheme.panel2 }
        if index == correct { return AvionicsTheme.mint.opacity(0.15) }
        if index == selectedAnswerIndex { return AvionicsTheme.red.opacity(0.15) }
        return AvionicsTheme.panel2
    }
    
    private func cockpitOptionBorder(index: Int, correct: Int) -> Color {
        guard showAnswerFeedback else { return AvionicsTheme.line }
        if index == correct { return AvionicsTheme.mint }
        if index == selectedAnswerIndex { return AvionicsTheme.red }
        return AvionicsTheme.line
    }

    // MARK: - 3. Cockpit Flight Management Computer (FMC) Calculators
    private var cockpitCalculatorsSection: some View {
        VStack(alignment: .leading, spacing: 18) {
            // 1. VFR Fuel Reserve Calculator (GACAR Part 91.151)
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("FMC 01 // GACAR §91.151 VFR FUEL")
                        .font(.system(size: 11, weight: .black, design: .monospaced))
                        .foregroundColor(AvionicsTheme.cyan)
                    Spacer()
                    Text("MANDATORY RESERVE")
                        .font(.system(size: 8.5, weight: .bold, design: .monospaced))
                        .foregroundColor(AvionicsTheme.amber)
                }
                
                VStack(spacing: 8) {
                    HStack {
                        Text(currentLanguage == .arabic ? "معدل الحرق (جالون/س):" : "Cruise Burn Rate (GPH):")
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundColor(AvionicsTheme.ink)
                        Spacer()
                        TextField("GPH", text: $cruiseFuelBurnGPH)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 70)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    HStack {
                        Text(currentLanguage == .arabic ? "زمن الطيران (ساعات):" : "En-route Time (Hrs):")
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundColor(AvionicsTheme.ink)
                        Spacer()
                        TextField("Hours", text: $flightTimeHours)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 70)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    Toggle(isOn: $isNightFlight) {
                        Text(currentLanguage == .arabic ? "طيران ليلي (احتياطي 45 دقيقة §91.151)" : "Night VFR (45 Min Reserve §91.151)")
                            .font(.system(size: 11, weight: .bold, design: .monospaced))
                            .foregroundColor(AvionicsTheme.amber)
                    }
                    
                    let gph = Double(cruiseFuelBurnGPH) ?? 10.0
                    let flightHours = Double(flightTimeHours) ?? 2.5
                    let reserveMinutes: Double = isNightFlight ? 45.0 : 30.0
                    let tripFuel = gph * flightHours
                    let reserveFuel = gph * (reserveMinutes / 60.0)
                    let totalFuelRequired = tripFuel + reserveFuel
                    
                    Divider().background(AvionicsTheme.line)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text(currentLanguage == .arabic ? "إجمالي الوقود المطلوب:" : "MIN FUEL REQUIRED:")
                                .font(.system(size: 9, weight: .bold, design: .monospaced))
                                .foregroundColor(AvionicsTheme.inkDim)
                            Text(String(format: "%.1f GAL", totalFuelRequired))
                                .font(.system(size: 18, weight: .heavy, design: .monospaced))
                                .foregroundColor(AvionicsTheme.cyan)
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text(currentLanguage == .arabic ? "رحلة / احتياطي:" : "TRIP / RESERVE:")
                                .font(.system(size: 9, weight: .bold, design: .monospaced))
                                .foregroundColor(AvionicsTheme.inkDim)
                            Text(String(format: "%.1f / %.1f GAL", tripFuel, reserveFuel))
                                .font(.system(size: 12, weight: .bold, design: .monospaced))
                                .foregroundColor(AvionicsTheme.mint)
                        }
                    }
                }
                .padding(12)
                .glassPanel(accent: AvionicsTheme.cyan, cornerRadius: 12, glow: false, tint: 0.6)
            }

            // 2. Crosswind Component & Tactical Runway Visualizer
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("FMC 02 // CROSSWIND & RUNWAY RESOLUTION")
                        .font(.system(size: 11, weight: .black, design: .monospaced))
                        .foregroundColor(AvionicsTheme.cyan)
                    Spacer()
                    Text("VECTOR RESOLUTION")
                        .font(.system(size: 8.5, weight: .bold, design: .monospaced))
                        .foregroundColor(AvionicsTheme.teal)
                }
                
                VStack(spacing: 10) {
                    HStack {
                        Text(currentLanguage == .arabic ? "سرعة الرياح (عقدة):" : "Wind Speed (kts):")
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundColor(AvionicsTheme.ink)
                        Spacer()
                        TextField("Kts", text: $windSpeed)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 70)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    HStack {
                        Text(currentLanguage == .arabic ? "اتجاه الرياح (°):" : "Wind Direction (°):")
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundColor(AvionicsTheme.ink)
                        Spacer()
                        TextField("Deg", text: $windDirection)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 70)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    HStack {
                        Text(currentLanguage == .arabic ? "اتجاه المدرج (°):" : "Runway Heading (°):")
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundColor(AvionicsTheme.ink)
                        Spacer()
                        TextField("Rwy", text: $runwayHeading)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 70)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    let ws = Double(windSpeed) ?? 18.0
                    let wd = Double(windDirection) ?? 320.0
                    let rwy = Double(runwayHeading) ?? 350.0
                    let (crosswind, headwind) = METARService.calculateCrosswind(windSpeed: ws, windDirection: wd, runwayHeading: rwy)
                    let deltaAngle = wd - rwy
                    let isRightWind = sin(deltaAngle * .pi / 180.0) > 0
                    
                    // Tactical Compass / Runway Vector Graphic
                    HStack(spacing: 14) {
                        ZStack {
                            Circle()
                                .stroke(AvionicsTheme.line, lineWidth: 1.5)
                                .frame(width: 70, height: 70)
                            
                            // Runway Strip
                            RoundedRectangle(cornerRadius: 3)
                                .fill(AvionicsTheme.inkDim.opacity(0.35))
                                .frame(width: 14, height: 60)
                                .overlay(
                                    Rectangle()
                                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [4, 4]))
                                        .foregroundColor(AvionicsTheme.mint)
                                        .frame(width: 1, height: 50)
                                )
                                .rotationEffect(.degrees(rwy))
                            
                            // Wind Arrow
                            Image(systemName: "arrow.down")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(crosswind > 15 ? AvionicsTheme.amber : AvionicsTheme.cyan)
                                .offset(y: -24)
                                .rotationEffect(.degrees(wd))
                        }
                        .frame(width: 76, height: 76)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(isRightWind ? (currentLanguage == .arabic ? "رياح جانبية من اليمين" : "RIGHT CROSSWIND") :
                                 (currentLanguage == .arabic ? "رياح جانبية من اليسار" : "LEFT CROSSWIND"))
                                .font(.system(size: 10, weight: .black, design: .monospaced))
                                .foregroundColor(crosswind > 20 ? AvionicsTheme.red : (crosswind > 12 ? AvionicsTheme.amber : AvionicsTheme.mint))

                            Text(headwind >= 0 ?
                                 (currentLanguage == .arabic ? "رياح أمامية مهبطة (Headwind)" : "FAVORABLE HEADWIND") :
                                 (currentLanguage == .arabic ? "⚠️ رياح خلفية (TAILWIND WARNING)" : "⚠️ UNFAVORABLE TAILWIND"))
                                .font(.system(size: 9.5, weight: .bold, design: .monospaced))
                                .foregroundColor(headwind >= 0 ? AvionicsTheme.cyan : AvionicsTheme.red)

                            if crosswind > 15 {
                                Text(currentLanguage == .arabic ? "تنبيه: تتجاوز الحد المعتاد للطائرات الخفيفة" : "Advisory: Exceeds standard light trainer max demo x-wind")
                                    .font(.system(size: 8.5))
                                    .foregroundColor(AvionicsTheme.amber)
                            }
                        }
                    }
                    .padding(.vertical, 4)

                    Divider().background(AvionicsTheme.line)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text(currentLanguage == .arabic ? "الرياح الجانبية:" : "CROSSWIND COMPONENT:")
                                .font(.system(size: 9, weight: .bold, design: .monospaced))
                                .foregroundColor(AvionicsTheme.inkDim)
                            Text(String(format: "%.1f KTS", crosswind))
                                .font(.system(size: 18, weight: .heavy, design: .monospaced))
                                .foregroundColor(crosswind > 15 ? AvionicsTheme.amber : AvionicsTheme.mint)
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text(currentLanguage == .arabic ? "الرياح الأمامية/الخلفية:" : "HEAD/TAIL COMPONENT:")
                                .font(.system(size: 9, weight: .bold, design: .monospaced))
                                .foregroundColor(AvionicsTheme.inkDim)
                            Text(String(format: "%.1f KTS", headwind))
                                .font(.system(size: 14, weight: .bold, design: .monospaced))
                                .foregroundColor(headwind >= 0 ? AvionicsTheme.cyan : AvionicsTheme.red)
                        }
                    }
                }
                .padding(12)
                .glassPanel(accent: AvionicsTheme.teal, cornerRadius: 12, glow: false, tint: 0.6)
            }

            // 3. Density Altitude & High Temp Performance Computer (FMC 03)
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("FMC 03 // DENSITY ALTITUDE & HOT WEATHER")
                        .font(.system(size: 11, weight: .black, design: .monospaced))
                        .foregroundColor(AvionicsTheme.amber)
                    Spacer()
                    Text("ICAO / GACAR PERF")
                        .font(.system(size: 8.5, weight: .bold, design: .monospaced))
                        .foregroundColor(AvionicsTheme.teal)
                }

                VStack(spacing: 8) {
                    HStack {
                        Text(currentLanguage == .arabic ? "ارتفاع المطار (قدم MSL):" : "Field Elevation (ft MSL):")
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundColor(AvionicsTheme.ink)
                        Spacer()
                        TextField("Elev", text: $elevationFt)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 70)
                            .textFieldStyle(.roundedBorder)
                    }

                    HStack {
                        Text(currentLanguage == .arabic ? "درجة الحرارة الخارجية (°C):" : "Outside Air Temp (°C):")
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundColor(AvionicsTheme.ink)
                        Spacer()
                        TextField("OAT", text: $oatCelsius)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 70)
                            .textFieldStyle(.roundedBorder)
                    }

                    HStack {
                        Text(currentLanguage == .arabic ? "مقياس الضغط (inHg):" : "Altimeter Setting (inHg):")
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundColor(AvionicsTheme.ink)
                        Spacer()
                        TextField("QNH", text: $altimeterInHg)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 70)
                            .textFieldStyle(.roundedBorder)
                    }

                    let elev = Double(elevationFt) ?? 2047.0
                    let oat = Double(oatCelsius) ?? 42.0
                    let altim = Double(altimeterInHg) ?? 29.85
                    
                    // Pressure Altitude = Elevation + (29.92 - Altimeter) * 1000
                    let pressureAlt = elev + ((29.92 - altim) * 1000.0)
                    // Standard ISA Temperature at Elevation = 15 - (2 * Elev/1000)
                    let isaTemp = 15.0 - (2.0 * (elev / 1000.0))
                    // Density Altitude = Pressure Alt + [120 * (OAT - ISA)]
                    let densityAlt = pressureAlt + (120.0 * (oat - isaTemp))
                    let daDelta = densityAlt - elev

                    Divider().background(AvionicsTheme.line)

                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(currentLanguage == .arabic ? "ارتفاع الكثافة الفعلي:" : "DENSITY ALTITUDE:")
                                .font(.system(size: 9, weight: .bold, design: .monospaced))
                                .foregroundColor(AvionicsTheme.inkDim)
                            Text(String(format: "%.0f FT", densityAlt))
                                .font(.system(size: 18, weight: .heavy, design: .monospaced))
                                .foregroundColor(densityAlt > 5000 ? AvionicsTheme.red : (densityAlt > 3000 ? AvionicsTheme.amber : AvionicsTheme.mint))
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 2) {
                            Text(currentLanguage == .arabic ? "فارق الأداء (Δ DA):" : "PERFORMANCE PENALTY:")
                                .font(.system(size: 9, weight: .bold, design: .monospaced))
                                .foregroundColor(AvionicsTheme.inkDim)
                            Text(String(format: "+%.0f FT", daDelta))
                                .font(.system(size: 14, weight: .bold, design: .monospaced))
                                .foregroundColor(AvionicsTheme.amber)
                        }
                    }

                    if daDelta > 2000 {
                        HStack(spacing: 6) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(AvionicsTheme.red)
                                .font(.system(size: 12))
                            Text(currentLanguage == .arabic ?
                                 "تحذير كثافة هواء مرتفعة: توقع مسافة إقلاع أطول ومعدل صعود منخفض بنسبة 35%" :
                                 "High DA Warning: Significant takeoff roll increase & degraded climb performance (~35%).")
                                .font(.system(size: 9, weight: .medium))
                                .foregroundColor(AvionicsTheme.red)
                        }
                        .padding(.top, 4)
                    }
                }
                .padding(12)
                .glassPanel(accent: AvionicsTheme.amber, cornerRadius: 12, glow: false, tint: 0.6)
            }

            // 4. Top of Descent (TOD) & 3:1 Glide Slope Computer (FMC 04)
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("FMC 04 // TOP OF DESCENT (TOD) 3:1")
                        .font(.system(size: 11, weight: .black, design: .monospaced))
                        .foregroundColor(AvionicsTheme.cyan)
                    Spacer()
                    Text("3° GLIDEPATH")
                        .font(.system(size: 8.5, weight: .bold, design: .monospaced))
                        .foregroundColor(AvionicsTheme.teal)
                }

                VStack(spacing: 8) {
                    HStack {
                        Text(currentLanguage == .arabic ? "ارتفاع العبور (قدم MSL):" : "Cruise Altitude (ft):")
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundColor(AvionicsTheme.ink)
                        Spacer()
                        TextField("Cruise", text: $cruiseAltitudeFt)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 70)
                            .textFieldStyle(.roundedBorder)
                    }

                    HStack {
                        Text(currentLanguage == .arabic ? "ارتفاع نقطة البداية (IAF):" : "Target / IAF Altitude (ft):")
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundColor(AvionicsTheme.ink)
                        Spacer()
                        TextField("Target", text: $targetAltitudeFt)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 70)
                            .textFieldStyle(.roundedBorder)
                    }

                    HStack {
                        Text(currentLanguage == .arabic ? "السرعة الأرضية للنزول (عقدة):" : "Descent Groundspeed (kts):")
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundColor(AvionicsTheme.ink)
                        Spacer()
                        TextField("GS", text: $descentGroundspeedKts)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 70)
                            .textFieldStyle(.roundedBorder)
                    }

                    let cruise = Double(cruiseAltitudeFt) ?? 36000.0
                    let target = Double(targetAltitudeFt) ?? 3000.0
                    let gs = Double(descentGroundspeedKts) ?? 420.0
                    let altToLose = max(0, cruise - target)
                    // Standard 3:1 rule: TOD Distance (NM) = (Altitude to Lose / 1000) * 3
                    let todDistanceNM = (altToLose / 1000.0) * 3.0
                    // Standard 3-degree Vertical Speed (FPM) = Groundspeed * 5
                    let requiredVS = gs * 5.0
                    // Time to reach target in minutes = (TOD Distance / GS) * 60
                    let timeMinutes = gs > 0 ? (todDistanceNM / gs) * 60.0 : 0.0

                    Divider().background(AvionicsTheme.line)

                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(currentLanguage == .arabic ? "مسافة بداية النزول (TOD):" : "TOD DISTANCE:")
                                .font(.system(size: 9, weight: .bold, design: .monospaced))
                                .foregroundColor(AvionicsTheme.inkDim)
                            Text(String(format: "%.0f NM", todDistanceNM))
                                .font(.system(size: 18, weight: .heavy, design: .monospaced))
                                .foregroundColor(AvionicsTheme.cyan)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 2) {
                            Text(currentLanguage == .arabic ? "معدل النزول الرأسي (V/S):" : "REQUIRED V/S (3°):")
                                .font(.system(size: 9, weight: .bold, design: .monospaced))
                                .foregroundColor(AvionicsTheme.inkDim)
                            Text(String(format: "-%.0f FPM", requiredVS))
                                .font(.system(size: 14, weight: .bold, design: .monospaced))
                                .foregroundColor(AvionicsTheme.mint)
                        }
                    }

                    HStack {
                        Text(currentLanguage == .arabic ?
                             "الوقت المستغرق للنزول: \(String(format: "%.1f", timeMinutes)) دقيقة | الارتفاع المفقود: \(String(format: "%.0f", altToLose)) قدم" :
                             "Descent duration: \(String(format: "%.1f", timeMinutes)) mins | Total loss: \(String(format: "%.0f", altToLose)) ft")
                            .font(.system(size: 9, design: .monospaced))
                            .foregroundColor(AvionicsTheme.inkDim)
                        Spacer()
                    }
                }
                .padding(12)
                .glassPanel(accent: AvionicsTheme.cyan, cornerRadius: 12, glow: false, tint: 0.6)
            }
        }
    }
}
