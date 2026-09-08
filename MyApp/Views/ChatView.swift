import SwiftUI

struct ChatView: View {
    @ObservedObject var aiService: CaptainAdelAIService
    @Binding var currentLanguage: AppLanguage
    @State private var inputText: String = ""
    @State private var showVoiceModal: Bool = false
    @FocusState private var isInputFocused: Bool
    
    // Exact prompt pills matching captadel.com queries
    private let promptPillsEn = [
        "VFR weather minima in Class C/D? (§91.155)",
        "Fuel reserve for VFR night flight? (§91.151)",
        "Minimum safe altitude over cities? (§91.119)",
        "Speed limit below 10,000 ft? (§91.117)",
        "Recent flight experience for passengers? (§61.57)",
        "Suborbital hops over Empty Quarter? (Refusal)"
    ]
    
    private let promptPillsAr = [
        "الحد الأدنى للرؤية VFR في الأجواء المراقبة؟ (§91.155)",
        "احتياطي الوقود للطيران البصري ليلاً؟ (§91.151)",
        "الارتفاع الآمن فوق المدن والمناطق المأهولة؟ (§91.119)",
        "السرعة القصوى تحت 10,000 قدم؟ (§91.117)",
        "شروط الخبرة الحديثة لنقل الركاب؟ (§61.57)",
        "رحلات مدارية فوق الربع الخالي؟ (تجربة الاعتذار)"
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // 1. Cockpit Header HUD
            HeaderHUDView(currentLanguage: $currentLanguage, onVoiceModeTap: {
                showVoiceModal = true
            })
            
            // 2. GACAR Running Tape Ticker
            GACARTickerTapeView()
            
            // 3. Chat History Stream
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 14) {
                        // Doctrine Banner
                        doctrineBanner
                        
                        // Messages
                        ForEach(aiService.messages) { message in
                            CockpitMessageRowView(message: message, language: currentLanguage)
                                .id(message.id)
                        }
                        
                        if aiService.isThinking {
                            cockpitThinkingIndicator
                                .id("thinking_row")
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                }
                .background(AvionicsTheme.bg)
                .onChange(of: aiService.messages.count) { _ in
                    if let lastMsg = aiService.messages.last {
                        withAnimation {
                            proxy.scrollTo(lastMsg.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            // 4. Quick Pilot Query Pills
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    let pills = currentLanguage == .arabic ? promptPillsAr : promptPillsEn
                    ForEach(pills, id: \.self) { pill in
                        Button(action: {
                            inputText = pill
                            sendUserMessage()
                        }) {
                            HStack(spacing: 5) {
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 8, weight: .bold))
                                    .foregroundColor(AvionicsTheme.cyan)
                                Text(pill)
                                    .font(.system(size: 11, weight: .medium, design: .monospaced))
                                    .foregroundColor(AvionicsTheme.ink)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(AvionicsTheme.panel2)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 6)
                                            .stroke(AvionicsTheme.line, lineWidth: 1)
                                    )
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
            }
            .background(AvionicsTheme.panel)

            // 5. Avionics Cockpit Input Console
            HStack(spacing: 10) {
                HStack(spacing: 8) {
                    Text("REQ >")
                        .font(.system(size: 11, weight: .black, design: .monospaced))
                        .foregroundColor(AvionicsTheme.cyan)
                    
                    TextField(
                        currentLanguage == .arabic ? "اطلب من كابتن عادل توثيق مادة في GACAR..." : "Ask Captain Adel to cite GACAR regulations...",
                        text: $inputText
                    )
                    .font(.system(size: 13, design: .monospaced))
                    .foregroundColor(AvionicsTheme.ink)
                    .focused($isInputFocused)
                    .onSubmit {
                        sendUserMessage()
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(AvionicsTheme.panel2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(AvionicsTheme.line, lineWidth: 1)
                        )
                )

                // Transmit Button
                Button(action: sendUserMessage) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(inputText.trimmingCharacters(in: .whitespaces).isEmpty ? AvionicsTheme.panel2 : AvionicsTheme.cyan)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(inputText.trimmingCharacters(in: .whitespaces).isEmpty ? AvionicsTheme.line : AvionicsTheme.cyan, lineWidth: 1)
                            )
                            .frame(width: 42, height: 40)
                        
                        Image(systemName: "arrow.up.right")
                            .font(.system(size: 15, weight: .black))
                            .foregroundColor(inputText.trimmingCharacters(in: .whitespaces).isEmpty ? AvionicsTheme.inkDim : AvionicsTheme.bg)
                    }
                }
                .disabled(inputText.trimmingCharacters(in: .whitespaces).isEmpty || aiService.isThinking)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(AvionicsTheme.panel)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(AvionicsTheme.line),
                alignment: .top
            )
        }
        .background(AvionicsTheme.bg)
        .environment(\.layoutDirection, currentLanguage.isRTL ? .rightToLeft : .leftToRight)
        .sheet(isPresented: $showVoiceModal) {
            CockpitVoiceAssistantModalView(aiService: aiService, language: currentLanguage)
        }
    }
    
    private func sendUserMessage() {
        let textToSend = inputText
        inputText = ""
        isInputFocused = false
        Task {
            await aiService.sendMessage(textToSend)
        }
    }
    
    // MARK: - captadel.com Doctrine Banner
    private var doctrineBanner: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "shield.checkerboard")
                .foregroundColor(AvionicsTheme.cyan)
                .font(.system(size: 16))
            
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text(currentLanguage == .arabic ? "عقيدة الاسترجاع: التوثيق أو الاعتذار" : "DOCTRINE // CITE OR REFUSE")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundColor(AvionicsTheme.cyan)
                    
                    Text("100% GROUNDED")
                        .font(.system(size: 8.5, weight: .black, design: .monospaced))
                        .padding(.horizontal, 4)
                        .padding(.vertical, 1)
                        .background(AvionicsTheme.mint.opacity(0.15))
                        .foregroundColor(AvionicsTheme.mint)
                        .cornerRadius(3)
                }
                
                Text(currentLanguage == .arabic ?
                     "كابتن عادل يجيب فقط بنص المادة ورقمها من لوائح GACAR الـ 74، ويعتذر عن التخمين عند عدم وجود سند قطعي. المرجع الرسمي: gaca.gov.sa" :
                     "Captain Adel answers with the exact Part and section cited — or an honest refusal. Never an invented guess. Authoritative source: gaca.gov.sa")
                    .font(.system(size: 11))
                    .foregroundColor(AvionicsTheme.inkDim)
                    .lineSpacing(2)
            }
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(AvionicsTheme.panel)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(AvionicsTheme.line, lineWidth: 1)
                )
        )
    }
    
    private var cockpitThinkingIndicator: some View {
        HStack {
            HStack(spacing: 8) {
                PulsingDotView(color: AvionicsTheme.cyan, size: 6)
                Text(currentLanguage == .arabic ? "كابتن عادل يفحص نصوص GACAR..." : "QUERYING GACAR VECTOR EMBEDDINGS...")
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .foregroundColor(AvionicsTheme.cyan)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(AvionicsTheme.panel)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(AvionicsTheme.cyan.opacity(0.4), lineWidth: 1)
                    )
            )
            Spacer()
        }
    }
}

