import Foundation
import SwiftUI
import Combine
import Speech
import AVFoundation

/// Comms state in the cockpit voice assistant
enum CommsState: Equatable {
    case idle
    case listening
    case processing
    case speaking
    case error(String)
}

/// Hands-Free Cockpit Voice Service utilizing Apple's Speech & AVFoundation frameworks
@MainActor
final class CockpitVoiceCommsService: NSObject, ObservableObject {
    static let shared = CockpitVoiceCommsService()

    @Published var commsState: CommsState = .idle
    @Published var liveTranscript: String = ""
    @Published var lastSpokenText: String = ""
    @Published var audioPower: Float = 0.0
    @Published var isPermissionGranted: Bool = false

    private var speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private let speechSynthesizer = AVSpeechSynthesizer()

    private var silenceTimer: Timer?
    private var onSpeechFinished: ((String) -> Void)?

    override init() {
        super.init()
        speechSynthesizer.delegate = self
    }

    // MARK: - Permissions
    func requestPermissions() async -> Bool {
        let speechAuth = await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { status in
                continuation.resume(returning: status == .authorized)
            }
        }

        let audioAuth: Bool
        if #available(iOS 17.0, *) {
            audioAuth = await AVAudioApplication.requestRecordPermission()
        } else {
            audioAuth = await withCheckedContinuation { continuation in
                AVAudioSession.sharedInstance().requestRecordPermission { granted in
                    continuation.resume(returning: granted)
                }
            }
        }

        let granted = speechAuth && audioAuth
        self.isPermissionGranted = granted
        return granted
    }

    // MARK: - Speech Recognition (Listening)
    func startListening(
        language: AppLanguage,
        onSilenceDetected: @escaping (String) -> Void
    ) {
        // Stop any ongoing speech playback or active task
        stopSpeaking()
        stopListening()

        self.onSpeechFinished = onSilenceDetected
        self.liveTranscript = ""
        self.commsState = .listening

        let locale = language == .arabic ? Locale(identifier: "ar-SA") : Locale(identifier: "en-US")
        speechRecognizer = SFSpeechRecognizer(locale: locale)

        guard let speechRecognizer = speechRecognizer, speechRecognizer.isAvailable else {
            self.commsState = .error(language == .arabic ? "التعرف على الصوت غير متاح" : "Speech recognizer unavailable")
            return
        }

        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord, mode: .voiceChat, options: [.defaultToSpeaker, .allowBluetooth])
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

            recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            guard let recognitionRequest = recognitionRequest else { return }
            recognitionRequest.shouldReportPartialResults = true

            // Attach input node tap
            let inputNode = audioEngine.inputNode
            let recordingFormat = inputNode.outputFormat(forBus: 0)

            inputNode.removeTap(onBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] buffer, _ in
                self?.recognitionRequest?.append(buffer)
                self?.calculateAudioLevel(from: buffer)
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

        if commsState == .listening {
            commsState = .idle
        }
        audioPower = 0.0
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
            try session.setCategory(.playback, mode: .voicePrompt, options: [.duckOthers, .defaultToSpeaker])
            try session.setActive(true)
        } catch {
            print("Audio session configuration error: \(error)")
        }

        speechSynthesizer.speak(utterance)
    }

    func stopSpeaking() {
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: .immediate)
        }
        if commsState == .speaking {
            commsState = .idle
        }
    }

    private func cleanMarkdownForSpeech(_ text: String) -> String {
        var clean = text
        // Remove bold/italics
        clean = clean.replacingOccurrences(of: "**", with: "")
        clean = clean.replacingOccurrences(of: "*", with: "")
        clean = clean.replacingOccurrences(of: "#", with: "")
        clean = clean.replacingOccurrences(of: "`", with: "")
        clean = clean.replacingOccurrences(of: "§", with: "Section ")
        // Keep text concise for radio transmission (limit to first 450 characters if too long)
        if clean.count > 450 {
            let prefix = String(clean.prefix(450))
            if let lastPeriod = prefix.lastIndex(of: ".") {
                clean = String(prefix[...lastPeriod])
            } else {
                clean = prefix + "..."
            }
        }
        return clean.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

// MARK: - AVSpeechSynthesizerDelegate
extension CockpitVoiceCommsService: AVSpeechSynthesizerDelegate {
    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        Task { @MainActor in
            if self.commsState == .speaking {
                self.commsState = .idle
            }
        }
    }

    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        Task { @MainActor in
            if self.commsState == .speaking {
                self.commsState = .idle
            }
        }
    }
}
