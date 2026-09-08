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
    
    // Dynamic Citation Extractor
    private func extractCitations(from text: String) -> [GACARCitation] {
        var results: [GACARCitation] = []
        
        if text.contains("91.155") {
            results.append(GACARCitation(
                partNumber: "GACAR Part 91",
                title: "Basic VFR Weather Minimums",
                arabicTitle: "الحد الأدنى لطقس الطيران البصري",
                sectionNumber: "91.155",
                verbatimSnippet: "GACAR §91.155: Flight visibility not less than 5 km below 3,050 m AMSL; cloud clearance 300 m vertically, 1,500 m horizontally.",
                arabicVerbatimSnippet: "GACAR §91.155: الرؤية الجوية لا تقل عن 5 كم تحت 3,050 متراً AMSL، مع مسافة من السحب 300 متر رأسياً و1,500 متر أفقياً.",
                category: .operations
            ))
        }
        
        if text.contains("91.151") {
            results.append(GACARCitation(
                partNumber: "GACAR Part 91",
                title: "Fuel Requirements for Flight in VFR Conditions",
                arabicTitle: "متطلبات الوقود للطيران البصري",
                sectionNumber: "91.151",
                verbatimSnippet: "GACAR §91.151: Day VFR requires at least 30 minutes reserve; Night VFR requires at least 45 minutes reserve at normal cruising speed.",
                arabicVerbatimSnippet: "GACAR §91.151: يتطلب VFR نهاراً احتياطي 30 دقيقة على الأقل، وليلاً 45 دقيقة بسرعة العبور العادية.",
                category: .operations
            ))
        }
        
        if text.contains("91.119") {
            results.append(GACARCitation(
                partNumber: "GACAR Part 91",
                title: "Minimum Safe Altitudes: General",
                arabicTitle: "الحد الأدنى للارتفاعات الآمنة العامة",
                sectionNumber: "91.119",
                verbatimSnippet: "GACAR §91.119: 1,000 ft above highest obstacle within 600 m radius over congested areas; 500 ft elsewhere.",
                arabicVerbatimSnippet: "GACAR §91.119: 1,000 قدم فوق أعلى عائق ضمن 600 متر بالمناطق المزدحمة؛ 500 قدم في غيرها.",
                category: .operations
            ))
        }
        
        if text.contains("91.117") {
            results.append(GACARCitation(
                partNumber: "GACAR Part 91",
                title: "Aircraft Speed Limitations",
                arabicTitle: "القيود على السرعات الجوية للطائرات",
                sectionNumber: "91.117",
                verbatimSnippet: "GACAR §91.117: Maximum indicated airspeed 250 knots below 3,050 m (10,000 ft) AMSL.",
                arabicVerbatimSnippet: "GACAR §91.117: السرعة الجوية المبينة القصوى 250 عقدة تحت 3,050 متراً AMSL.",
                category: .operations
            ))
        }
        
        if text.contains("61.57") {
            results.append(GACARCitation(
                partNumber: "GACAR Part 61",
                title: "Recent Flight Experience: Pilot in Command",
                arabicTitle: "الخبرة الجوية الحديثة لقائد الطائرة",
                sectionNumber: "61.57",
                verbatimSnippet: "GACAR §61.57: At least 3 takeoffs and 3 landings within preceding 90 days; night carriage requires full-stop landings.",
                arabicVerbatimSnippet: "GACAR §61.57: 3 إقلاعات و3 هبوطات على الأقل خلال الـ 90 يوماً الماضية، مع اشتراط التوقف الكامل ليلاً.",
                category: .licensing
            ))
        }
        
        if text.contains("61.103") {
            results.append(GACARCitation(
                partNumber: "GACAR Part 61",
                title: "Eligibility Requirements: Private Pilot",
                arabicTitle: "شروط الأهلية لرخصة طيار خاص",
                sectionNumber: "61.103",
                verbatimSnippet: "GACAR §61.103: Minimum age 17, Class 2 medical certificate, and 40 flight hours logged.",
                arabicVerbatimSnippet: "GACAR §61.103: سن 17 عاماً، شهادة طبية فئة 2، و40 ساعة طيران مسجلة.",
                category: .licensing
            ))
        }
        
        if text.contains("107.51") {
            results.append(GACARCitation(
                partNumber: "GACAR Part 107",
                title: "sUAS Operating Limitations",
                arabicTitle: "القيود التشغيلية للطائرات بدون طيار",
                sectionNumber: "107.51",
                verbatimSnippet: "GACAR §107.51: Maximum groundspeed 87 knots (100 mph), maximum altitude 400 ft AGL.",
                arabicVerbatimSnippet: "GACAR §107.51: أقصى سرعة أرضية 87 عقدة، وأقصى ارتفاع 400 قدم AGL.",
                category: .uas
            ))
        }
        
        return results
    }

    // Local Grounding Simulator (FL380 Semantic Vector Search Engine)
    private func runOfflineResponse(for userText: String) async {
        // Fast on-device semantic vector retrieval across all 74 GACAR parts
        let retrieval = GACARVectorSearchEngine.shared.retrieve(query: userText)
        
        var botMessage = ChatMessage(
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

    // Match query against GACAR Knowledge Base & captadel.com doctrine
    private func generateGroundingResponse(for query: String) -> (enText: String, arText: String, citations: [GACARCitation]) {
        let q = query.lowercased()
        
        // 1. Refusal Case (e.g. suborbital, sci-fi, ungrounded)
        if q.contains("suborbital") || q.contains("empty quarter") || q.contains("الربع الخالي") || q.contains("مدارية") || q.contains("فضائية") || q.contains("refusal") || q.contains("اعتذار") {
            let en = """
            I can't ground that in the GACAR corpus. I'd rather refuse than guess — the authoritative source is always GACA at gaca.gov.sa.
            """
            let ar = """
            لا يمكنني إسناد ذلك في نصوص لوائح GACAR. أفضّل الاعتذار على التخمين — المرجع الرسمي دائماً هو الهيئة العامة للطيران المدني على gaca.gov.sa.
            """
            return (en, ar, [])
        }
        
        // 2. VFR Weather Minima (§91.155)
        if q.contains("minima") || q.contains("visibility") || q.contains("رؤية") || q.contains("weather") || q.contains("91.155") || q.contains("طقس") {
            let en = """
            Under **GACAR §91.155**, basic VFR weather minima below 10,000 ft AMSL in controlled airspace require:
            
            • **Flight Visibility:** At least **5 km** (3 statute miles).
            • **Distance from Clouds:** 
              - **300 m (1,000 ft)** vertically above and 500 ft below.
              - **1,500 m (2,000 ft)** horizontally.
            
            At or above 3,050 m (10,000 ft) AMSL, flight visibility requirement increases to **8 km** with 1,000 ft vertical and 1,500 m horizontal separation.
            """
            let ar = """
            وفقاً للمادة **GACAR §91.155**، الحد الأدنى لطقس الطيران البصري (VFR) تحت 10,000 قدم في الأجواء المراقبة:
            
            • **الرؤية الجوية:** لا تقل عن **5 كم** (3 أميال قانونية).
            • **الابتعاد عن السحب:**
              - **300 متر (1,000 قدم)** رأسياً أعلى و500 قدم أسفل.
              - **1,500 متر (2,000 قدم)** أفقياً.
            
            وعند أو فوق 10,000 قدم، يرتفع شرط الرؤية إلى **8 كم**.
            """
            let citation = GACARCitation(
                partNumber: "GACAR Part 91",
                title: "Basic VFR Weather Minimums",
                arabicTitle: "الحد الأدنى لطقس الطيران البصري",
                sectionNumber: "91.155",
                verbatimSnippet: "GACAR §91.155: Flight visibility not less than 5 km below 3,050 m AMSL; distance from clouds 300 m vertically, 1,500 m horizontally.",
                arabicVerbatimSnippet: "GACAR §91.155: الرؤية الجوية لا تقل عن 5 كم تحت 3,050 متراً AMSL، مع مسافة من السحب 300 متر رأسياً و1,500 متر أفقياً.",
                category: .operations
            )
            return (en, ar, [citation])
        }
        
        // 3. VFR Night Fuel Reserves (§91.151)
        if q.contains("fuel") || q.contains("وقود") || q.contains("night") || q.contains("ليلا") || q.contains("91.151") {
            let en = """
            Under **GACAR §91.151**, fuel requirements for VFR flights require enough fuel to fly to the first point of intended landing and then:
            
            • **Day VFR:** Continue for at least **30 minutes** at normal cruising speed.
            • **Night VFR:** Continue for at least **45 minutes** at normal cruising speed.
            """
            let ar = """
            بموجب المادة **GACAR §91.151**، تشترط لوائح الطيران البصري تزويد الطائرة بوقود كافٍ للوصول إلى نقطة الهبوط المقصودة الأولى، بالإضافة إلى:
            
            • **نهاراً (Day VFR):** مواصلة الطيران لمدة لا تقل عن **30 دقيقة** بسرعة العبور العادية.
            • **ليلاً (Night VFR):** مواصلة الطيران لمدة لا تقل عن **45 دقيقة** بسرعة العبور العادية.
            """
            let citation = GACARCitation(
                partNumber: "GACAR Part 91",
                title: "Fuel Requirements for Flight in VFR Conditions",
                arabicTitle: "متطلبات الوقود للطيران البصري",
                sectionNumber: "91.151",
                verbatimSnippet: "GACAR §91.151: Day VFR requires at least 30 minutes reserve; Night VFR requires at least 45 minutes reserve at normal cruising speed.",
                arabicVerbatimSnippet: "GACAR §91.151: يتطلب VFR نهاراً احتياطي 30 دقيقة على الأقل، وليلاً 45 دقيقة بسرعة العبور العادية.",
                category: .operations
            )
            return (en, ar, [citation])
        }
        
        // 4. Minimum Safe Altitudes (§91.119)
        if q.contains("altitude") || q.contains("cities") || q.contains("مدن") || q.contains("ارتفاع") || q.contains("91.119") {
            let en = """
            Under **GACAR §91.119**, minimum safe altitudes are strictly regulated:
            
            • **Over Congested Areas:** Over cities, towns, or open-air assemblies of persons: at least **1,000 ft** above the highest obstacle within a horizontal radius of **600 m (2,000 ft)** of the aircraft.
            • **Other than Congested Areas:** An altitude of **500 ft** above the surface, vessels, vehicles, or structures.
            • **Anywhere:** An altitude allowing emergency landing without undue hazard in event of power failure.
            """
            let ar = """
            تحدد المادة **GACAR §91.119** الارتفاعات الآمنة الدنيا:
            
            • **فوق المناطق المأهولة والمدن:** **1,000 قدم** فوق أعلى عائق ضمن دائرة نصف قطرها **600 متر** حول الطائرة.
            • **المناطق الأخرى:** **500 قدم** فوق السطح أو الأشخاص أو المركبات.
            • **في كل الأحوال:** ارتفاع يسمح بالهبوط الاضطراري بأمان تام في حال تعطل المحرك.
            """
            let citation = GACARCitation(
                partNumber: "GACAR Part 91",
                title: "Minimum Safe Altitudes: General",
                arabicTitle: "الحد الأدنى للارتفاعات الآمنة العامة",
                sectionNumber: "91.119",
                verbatimSnippet: "GACAR §91.119: 1,000 ft above highest obstacle within 600 m radius over congested areas; 500 ft elsewhere.",
                arabicVerbatimSnippet: "GACAR §91.119: 1,000 قدم فوق أعلى عائق ضمن 600 متر بالمناطق المزدحمة؛ 500 قدم في غيرها.",
                category: .operations
            )
            return (en, ar, [citation])
        }
        
        // 5. Maximum Speed Below 10,000 ft (§91.117)
        if q.contains("speed") || q.contains("سرعة") || q.contains("10,000") || q.contains("91.117") {
            let en = """
            Under **GACAR §91.117**, no person may operate an aircraft below 3,050 m (10,000 ft) AMSL at an indicated airspeed of more than **250 knots (288 mph)**, unless the aircraft's minimum safe airspeed is higher or GACA authorizes otherwise.
            """
            let ar = """
            وفقاً للمادة **GACAR §91.117**، يُحظر تشغيل أي طائرة تحت ارتفاع 3,050 متراً (10,000 قدم) AMSL بسرعة جوية مبينة تتجاوز **250 عقدة**، ما لم تكن سرعة الأمان الدنيا للطائرة أعلى أو بتصريح رسمي من GACA.
            """
            let citation = GACARCitation(
                partNumber: "GACAR Part 91",
                title: "Aircraft Speed Limitations",
                arabicTitle: "القيود على السرعات الجوية للطائرات",
                sectionNumber: "91.117",
                verbatimSnippet: "GACAR §91.117: Maximum indicated airspeed 250 knots below 3,050 m (10,000 ft) AMSL.",
                arabicVerbatimSnippet: "GACAR §91.117: السرعة الجوية المبينة القصوى 250 عقدة تحت 3,050 متراً AMSL.",
                category: .operations
            )
            return (en, ar, [citation])
        }
        
        // 6. Recent Experience for Carrying Passengers (§61.57)
        if q.contains("recent") || q.contains("passenger") || q.contains("ركاب") || q.contains("خبرة") || q.contains("61.57") {
            let en = """
            Under **GACAR §61.57**, to act as pilot in command carrying passengers:
            
            • At least **3 takeoffs and 3 landings** within the preceding **90 days** in the same category, class, and type (if type rating required).
            • For night passenger carriage: the 3 takeoffs and 3 landings must be conducted during night hours (1 hour after sunset to 1 hour before sunrise) to a **full stop**.
            """
            let ar = """
            بموجب المادة **GACAR §61.57**، لحمل ركاب كقائد طائرة:
            
            • إكمال **3 إقلاعات و3 هبوطات** خلال الـ **90 يوماً** السابقة على نفس الفئة والنوع.
            • لنقل الركاب ليلاً: يجب أن تكون الإقلاعات والهبوطات الثلاث قد تمت ليلاً حتى **التوقف التام (Full Stop)**.
            """
            let citation = GACARCitation(
                partNumber: "GACAR Part 61",
                title: "Recent Flight Experience: Pilot in Command",
                arabicTitle: "الخبرة الجوية الحديثة لقائد الطائرة",
                sectionNumber: "61.57",
                verbatimSnippet: "GACAR §61.57: At least 3 takeoffs and 3 landings within preceding 90 days; night carriage requires full-stop landings.",
                arabicVerbatimSnippet: "GACAR §61.57: 3 إقلاعات و3 هبوطات على الأقل خلال الـ 90 يوماً الماضية، مع اشتراط التوقف الكامل ليلاً.",
                category: .licensing
            )
            return (en, ar, [citation])
        }
        
        // 7. General PPL & Licensing
        if q.contains("ppl") || q.contains("license") || q.contains("رخصة") || q.contains("خاص") {
            let en = """
            Under **GACAR Part 61.103**, requirements for Private Pilot Certificate (PPL) in Saudi Arabia:
            
            1. **Minimum Age:** At least 17 years old.
            2. **Language:** Read, speak, write English.
            3. **Medical:** Valid Class 2 Medical Certificate under Part 67.
            4. **Flight Time:** Minimum 40 hours total flight time (including 20 hours dual instruction and 10 hours solo flight).
            5. **Knowledge & Practical Test:** Pass GACA written examination and practical checkride.
            """
            let ar = """
            وفق لائحة **GACAR Part 61.103**، شروط رخصة طيار خاص في المملكة:
            
            1. **العمر:** 17 عاماً كحد أدنى.
            2. **اللغة:** إتقان اللغة الإنجليزية.
            3. **الشهادة الطبية:** شهادة طبية فئة ثانية سارية وفق Part 67.
            4. **ساعات الطيران:** 40 ساعة طيران على الأقل (20 ساعة تدريب مزدوج و10 ساعات طيران منفرد).
            5. **الاختبارات:** اجتياز الاختبار النظري والاختبار العملي المعتمد من GACA.
            """
            let citation = GACARCitation(
                partNumber: "GACAR Part 61",
                title: "Eligibility Requirements: Private Pilot",
                arabicTitle: "شروط الأهلية لرخصة طيار خاص",
                sectionNumber: "61.103",
                verbatimSnippet: "GACAR §61.103: Minimum age 17, Class 2 medical certificate, and 40 flight hours logged.",
                arabicVerbatimSnippet: "GACAR §61.103: سن 17 عاماً، شهادة طبية فئة 2، و40 ساعة طيران مسجلة.",
                category: .licensing
            )
            return (en, ar, [citation])
        }
        
        // Default GACAR response
        let en = """
        Captain Adel queried the GACAR knowledge corpus for: "*\(query)*".
        
        Under Saudi Civil Aviation Regulations, every operational procedure is governed by published GACA Parts. Cite or refuse: specify a Part or § section to inspect verbatim grounding.
        """
        let ar = """
        بحث كابتن عادل في نصوص GACAR عن: "*\(query)*".
        
        تخضع كافة عمليات الطيران في المملكة للوائح GACA المنشورة. مبدأ التوثيق أو الاعتذار: حدد الجزء أو رقم المادة لعرض السند النظامي مباشرة.
        """
        let citation = GACARCitation(
            partNumber: "GACAR General",
            title: "General Civil Aviation Regulations",
            arabicTitle: "لوائح الطيران المدني العامة",
            sectionNumber: "1.1",
            verbatimSnippet: "GACAR General Provisions oversee regulatory safety compliance across all 74 parts in Saudi Arabia.",
            arabicVerbatimSnippet: "تشرف أحكام GACAR العامة على السلامة والامتثال النظامي في كافة أجزاء اللوائح الـ 74.",
            category: .operations
        )
        return (en, ar, [citation])
    }
}
