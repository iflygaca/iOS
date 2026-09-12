import SwiftUI
import Combine
import Foundation

@MainActor
final class CaptainAdelAIService: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var isThinking: Bool = false
    @Published var activeLanguage: AppLanguage = .english
    
    // AI Configuration & Live Telemetry
    @Published var config: AIProviderConfig
    @Published var connectionStatus: AIConnectionStatus = .offline
    @Published var fallbackBannerReason: String? = nil
    @Published var isFL380FlightMode: Bool = false
    
    private let configStorageKey = "com.flygaca.captainadel.aiconfig"
    private let fl380StorageKey = "com.flygaca.captainadel.fl380mode"
    
    // Complete 74-Part Saudi Civil Aviation Corpus
    var gacarParts: [GACARPart] {
        GACARCorpusDatabase.allParts
    }
    
    init() {
        // Load saved configuration & FL380 state
        if let savedData = UserDefaults.standard.data(forKey: "com.flygaca.captainadel.aiconfig"),
           let decoded = try? JSONDecoder().decode(AIProviderConfig.self, from: savedData) {
            self.config = decoded
        } else {
            self.config = .default
        }
        
        self.isFL380FlightMode = UserDefaults.standard.bool(forKey: fl380StorageKey)
        self.connectionStatus = (self.isFL380FlightMode || self.config.provider == .offlineDoctrine) ? .offline : .connecting
        
        // Welcome message reflecting captadel.com doctrine
        let welcomeEn = """
        Captain Adel (**ADEL-1**) online. Independent AI flight instructor for Saudi civil aviation.

        Ask any GACAR question and get the exact Part and section cited — or an honest refusal, never an invented guess.
        """
        
        let welcomeAr = """
        كابتن عادل (**ADEL-1**) متصل. مدرّب الطيران الذكي للوائح الطيران المدني السعودي (GACAR).

        اطرح أي سؤال في لوائح GACAR لتحصل على رقم الجزء والفقرة النظامية الدقيقة — أو اعتذار صريح دون أي تخمين.
        """
        
        let welcomeMsg = ChatMessage(
            sender: .captainAdel,
            text: welcomeEn,
            arabicText: welcomeAr,
            citations: [
                GACARCitation(
                    partNumber: "GACAR Part 91",
                    title: "General Operating and Flight Rules",
                    arabicTitle: "قواعد التشغيل والطيران العامة",
                    sectionNumber: "91.155",
                    verbatimSnippet: "GACAR §91.155 governs basic VFR weather minimums and flight visibility in Saudi airspace.",
                    arabicVerbatimSnippet: "تحدد المادة GACAR §91.155 الحد الأدنى لطقس الطيران البصري والرؤية الجوية في الأجواء السعودية.",
                    category: .operations
                )
            ]
        )
        
        messages.append(welcomeMsg)
        
        if config.provider != .offlineDoctrine {
            Task {
                await checkConnectionHealth()
            }
        }
    }
    
    // Update and persist settings
    func updateConfig(_ newConfig: AIProviderConfig, apiKey: String?) {
        self.config = newConfig
        if let encoded = try? JSONEncoder().encode(newConfig) {
            UserDefaults.standard.set(encoded, forKey: configStorageKey)
        }
        
        let keychainKey = "ai_api_key_\(newConfig.provider.rawValue)"
        if let key = apiKey, !key.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            KeychainHelper.shared.save(key: keychainKey, value: key.trimmingCharacters(in: .whitespacesAndNewlines))
        } else {
            KeychainHelper.shared.delete(key: keychainKey)
        }
        
        self.fallbackBannerReason = nil
        if newConfig.provider == .offlineDoctrine {
            self.connectionStatus = .offline
        } else {
            Task {
                await checkConnectionHealth()
            }
        }
    }
    
    func toggleFL380FlightMode() {
        isFL380FlightMode.toggle()
        UserDefaults.standard.set(isFL380FlightMode, forKey: fl380StorageKey)
        if isFL380FlightMode {
            self.connectionStatus = .offline
            self.fallbackBannerReason = nil
        } else {
            if config.provider != .offlineDoctrine {
                Task {
                    await checkConnectionHealth()
                }
            } else {
                self.connectionStatus = .offline
            }
        }
    }
    
    func getApiKey(for provider: AIProviderType) -> String? {
        return KeychainHelper.shared.get(key: "ai_api_key_\(provider.rawValue)")
    }
    
    // Check connection health / ping
    func checkConnectionHealth() async {
        guard config.provider != .offlineDoctrine else {
            self.connectionStatus = .offline
            return
        }
        
        self.connectionStatus = .connecting
        let apiKey = getApiKey(for: config.provider)
        let result = await testConnection(config: self.config, apiKey: apiKey)
        if result.success {
            self.connectionStatus = .connected(latencyMs: result.latencyMs)
        } else {
            self.connectionStatus = .fallback(reason: result.message)
        }
    }
    
    // Test connection without mutating state
    func testConnection(config: AIProviderConfig, apiKey: String?) async -> (success: Bool, latencyMs: Int, message: String) {
        guard config.provider != .offlineDoctrine else {
            return (true, 1, "Offline GACAR Doctrine active. Zero latency.")
        }
        
        guard let url = URL(string: config.endpointURL), url.scheme != nil, url.host != nil else {
            return (false, 0, "Invalid endpoint URL format")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 8
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = apiKey, !token.isEmpty {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // Minimal ping payload
        let pingPayload: [String: Any] = [
            "model": config.modelName,
            "messages": [
                ["role": "user", "content": "ping"]
            ],
            "max_tokens": 1
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: pingPayload)
        
        let start = CFAbsoluteTimeGetCurrent()
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            let elapsed = Int((CFAbsoluteTimeGetCurrent() - start) * 1000)
            if let http = response as? HTTPURLResponse {
                if (200...299).contains(http.statusCode) {
                    return (true, max(1, elapsed), "Connected (HTTP \(http.statusCode))")
                } else if http.statusCode == 401 {
                    return (false, elapsed, "Authentication failed (401 Unauthorized). Check API Key.")
                } else {
                    return (false, elapsed, "Server returned HTTP \(http.statusCode)")
                }
            }
            return (true, max(1, elapsed), "Connected")
        } catch {
            let elapsed = Int((CFAbsoluteTimeGetCurrent() - start) * 1000)
            return (false, elapsed, error.localizedDescription)
        }
    }

    // Main Chat Message Sending
    func sendMessage(_ userText: String) async {
        guard !userText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let userMessage = ChatMessage(sender: .user, text: userText)
        messages.append(userMessage)
        
        isThinking = true
        
        // 1. If FL380 Flight Mode or Offline Doctrine mode selected, run on-device vector retrieval
        if isFL380FlightMode || config.provider == .offlineDoctrine {
            await runOfflineResponse(for: userText)
            return
        }
        
        // 2. Online Mode: Try live stream; fallback to local grounding on failure
        do {
            try await runLiveStreamingResponse(for: userText)
        } catch {
            // Seamless offline fallback
            self.fallbackBannerReason = "Cloud unavailable (\(error.localizedDescription)). Switched to local GACAR engine."
            self.connectionStatus = .fallback(reason: error.localizedDescription)
            await runOfflineResponse(for: userText)
        }
    }
    
    // Live Server-Sent Events / Stream Runner
    private func runLiveStreamingResponse(for query: String) async throws {
        guard let url = URL(string: config.endpointURL) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 25
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = getApiKey(for: config.provider), !token.isEmpty {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let systemPrompt = """
        You are Captain Adel (ADEL-1), an authoritative AI flight instructor for Saudi civil aviation (GACAR).
        DOCTRINE: CITE OR REFUSE.
        Every statement must explicitly cite the GACAR Part and Section (e.g. §91.155, §61.103, §107.51).
        If a question cannot be grounded in GACAR regulations, refuse honestly and direct the user to gaca.gov.sa instead of guessing.
        """
        
        let payload: [String: Any] = [
            "model": config.modelName,
            "messages": [
                ["role": "system", "content": systemPrompt],
                ["role": "user", "content": query]
            ],
            "temperature": config.temperature,
            "stream": true
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: payload)
        
        let (asyncBytes, response) = try await URLSession.shared.bytes(for: request)
        
        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            throw NSError(domain: "CaptainAdelAI", code: http.statusCode, userInfo: [NSLocalizedDescriptionKey: "HTTP \(http.statusCode)"])
        }
        
        let botMessage = ChatMessage(
            sender: .captainAdel,
            text: "",
            arabicText: "",
            citations: [],
            isStreaming: true
        )
        messages.append(botMessage)
        isThinking = false
        
        var accumulatedText = ""
        
        for try await line in asyncBytes.lines {
            let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty else { continue }
            
            if trimmed.hasPrefix("data: ") {
                let dataContent = String(trimmed.dropFirst(6)).trimmingCharacters(in: .whitespacesAndNewlines)
                if dataContent == "[DONE]" { break }
                
                if let data = dataContent.data(using: .utf8),
                   let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    
                    // OpenAI-style choices delta
                    if let choices = json["choices"] as? [[String: Any]],
                       let first = choices.first,
                       let delta = first["delta"] as? [String: Any],
                       let chunk = delta["content"] as? String {
                        accumulatedText += chunk
                    }
                    // Hugging Face token text style
                    else if let tokenObj = json["token"] as? [String: Any],
                            let chunk = tokenObj["text"] as? String {
                        accumulatedText += chunk
                    }
                }
            } else if let data = trimmed.data(using: .utf8),
                      let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                      let chunk = json["text"] as? String {
                accumulatedText += chunk
            }
            
            // Extract citations dynamically as text arrives
            let citations = extractCitations(from: accumulatedText)
            
            if let lastIdx = messages.indices.last {
                messages[lastIdx].text = accumulatedText
                messages[lastIdx].arabicText = accumulatedText
                messages[lastIdx].citations = citations
            }
        }
        
        if let lastIdx = messages.indices.last {
            messages[lastIdx].isStreaming = false
        }
    }
    
    // Dynamic Citation Extractor against the complete 74-Part GACAR Database
    func extractCitations(from text: String) -> [GACARCitation] {
        var results: [GACARCitation] = []
        var matchedCodes: Set<String> = []

        for part in GACARCorpusDatabase.allParts {
            for section in part.keySections {
                // Fast substring pre-filter
                guard text.contains(section.sectionCode), !matchedCodes.contains(section.sectionCode) else {
                    continue
                }

                // Strict boundary check to prevent false positives (e.g., '1.1' inside '91.155')
                let escapedCode = NSRegularExpression.escapedPattern(for: section.sectionCode)
                let pattern = "(?<![A-Za-z0-9])" + escapedCode + "(?![A-Za-z0-9]|(?:\\.\\d))"
                guard let regex = try? NSRegularExpression(pattern: pattern),
                      regex.firstMatch(in: text, range: NSRange(text.startIndex..., in: text)) != nil else {
                    continue
                }

                matchedCodes.insert(section.sectionCode)
                results.append(GACARCitation(
                    partNumber: part.partNumber,
                    title: section.titleEn,
                    arabicTitle: section.titleAr,
                    sectionNumber: section.sectionCode,
                    verbatimSnippet: "\(part.partNumber) §\(section.sectionCode): \(section.contentEn)",
                    arabicVerbatimSnippet: "\(part.partNumber) §\(section.sectionCode): \(section.contentAr)",
                    category: part.category
                ))
                if results.count >= 4 { break }
            }
            if results.count >= 4 { break }
        }

        return results
    }

    // Local Grounding Simulator (FL380 Semantic Vector Search Engine)
    private func runOfflineResponse(for userText: String) async {
        // Fast on-device semantic vector retrieval across all 74 GACAR parts
        let retrieval = GACARVectorSearchEngine.shared.retrieve(query: userText)
        
        let botMessage = ChatMessage(
            sender: .captainAdel,
            text: "",
            arabicText: "",
            citations: retrieval.citations,
            isStreaming: true,
            telemetryTag: retrieval.telemetryTag
        )
        messages.append(botMessage)
        isThinking = false

        // Stream text chunk by chunk with avionics typewriter cadence
        let targetEnText = retrieval.answerEn
        let targetArText = retrieval.answerAr
        let step = 6
        
        var currentEnIndex = 0
        var currentArIndex = 0
        
        while currentEnIndex < targetEnText.count || currentArIndex < targetArText.count {
            currentEnIndex = min(currentEnIndex + step, targetEnText.count)
            currentArIndex = min(currentArIndex + step, targetArText.count)
            
            let enSubstring = String(targetEnText.prefix(currentEnIndex))
            let arSubstring = String(targetArText.prefix(currentArIndex))
            
            if let lastIdx = messages.indices.last {
                messages[lastIdx].text = enSubstring
                messages[lastIdx].arabicText = arSubstring
            }
            
            try? await Task.sleep(nanoseconds: 12_000_000)
        }
        
        if let lastIdx = messages.indices.last {
            messages[lastIdx].isStreaming = false
        }
    }
}

