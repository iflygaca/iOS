import SwiftUI

struct ChatView: View {
    @ObservedObject var aiService: CaptainAdelAIService
    @Binding var currentLanguage: AppLanguage
    @State private var inputText: String = ""
    @State private var showVoiceModal: Bool = false
    @FocusState private var isInputFocused: Bool
    
    // Preset prompt pills for quick pilot queries
    private let promptPillsEn = [
        "What are PPL requirements?",
        "Class 1 Medical duration?",
        "VFR night fuel minimums?",
        "Drone Part 107 altitude limit?",
        "Commercial pilot flight hours?"
    ]
    
    private let promptPillsAr = [
        "متطلبات رخصة طيار خاص؟",
        "مدة صلاحية الفحص الطبي فئة 1؟",
        "احتياطي الوقود للطيران البصري ليلاً؟",
        "ارتفاع الدرونز في Part 107؟",
        "ساعات الطيران للطيار التجاري؟"
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Header Bar
            HeaderHUDView(currentLanguage: $currentLanguage, onVoiceModeTap: {
                showVoiceModal = true
            })
            
            // Chat History List
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 16) {
                        // Disclaimer Banner
                        disclaimerBanner
                        
                        // Messages
                        ForEach(aiService.messages) { message in
                            MessageRowView(message: message, language: currentLanguage)
                                .id(message.id)
                        }
                        
                        if aiService.isThinking {
                            thinkingIndicatorRow
                                .id("thinking_row")
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
                .onChange(of: aiService.messages.count) { _ in
                    if let lastMsg = aiService.messages.last {
                        withAnimation {
                            proxy.scrollTo(lastMsg.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            // Quick Prompt Pills
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    let pills = currentLanguage == .arabic ? promptPillsAr : promptPillsEn
                    ForEach(pills, id: \.self) { pill in
                        Button(action: {
                            inputText = pill
                            sendUserMessage()
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "sparkles")
                                    .font(.caption2)
                                    .foregroundColor(.blue)
                                Text(pill)
                                    .font(.system(size: 12, weight: .semibold))
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(Color.blue.opacity(0.08))
                                    .overlay(
                                        Capsule()
                                            .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                                    )
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
            }

            Divider()

            // Input Bar
            HStack(spacing: 10) {
                TextField(
                    currentLanguage == .arabic ? "اسأل كابتن عادل عن لوائح GACAR..." : "Ask Captain Adel about GACAR rules...",
                    text: $inputText
                )
                .focused($isInputFocused)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.primary.opacity(0.05))
                )
                .onSubmit {
                    sendUserMessage()
                }

                Button(action: sendUserMessage) {
                    ZStack {
                        Circle()
                            .fill(inputText.trimmingCharacters(in: .whitespaces).isEmpty ? Color.gray.opacity(0.3) : Color.blue)
                            .frame(width: 40, height: 40)
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .disabled(inputText.trimmingCharacters(in: .whitespaces).isEmpty || aiService.isThinking)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(.ultraThinMaterial)
        }
        .environment(\.layoutDirection, currentLanguage.isRTL ? .rightToLeft : .leftToRight)
        .sheet(isPresented: $showVoiceModal) {
            VoiceAssistantModalView(aiService: aiService, language: currentLanguage)
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
    
    private var disclaimerBanner: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "info.circle.fill")
                .foregroundColor(.blue)
                .font(.system(size: 16))
            
            Text(currentLanguage == .arabic ?
                 "كابتن عادل مساعد طيران تعليمي مستقل. الإجابات مُسترجعة من لوائح GACAR. يرجى دائماً مراجعة منشورات GACA الرسمية للقرارات التشغيلية." :
                 "Captain Adel is an independent educational flight assistant. Answers are grounded in GACAR regulations. Always verify with official GACA publications.")
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.secondary)
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.blue.opacity(0.06))
        )
    }
    
    private var thinkingIndicatorRow: some View {
        HStack {
            HStack(spacing: 6) {
                ProgressView()
                    .scaleEffect(0.8)
                Text(currentLanguage == .arabic ? "كابتن عادل يبحث في لوائح GACAR..." : "Captain Adel querying GACAR Corpus...")
                    .font(.system(size: 12, weight: .medium, design: .monospaced))
                    .foregroundColor(.secondary)
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.primary.opacity(0.05))
            )
            Spacer()
        }
    }
}

// MARK: - Message Row View
struct MessageRowView: View {
    let message: ChatMessage
    let language: AppLanguage
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            if message.sender == .captainAdel {
                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: [.blue, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 32, height: 32)
                    Image(systemName: "airplane")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(messageText)
                        .font(.system(size: 14.5))
                        .lineSpacing(4)
                        .foregroundColor(.primary)
                    
                    // Render Citations if available
                    if !message.citations.isEmpty {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(language == .arabic ? "مراجع اللائحة (Grounding Citations):" : "Regulatory Citations:")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.blue)
                            
                            ForEach(message.citations) { citation in
                                CitationCardView(citation: citation, language: language)
                            }
                        }
                    }
                }
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(Color.primary.opacity(0.04))
                        .overlay(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .stroke(Color.primary.opacity(0.06), lineWidth: 1)
                        )
                )

                Spacer(minLength: 40)
            } else {
                Spacer(minLength: 40)
                
                Text(message.text)
                    .font(.system(size: 14.5, weight: .medium))
                    .foregroundColor(.white)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(LinearGradient(colors: [Color.blue, Color(red: 0.1, green: 0.4, blue: 0.9)], startPoint: .topLeading, endPoint: .bottomTrailing))
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

// MARK: - Voice Assistant Modal
struct VoiceAssistantModalView: View {
    @ObservedObject var aiService: CaptainAdelAIService
    let language: AppLanguage
    @Environment(\.dismiss) private var dismiss
    @State private var isListening: Bool = true
    @State private var recognizedSpeech: String = ""
    
    var body: some View {
        VStack(spacing: 30) {
            HStack {
                Spacer()
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.top, 20)
            .padding(.horizontal, 20)
            
            VStack(spacing: 8) {
                Text(language == .arabic ? "كابتن عادل يستمع إليك..." : "Captain Adel is listening...")
                    .font(.title2.weight(.bold))
                Text(language == .arabic ? "تحدث باللغة العربية أو الإنجليزية لسؤال عن الطيران" : "Speak in English or Arabic to ask any aviation question")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Audio Waveform Animation
            AudioWaveformView(isListening: isListening)
                .frame(height: 80)
            
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.15))
                    .frame(width: 100, height: 100)
                
                Button(action: {
                    isListening.toggle()
                }) {
                    ZStack {
                        Circle()
                            .fill(LinearGradient(colors: [.blue, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 80, height: 80)
                        Image(systemName: isListening ? "mic.fill" : "mic.slash.fill")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            
            Text(language == .arabic ? "اضغط للمقاطعة أو الإنهاء" : "Tap button to toggle mic")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Spacer()
        }
    }
}
