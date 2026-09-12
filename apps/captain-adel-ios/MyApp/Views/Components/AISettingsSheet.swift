import SwiftUI

struct AISettingsSheet: View {
    @ObservedObject var aiService: CaptainAdelAIService
    @Binding var isPresented: Bool
    
    @State private var selectedProvider: AIProviderType
    @State private var endpointURL: String
    @State private var modelName: String
    @State private var apiKey: String = ""
    @State private var showApiKey: Bool = false
    @State private var isTesting: Bool = false
    @State private var testResult: (success: Bool, message: String)? = nil
    
    init(aiService: CaptainAdelAIService, isPresented: Binding<Bool>) {
        self.aiService = aiService
        self._isPresented = isPresented
        self._selectedProvider = State(initialValue: aiService.config.provider)
        self._endpointURL = State(initialValue: aiService.config.endpointURL.isEmpty ? aiService.config.provider.defaultEndpoint : aiService.config.endpointURL)
        self._modelName = State(initialValue: aiService.config.modelName.isEmpty ? aiService.config.provider.defaultModel : aiService.config.modelName)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                AvionicsTheme.bg.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        headerBanner
                        fl380SwitchSection
                        providerSelectionSection
                        
                        if selectedProvider != .offlineDoctrine {
                            onlineParametersSection
                        } else {
                            offlineDoctrineSection
                        }
                        
                        actionButtonsSection
                    }
                    .padding(16)
                }
            }
            .navigationTitle("COMMS CONFIG")
            .navigationBarTitleDisplayModeInline()
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("CLOSE") {
                        isPresented = false
                    }
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundColor(AvionicsTheme.cyan)
                }
            }
        }
        .onAppear {
            apiKey = aiService.getApiKey(for: selectedProvider) ?? ""
        }
    }
    
    // MARK: - Subviews
    
    private var headerBanner: some View {
        HStack(spacing: 8) {
            Image(systemName: "antenna.radiowaves.left.and.right")
                .foregroundColor(AvionicsTheme.cyan)
                .font(.system(size: 14, weight: .bold))
            Text("COMMS LINK // AI BACKEND ENGINE")
                .font(.system(size: 11, weight: .bold, design: .monospaced))
                .foregroundColor(AvionicsTheme.cyan)
            Spacer()
            Text("GACAR RAG")
                .font(.system(size: 9, weight: .bold, design: .monospaced))
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(AvionicsTheme.panel2)
                .foregroundColor(AvionicsTheme.teal)
                .cornerRadius(3)
        }
        .padding(.bottom, 2)
    }
    
    private var fl380SwitchSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                HStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(aiService.isFL380FlightMode ? AvionicsTheme.cyan.opacity(0.2) : AvionicsTheme.panel2)
                            .frame(width: 32, height: 32)
                        Image(systemName: "airplane")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(aiService.isFL380FlightMode ? AvionicsTheme.cyan : AvionicsTheme.inkDim)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("FL380 FLIGHT MODE")
                            .font(.system(size: 12, weight: .heavy, design: .monospaced))
                            .foregroundColor(AvionicsTheme.ink)
                        Text("100% Offline Semantic Vector Search")
                            .font(.system(size: 10, weight: .medium, design: .monospaced))
                            .foregroundColor(aiService.isFL380FlightMode ? AvionicsTheme.mint : AvionicsTheme.inkDim)
                    }
                }
                
                Spacer()
                
                Toggle("", isOn: Binding(
                    get: { aiService.isFL380FlightMode },
                    set: { _ in
                        Haptics.impact()
                        withAnimation(.spring(response: 0.3)) {
                            aiService.toggleFL380FlightMode()
                        }
                    }
                ))
                .labelsHidden()
                .tint(AvionicsTheme.cyan)
            }
            
            HStack(spacing: 6) {
                Text("CORPUS: 74 PARTS")
                    .font(.system(size: 8.5, weight: .bold, design: .monospaced))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(AvionicsTheme.panel2)
                    .foregroundColor(AvionicsTheme.cyan)
                    .cornerRadius(3)
                
                Text("LATENCY: < 5MS")
                    .font(.system(size: 8.5, weight: .bold, design: .monospaced))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(AvionicsTheme.panel2)
                    .foregroundColor(AvionicsTheme.mint)
                    .cornerRadius(3)
                
                Text(aiService.isFL380FlightMode ? "DATA: OFFLINE" : "DATA: READY")
                    .font(.system(size: 8.5, weight: .bold, design: .monospaced))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(AvionicsTheme.panel2)
                    .foregroundColor(aiService.isFL380FlightMode ? AvionicsTheme.mint : AvionicsTheme.amber)
                    .cornerRadius(3)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(aiService.isFL380FlightMode ? AvionicsTheme.panel2 : AvionicsTheme.panel)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(aiService.isFL380FlightMode ? AvionicsTheme.cyan.opacity(0.8) : AvionicsTheme.line, lineWidth: 1.2)
                )
        )
    }
    
    private var providerSelectionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("SELECT PRIMARY ENGINE")
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundColor(AvionicsTheme.inkDim)
            
            VStack(spacing: 6) {
                ForEach(AIProviderType.allCases) { provider in
                    providerRow(for: provider)
                }
            }
        }
    }
    
    private func providerRow(for provider: AIProviderType) -> some View {
        let isSelected = (selectedProvider == provider)
        let strokeColor = isSelected ? AvionicsTheme.teal : AvionicsTheme.line
        let bgColor = isSelected ? AvionicsTheme.panel2 : AvionicsTheme.panel
        let titleColor = isSelected ? AvionicsTheme.ink : AvionicsTheme.inkDim
        let badgeBg = isSelected ? AvionicsTheme.cyan.opacity(0.15) : AvionicsTheme.panel2
        let badgeFg = isSelected ? AvionicsTheme.cyan : AvionicsTheme.inkDim
        
        return Button(action: {
            withAnimation(.spring(response: 0.25)) {
                selectedProvider = provider
                endpointURL = provider.defaultEndpoint
                modelName = provider.defaultModel
                apiKey = aiService.getApiKey(for: provider) ?? ""
                testResult = nil
            }
        }) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .stroke(isSelected ? AvionicsTheme.cyan : AvionicsTheme.line, lineWidth: 1.5)
                        .frame(width: 16, height: 16)
                    if isSelected {
                        Circle()
                            .fill(AvionicsTheme.cyan)
                            .frame(width: 8, height: 8)
                    }
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text(provider.displayName)
                            .font(.system(size: 13, weight: .bold, design: .monospaced))
                            .foregroundColor(titleColor)
                        Spacer()
                        Text(provider.shortBadge)
                            .font(.system(size: 8.5, weight: .heavy, design: .monospaced))
                            .padding(.horizontal, 5)
                            .padding(.vertical, 2)
                            .background(badgeBg)
                            .foregroundColor(badgeFg)
                            .cornerRadius(3)
                    }
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(bgColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(strokeColor, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(.plain)
    }
    
    private var onlineParametersSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Endpoint URL Field
            VStack(alignment: .leading, spacing: 4) {
                Text("ENDPOINT URL")
                    .font(.system(size: 9.5, weight: .bold, design: .monospaced))
                    .foregroundColor(AvionicsTheme.inkDim)
                TextField("https://...", text: $endpointURL)
                    .font(.system(size: 12, design: .monospaced))
                    .padding(10)
                    .background(AvionicsTheme.panel2)
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(AvionicsTheme.line, lineWidth: 1)
                    )
                    .foregroundColor(AvionicsTheme.ink)
                    .autocorrectionDisabled()
                    .disableAutocapitalization()
            }
            
            // Model Name Field
            VStack(alignment: .leading, spacing: 4) {
                Text("TARGET MODEL REPOSITORY")
                    .font(.system(size: 9.5, weight: .bold, design: .monospaced))
                    .foregroundColor(AvionicsTheme.inkDim)
                TextField("e.g. flygaca/CaptAdel", text: $modelName)
                    .font(.system(size: 12, design: .monospaced))
                    .padding(10)
                    .background(AvionicsTheme.panel2)
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(AvionicsTheme.line, lineWidth: 1)
                    )
                    .foregroundColor(AvionicsTheme.ink)
                    .autocorrectionDisabled()
                    .disableAutocapitalization()
            }
            
            // API Key with Keychain indication
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("API TOKEN / KEY")
                        .font(.system(size: 9.5, weight: .bold, design: .monospaced))
                        .foregroundColor(AvionicsTheme.inkDim)
                    Spacer()
                    HStack(spacing: 3) {
                        Image(systemName: "lock.shield.fill")
                            .font(.system(size: 9))
                        Text("SECURED IN KEYCHAIN")
                            .font(.system(size: 8, weight: .bold, design: .monospaced))
                    }
                    .foregroundColor(AvionicsTheme.mint)
                }
                
                HStack {
                    if showApiKey {
                        TextField("hf_... or Bearer Token", text: $apiKey)
                            .font(.system(size: 12, design: .monospaced))
                    } else {
                        SecureField("hf_... or Bearer Token", text: $apiKey)
                            .font(.system(size: 12, design: .monospaced))
                    }
                    
                    Button(action: { showApiKey.toggle() }) {
                        Image(systemName: showApiKey ? "eye.slash" : "eye")
                            .foregroundColor(AvionicsTheme.inkDim)
                            .font(.system(size: 12))
                    }
                }
                .padding(10)
                .background(AvionicsTheme.panel2)
                .cornerRadius(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(AvionicsTheme.line, lineWidth: 1)
                )
                .foregroundColor(AvionicsTheme.ink)
                .autocorrectionDisabled()
                .disableAutocapitalization()
            }
            
            // Ping / Test Comms Button
            Button(action: runPingTest) {
                HStack {
                    if isTesting {
                        ProgressView()
                            .tint(AvionicsTheme.cyan)
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: "waveform.path.ecg")
                    }
                    Text(isTesting ? "PINGING COMMS LINK..." : "TEST COMMS / PING LATENCY")
                }
                .font(.system(size: 11, weight: .bold, design: .monospaced))
                .foregroundColor(AvionicsTheme.cyan)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(AvionicsTheme.cyan.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(AvionicsTheme.cyan.opacity(0.3), lineWidth: 1)
                        )
                )
            }
            .disabled(isTesting)
            
            // Test Result Feedback
            if let result = testResult {
                HStack(spacing: 8) {
                    Image(systemName: result.success ? "checkmark.shield.fill" : "exclamationmark.triangle.fill")
                        .foregroundColor(result.success ? AvionicsTheme.mint : AvionicsTheme.amber)
                    Text(result.message)
                        .font(.system(size: 11, design: .monospaced))
                        .foregroundColor(result.success ? AvionicsTheme.mint : AvionicsTheme.amber)
                    Spacer()
                }
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(result.success ? AvionicsTheme.mint.opacity(0.1) : AvionicsTheme.amber.opacity(0.1))
                )
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(AvionicsTheme.panel)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(AvionicsTheme.line, lineWidth: 1)
                )
        )
    }
    
    private var offlineDoctrineSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: "airplane.circle.fill")
                    .foregroundColor(AvionicsTheme.mint)
                Text("OFFLINE AVIONICS GROUNDING READY")
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .foregroundColor(AvionicsTheme.mint)
            }
            
            Text("All 74 GACAR parts and regulatory decision trees operate on-device with zero network requirement. Ideal for in-flight mode at FL380 or remote airfield use.")
                .font(.system(size: 12))
                .foregroundColor(AvionicsTheme.inkDim)
                .lineSpacing(3)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(AvionicsTheme.panel)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(AvionicsTheme.mint.opacity(0.3), lineWidth: 1)
                )
        )
    }
    
    private var actionButtonsSection: some View {
        VStack(spacing: 8) {
            Button(action: applyAndDismiss) {
                Text("ENGAGE CONFIGURATION")
                    .font(.system(size: 13, weight: .black, design: .monospaced))
                    .foregroundColor(AvionicsTheme.bg)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(AvionicsTheme.cyan)
                    .cornerRadius(6)
            }
            
            Button(action: resetToDefaults) {
                Text("RESTORE FACTORY PRESETS")
                    .font(.system(size: 11, weight: .semibold, design: .monospaced))
                    .foregroundColor(AvionicsTheme.inkDim)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
            }
        }
        .padding(.top, 8)
    }
    
    // MARK: - Actions
    
    private func runPingTest() {
        isTesting = true
        testResult = nil
        
        let testConfig = AIProviderConfig(
            provider: selectedProvider,
            endpointURL: endpointURL,
            modelName: modelName,
            temperature: 0.2,
            streamEnabled: true
        )
        
        Task {
            let res = await aiService.testConnection(config: testConfig, apiKey: apiKey)
            await MainActor.run {
                isTesting = false
                testResult = (res.success, "\(res.message) · \(res.latencyMs)ms")
            }
        }
    }
    
    private func applyAndDismiss() {
        let newConfig = AIProviderConfig(
            provider: selectedProvider,
            endpointURL: endpointURL,
            modelName: modelName,
            temperature: 0.2,
            streamEnabled: true
        )
        aiService.updateConfig(newConfig, apiKey: apiKey)
        isPresented = false
    }
    
    private func resetToDefaults() {
        selectedProvider = .offlineDoctrine
        endpointURL = ""
        modelName = "GACAR-74-Local"
        apiKey = ""
        testResult = nil
    }
}