// MARK: - Cockpit Message Row View (Matching captadel.com chat demo)
struct CockpitMessageRowView: View {
    let message: ChatMessage
    let language: AppLanguage
    
    private var isRefusal: Bool {
        // captadel.com refusal doctrine detection
        message.text.lowercased().contains("refuse") ||
        message.text.lowercased().contains("can't ground") ||
        message.text.lowercased().contains("cannot ground") ||
        message.text.contains("أعتذر") ||
        message.text.contains("لا يمكنني إسناد")
    }
    
    var body: some View {
        if message.sender == .captainAdel {
            // Captain Adel Response Card with Accent Stripe
            HStack(alignment: .top, spacing: 10) {
                // Chip Avatar
                Image.captainAvatar
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 34, height: 34)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(AvionicsTheme.teal, lineWidth: 1)
                    )
                    .padding(.top, 2)
                
                VStack(alignment: .leading, spacing: 8) {
                    // Header Bar with Callsign & Badge
                    HStack(spacing: 6) {
                        Text(language == .arabic ? "كابتن عادل" : "CAPT. ADEL")
                            .font(.system(size: 11, weight: .bold, design: .monospaced))
                            .foregroundColor(AvionicsTheme.ink)
                        
                        if isRefusal {
                            Text("REFUSAL // NO CORPUS MATCH")
                                .font(.system(size: 8, weight: .bold, design: .monospaced))
                                .padding(.horizontal, 4)
                                .padding(.vertical, 1)
                                .background(AvionicsTheme.amber.opacity(0.15))
                                .foregroundColor(AvionicsTheme.amber)
                                .cornerRadius(2)
                        } else {
                            Text("GACAR CITED")
                                .font(.system(size: 8, weight: .bold, design: .monospaced))
                                .padding(.horizontal, 4)
                                .padding(.vertical, 1)
                                .background(AvionicsTheme.cyan.opacity(0.15))
                                .foregroundColor(AvionicsTheme.cyan)
                                .cornerRadius(2)
                        }
                    }
                    
                    // Message Text
                    Text(messageText)
                        .font(.system(size: 13.5))
                        .foregroundColor(AvionicsTheme.ink)
                        .lineSpacing(4)
                    
                    // Regulatory Citations as Flight Progress Strips
                    if !message.citations.isEmpty {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(spacing: 4) {
                                Image(systemName: "checkmark.seal.fill")
                                    .font(.system(size: 9))
                                    .foregroundColor(AvionicsTheme.mint)
                                Text(language == .arabic ? "مراجع اللائحة المُستند إليها:" : "GROUNDED CITATIONS:")
                                    .font(.system(size: 9.5, weight: .bold, design: .monospaced))
                                    .foregroundColor(AvionicsTheme.mint)
                            }
                            
                            ForEach(message.citations) { citation in
                                CitationCardView(citation: citation, language: language)
                            }
                        }
                        .padding(.top, 2)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(AvionicsTheme.panel)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(AvionicsTheme.line, lineWidth: 1)
                        )
                )
                // Distinct Left Accent Stripe (captadel.com style: cyan for grounded, amber for refusal)
                .overlay(
                    Rectangle()
                        .fill(isRefusal ? AvionicsTheme.amber : AvionicsTheme.cyan)
                        .frame(width: 3),
                    alignment: .leading
                )
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        } else {
            // Pilot Query Bubble
            HStack {
                Spacer(minLength: 40)
                
                VStack(alignment: .trailing, spacing: 4) {
                    HStack(spacing: 4) {
                        Text(language == .arabic ? "استفسار الطيار" : "PILOT QUERY")
                            .font(.system(size: 8.5, weight: .bold, design: .monospaced))
                            .foregroundColor(AvionicsTheme.cyan)
                        Image(systemName: "antenna.radiowaves.left.and.right")
                            .font(.system(size: 8))
                            .foregroundColor(AvionicsTheme.cyan)
                    }
                    
                    Text(message.text)
                        .font(.system(size: 13.5, weight: .medium))
                        .foregroundColor(AvionicsTheme.ink)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(AvionicsTheme.panel2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(AvionicsTheme.line, lineWidth: 1)
                        )
                )
            }
        }
    }
    
    private var messageText: String {
        if language == .arabic, let ar = message.arabicText, !ar.isEmpty {
            return ar
        }
        return message.text
    }
}

