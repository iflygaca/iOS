import SwiftUI

struct HeaderHUDView: View {
    @ObservedObject var aiService: CaptainAdelAIService
    @Binding var currentLanguage: AppLanguage
    let onVoiceModeTap: () -> Void
    let onSettingsTap: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // Main Cockpit Header
            HStack(alignment: .center, spacing: 12) {
                // Captain Adel Avatar & Callsign Badge
                HStack(spacing: 10) {
                    ZStack {
                        RotatingGlowRing(lineWidth: 1.6)
                            .frame(width: 48, height: 48)

                        Circle()
                            .fill(AvionicsTheme.panel2)
                            .frame(width: 42, height: 42)

                        Image.captainAvatar
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 36, height: 36)
                            .clipShape(RoundedRectangle(cornerRadius: 8))

                        // Live status dot
                        Circle()
                            .fill(aiService.config.provider == .offlineDoctrine ? AvionicsTheme.mint : AvionicsTheme.cyan)
                            .frame(width: 11, height: 11)
                            .overlay(Circle().stroke(AvionicsTheme.bg, lineWidth: 2))
                            .offset(x: 17, y: 17)
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 6) {
                            Text(currentLanguage == .arabic ? "كابتن عادل" : "CAPT. ADEL")
                                .font(.system(size: 16, weight: .black, design: .monospaced))
                                .foregroundColor(AvionicsTheme.ink)

                            // Callsign Tag
                            Text("ADEL-1")
                                .font(.system(size: 9, weight: .bold, design: .monospaced))
                                .padding(.horizontal, 5)
                                .padding(.vertical, 2)
                                .background(Capsule().fill(AvionicsTheme.cyan.opacity(0.15)))
                                .foregroundColor(AvionicsTheme.cyan)
                                .overlay(Capsule().stroke(AvionicsTheme.cyan.opacity(0.4), lineWidth: 1))
                        }

                        HStack(spacing: 4) {
                            PulsingDotView(
                                color: aiService.config.provider == .offlineDoctrine ? AvionicsTheme.mint : AvionicsTheme.cyan,
                                size: 6
                            )
                            Text(statusText)
                                .font(.system(size: 9.5, weight: .semibold, design: .monospaced))
                                .foregroundColor(aiService.config.provider == .offlineDoctrine ? AvionicsTheme.mint : AvionicsTheme.cyan)
                        }
                    }
                }

                Spacer()

                // Right Controls: FL380 Mode + Comms Settings + Voice + Language
                HStack(spacing: 7) {
                    // FL380 Flight Mode Quick Toggle
                    Button(action: {
                        Haptics.medium()
                        withAnimation(.spring(response: 0.3)) {
                            aiService.toggleFL380FlightMode()
                        }
                    }) {
                        ZStack {
                            Circle()
                                .fill(aiService.isFL380FlightMode ? AvionicsTheme.cyan.opacity(0.18) : AvionicsTheme.panel2)
                                .frame(width: 34, height: 34)
                            Circle()
                                .stroke(aiService.isFL380FlightMode ? AvionicsTheme.cyan : AvionicsTheme.line, lineWidth: 1.2)
                                .frame(width: 34, height: 34)

                            Image(systemName: "airplane")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(aiService.isFL380FlightMode ? AvionicsTheme.cyan : AvionicsTheme.inkDim)
                        }
                    }
                    .buttonStyle(.pressable)

                    // AI Comms Engine Config Button
                    Button(action: {
                        Haptics.light()
                        onSettingsTap()
                    }) {
                        ZStack {
                            Circle()
                                .fill(AvionicsTheme.panel2)
                                .frame(width: 34, height: 34)
                            Circle()
                                .stroke(aiService.config.provider == .offlineDoctrine ? AvionicsTheme.line : AvionicsTheme.cyan.opacity(0.8), lineWidth: 1)
                                .frame(width: 34, height: 34)

                            Image(systemName: "antenna.radiowaves.left.and.right")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(aiService.config.provider == .offlineDoctrine ? AvionicsTheme.inkDim : AvionicsTheme.cyan)
                        }
                    }
                    .buttonStyle(.pressable)

                    // Voice Mode Button
                    Button(action: {
                        Haptics.medium()
                        onVoiceModeTap()
                    }) {
                        ZStack {
                            Circle()
                                .fill(AvionicsTheme.panel2)
                                .frame(width: 34, height: 34)
                            Circle()
                                .stroke(AvionicsTheme.glassStroke(AvionicsTheme.cyan), lineWidth: 1)
                                .frame(width: 34, height: 34)

                            Image(systemName: "waveform.and.mic")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundStyle(AvionicsTheme.mintCyanGradient)
                        }
                    }
                    .buttonStyle(.pressable)

                    // Language Toggle
                    Menu {
                        ForEach(AppLanguage.allCases) { lang in
                            Button(action: {
                                Haptics.selection()
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    currentLanguage = lang
                                }
                            }) {
                                HStack {
                                    Text("\(lang.flagEmoji) \(lang.displayName)")
                                    if currentLanguage == lang {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Text(currentLanguage == .arabic ? "🇸🇦 عادل" : "🇺🇸 EN")
                                .font(.system(size: 11, weight: .bold, design: .monospaced))
                                .foregroundColor(AvionicsTheme.ink)
                            Image(systemName: "chevron.down")
                                .font(.system(size: 8, weight: .bold))
                                .foregroundColor(AvionicsTheme.inkDim)
                        }
                        .padding(.horizontal, 9)
                        .padding(.vertical, 7)
                        .background(Capsule().fill(AvionicsTheme.panel2))
                        .overlay(Capsule().stroke(AvionicsTheme.line, lineWidth: 1))
                    }
                    .buttonStyle(.pressable)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(AvionicsTheme.bg)

            // Cockpit Telemetry Grid Ribbon
            HStack(spacing: 0) {
                telemetryCell(
                    label: currentLanguage == .arabic ? "الإسناد" : "GROUNDING",
                    val: currentLanguage == .arabic ? "مفعّل" : "ARMED",
                    color: AvionicsTheme.mint
                )

                Divider()
                    .background(AvionicsTheme.line)
                    .frame(height: 24)

                telemetryCell(
                    label: currentLanguage == .arabic ? "المرجع" : "CORPUS",
                    val: "GACAR 74",
                    color: AvionicsTheme.cyan
                )

                Divider()
                    .background(AvionicsTheme.line)
                    .frame(height: 24)

                Button(action: {
                    Haptics.light()
                    onSettingsTap()
                }) {
                    telemetryCell(
                        label: currentLanguage == .arabic ? "المحرّك" : "ENGINE",
                        val: aiService.isFL380FlightMode ? "FL380 VEC" : aiService.config.provider.shortBadge,
                        color: (aiService.isFL380FlightMode || aiService.config.provider == .offlineDoctrine) ? AvionicsTheme.mint : AvionicsTheme.cyan
                    )
                }
                .buttonStyle(.plain)

                Divider()
                    .background(AvionicsTheme.line)
                    .frame(height: 24)

                telemetryCell(
                    label: currentLanguage == .arabic ? "المبدأ" : "DOCTRINE",
                    val: "CITE/REFUSE",
                    color: AvionicsTheme.ink
                )
            }
            .frame(height: 38)
            .background(.ultraThinMaterial)
            .background(AvionicsTheme.panel.opacity(0.75))
            .overlay(
                LinearGradient(
                    colors: [AvionicsTheme.cyan.opacity(0.35), .clear],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(height: 1),
                alignment: .top
            )
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(AvionicsTheme.line),
                alignment: .bottom
            )
        }
    }

    private var statusText: String {
        if aiService.isFL380FlightMode {
            return currentLanguage == .arabic ? "وضع FL380 • متصل محلياً" : "FL380 FLIGHT MODE · 74 PARTS"
        }
        switch aiService.connectionStatus {
        case .offline:
            return currentLanguage == .arabic ? "مدرّب ذكي • محلي" : "LOCAL ENGINE · ARMED"
        case .connecting:
            return currentLanguage == .arabic ? "جارِ الاتصال..." : "CONNECTING..."
        case .connected(let ms):
            return currentLanguage == .arabic ? "سحابي • \(ms)ms" : "CLOUD LIVE · \(ms)MS"
        case .fallback:
            return currentLanguage == .arabic ? "احتياطي محلي" : "LOCAL FALLBACK"
        }
    }

    private func telemetryCell(label: String, val: String, color: Color) -> some View {
        VStack(spacing: 1) {
            Text(label)
                .font(.system(size: 8, weight: .bold, design: .monospaced))
                .foregroundColor(AvionicsTheme.inkDim)
                .tracking(0.8)
            Text(val)
                .font(.system(size: 9.5, weight: .bold, design: .monospaced))
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
    }
}
