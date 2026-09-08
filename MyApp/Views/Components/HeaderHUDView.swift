import SwiftUI

struct HeaderHUDView: View {
    @Binding var currentLanguage: AppLanguage
    let onVoiceModeTap: () -> Void

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
                            .fill(AvionicsTheme.mint)
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
                            PulsingDotView(color: AvionicsTheme.mint, size: 6)
                            Text(currentLanguage == .arabic ? "مدرّب طيران ذكي • متصل" : "AI FLIGHT INSTRUCTOR · ONLINE")
                                .font(.system(size: 9.5, weight: .semibold, design: .monospaced))
                                .foregroundColor(AvionicsTheme.mint)
                        }
                    }
                }

                Spacer()

                // Right Controls: Comms Voice + Language Switcher
                HStack(spacing: 8) {
                    Button(action: onVoiceModeTap) {
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

            // Cockpit Telemetry Grid Ribbon (Exact match to captadel.com)
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

                telemetryCell(
                    label: currentLanguage == .arabic ? "القاعدة" : "BASE",
                    val: "OERK · RIYADH",
                    color: AvionicsTheme.amber
                )

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