// MARK: - Cockpit Voice Comms Modal
struct CockpitVoiceAssistantModalView: View {
    @ObservedObject var aiService: CaptainAdelAIService
    let language: AppLanguage
    @Environment(\.dismiss) private var dismiss
    @State private var isListening: Bool = true
    
    var body: some View {
        ZStack {
            AvionicsTheme.bg.ignoresSafeArea()
            
            VStack(spacing: 24) {
                HStack {
                    HStack(spacing: 6) {
                        Text("COM 1 · FREQ 121.500")
                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                            .foregroundColor(AvionicsTheme.cyan)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(AvionicsTheme.cyan.opacity(0.12))
                            .overlay(RoundedRectangle(cornerRadius: 4).stroke(AvionicsTheme.cyan.opacity(0.4), lineWidth: 1))
                    }
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(AvionicsTheme.inkDim)
                            .padding(8)
                            .background(Circle().fill(AvionicsTheme.panel2))
                    }
                }
                .padding(.top, 16)
                .padding(.horizontal, 20)
                
                VStack(spacing: 6) {
                    Text(language == .arabic ? "كابتن عادل على موجة الاتصال..." : "CAPT. ADEL // COMMS OPEN")
                        .font(.system(size: 18, weight: .black, design: .monospaced))
                        .foregroundColor(AvionicsTheme.ink)
                    
                    Text(language == .arabic ? "تحدث باللغة العربية أو الإنجليزية لسؤال عن لوائح الطيران" : "Speak in English or Arabic to query GACAR regulatory corpus")
                        .font(.system(size: 12))
                        .foregroundColor(AvionicsTheme.inkDim)
                }
                
                Spacer()
                
                // Animated Audio Waveform in Cyan
                AudioWaveformView(isListening: isListening)
                    .frame(height: 70)
                    .padding(.horizontal, 40)
                
                ZStack {
                    Circle()
                        .stroke(AvionicsTheme.teal.opacity(0.4), lineWidth: 2)
                        .frame(width: 90, height: 90)
                    
                    Button(action: {
                        isListening.toggle()
                    }) {
                        ZStack {
                            Circle()
                                .fill(isListening ? AvionicsTheme.cyan : AvionicsTheme.panel2)
                                .frame(width: 72, height: 72)
                            Image(systemName: isListening ? "mic.fill" : "mic.slash.fill")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(isListening ? AvionicsTheme.bg : AvionicsTheme.inkDim)
                        }
                    }
                }
                
                Text(language == .arabic ? "اضغط للمقاطعة أو إغلاق الميكروفون" : "TAP MIC TO TOGGLE TRANSMISSION")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundColor(AvionicsTheme.inkDim)
                
                Spacer()
            }
        }
        .preferredColorScheme(.dark)
    }
}
