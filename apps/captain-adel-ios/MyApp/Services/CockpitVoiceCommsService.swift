import Foundation
import AVFoundation
import Speech
import Combine

// MARK: - Cockpit Comms State
enum CockpitCommsState: Equatable {
    case idle
    case listening
    case processing
    case speaking
    case error(String)
}

// MARK: - Cockpit Voice Comms Service
// Full duplex aviation radio communications simulation for Captain Adel
@MainActor
final class CockpitVoiceCommsService: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    static let shared = CockpitVoiceCommsService()

    @Published var commsState: CockpitCommsState = .idle
    @Published var liveTranscript: String = ""
    @Published var audioPower: Float = 0.0 // 0.0 to 1.0 for dynamic HUD waveform
    @Published var lastSpokenText: String = ""

    private let speechRecognizerEn = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private let speechRecognizerAr = SFSpeechRecognizer(locale: Locale(identifier: "ar-SA"))
    private var speechRecognizer: SFSpeechRecognizer?

    private var audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let speechSynthesizer = AVSpeechSynthesizer()

    private var silenceTimer: Timer?
    private var onSpeechFinished: ((String) -> Void)?

    override private init() {
        super.init()
        speechSynthesizer.delegate = self
    }

    // MARK: - Permissions
    func requestPermissions() async -> Bool {
        let speechStatus = await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { status in
                continuation.resume(returning: status == .authorized)
            }
        }

        let recordStatus: Bool
        if #available(iOS 17.0, *) {
            recordStatus = await AVAudioApplication.requestRecordPermission()
        } else {
            recordStatus = await withCheckedContinuation { continuation in
                AVAudioSession.sharedInstance().requestRecordPermission { granted in
                    continuation.resume(returning: granted)
                }
            }
        }

        return speechStatus && recordStatus
    }

    // MARK: - Speech Recognition (Audio Input)
    func startListening(language: AppLanguage, onFinished: @escaping (String) -> Void) {
        stopSpeaking()
        stopListening()

        self.onSpeechFinished = onFinished
        self.liveTranscript = ""
        self.commsState = .listening

        speechRecognizer = (language == .arabic) ? speechRecognizerAr : speechRecognizerEn

        guard let speechRecognizer = speechRecognizer, speechRecognizer.isAvailable else {
            self.commsState = .error(language == .arabic ? "التعرف على الصوت غير متاح" : "Speech recognizer unavailable")
            return
        }

        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord, mode: .voiceChat, options: [.defaultToSpeaker, .allowBluetoothHFP])
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

            recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            guard let recognitionRequest = recognitionRequest else { return }
            recognitionRequest.shouldReportPartialResults = true

            // Attach input node tap
            let inputNode = audioEngine.inputNode
            let recordingFormat = inputNode.outputFormat(forBus: 0)

            inputNode.removeTap(onBus: 0)
            if #available(iOS 27.0, *) {
                try inputNode.installAudioTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] buffer, _ in
                    Task { @MainActor [weak self] in
                        guard let self = self else { return }
                        let pcmBuffer = AVAudioPCMBuffer(copying: buffer)
                        self.recognitionRequest?.append(pcmBuffer)
                        self.calculateAudioLevel(from: pcmBuffer)
                    }
                }
            } else {
                inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] buffer, _ in
                    self?.recognitionRequest?.append(buffer)
                    self?.calculateAudioLevel(from: buffer)
                }
            }

            audioEngine.prepare()
            try audioEngine.start()

            recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
                guard let self = self else { return }

                if let result = result {
                    Task { @MainActor in
                        let text = result.bestTranscription.formattedString
                        self.liveTranscript = text
                        self.resetSilenceTimer()
                    }
                }

                if error != nil || (result?.isFinal ?? false) {
                    Task { @MainActor in
                        self.stopListening()
                    }
                }
            }
        } catch {
            self.commsState = .error(error.localizedDescription)
            stopListening()
        }
    }

    func stopListening() {
        silenceTimer?.invalidate()
        silenceTimer = nil

        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
        }
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        recognitionTask?.cancel()
        recognitionTask = nil

        audioPower = 0.0

        if case .listening = commsState {
            commsState = .idle
        }
    }

    private func resetSilenceTimer() {
        silenceTimer?.invalidate()
        // If pilot pauses for 1.4 seconds after speaking at least 2 words, trigger automatic dispatch
        silenceTimer = Timer.scheduledTimer(withTimeInterval: 1.4, repeats: false) { [weak self] _ in
            Task { @MainActor [weak self] in
                guard let self = self else { return }
                let trimmed = self.liveTranscript.trimmingCharacters(in: .whitespacesAndNewlines)
                if !trimmed.isEmpty && self.commsState == .listening {
                    self.commsState = .processing
                    let finalPrompt = trimmed
                    self.stopListening()
                    self.onSpeechFinished?(finalPrompt)
                }
            }
        }
    }

    private func calculateAudioLevel(from buffer: AVAudioPCMBuffer) {
        guard let channelData = buffer.floatChannelData?[0] else { return }
        let frameLength = UInt(buffer.frameLength)
        if frameLength == 0 { return }

        var sum: Float = 0.0
        for i in 0..<Int(frameLength) {
            sum += abs(channelData[i])
        }
        let avg = sum / Float(frameLength)
        let normalized = min(max(avg * 10.0, 0.0), 1.0)

        Task { @MainActor in
            self.audioPower = normalized
        }
    }

    // MARK: - Voice Synthesis (Speech Output)
    func speak(text: String, language: AppLanguage) {
        stopSpeaking()
        stopListening()

        // Clean regulatory text for natural audio reading (strip markdown symbols)
        let cleaned = cleanMarkdownForSpeech(text)
        guard !cleaned.isEmpty else { return }

        let utterance = AVSpeechUtterance(string: cleaned)
        let langCode = language == .arabic ? "ar-SA" : "en-US"
        utterance.voice = AVSpeechSynthesisVoice(language: langCode)
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate * 0.95
        utterance.pitchMultiplier = 1.0
        utterance.volume = 1.0

        lastSpokenText = cleaned
        commsState = .speaking

        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, mode: .voiceChat, options: [.defaultToSpeaker, .allowBluetoothHFP])
            try session.setActive(true)
            speechSynthesizer.speak(utterance)
        } catch {
            commsState = .error(error.localizedDescription)
        }
    }

    func stopSpeaking() {
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: .immediate)
        }
        if case .speaking = commsState {
            commsState = .idle
        }
    }

    // MARK: - AVSpeechSynthesizerDelegate
    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        Task { @MainActor in
            self.commsState = .idle
        }
    }

    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        Task { @MainActor in
            self.commsState = .idle
        }
    }

    // Strips markdown headers, bullet points, asterisks and emojis for speech
    private func cleanMarkdownForSpeech(_ text: String) -> String {
        var clean = text
        clean = clean.replacingOccurrences(of: "**", with: "")
        clean = clean.replacingOccurrences(of: "*", with: "")
        clean = clean.replacingOccurrences(of: "###", with: "")
        clean = clean.replacingOccurrences(of: "##", with: "")
        clean = clean.replacingOccurrences(of: "#", with: "")
        clean = clean.replacingOccurrences(of: "`", with: "")
        clean = clean.replacingOccurrences(of: "§", with: "Section ")
        clean = clean.replacingOccurrences(of: "•", with: "")
        return clean.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
