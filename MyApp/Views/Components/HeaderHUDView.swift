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
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(AvionicsTheme.teal, lineWidth: 1.5)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(AvionicsTheme.panel2)
                            )
                            .frame(width: 44, height: 44)
                        
                        Image.captainAvatar
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 38, height: 38)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
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
                                .background(AvionicsTheme.cyan.opacity(0.15))
                                .foregroundColor(AvionicsTheme.cyan)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 3)
                                        .stroke(AvionicsTheme.cyan.opacity(0.4), lineWidth: 1)
                                )
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
                            RoundedRectangle(cornerRadius: 6)
                                .fill(AvionicsTheme.panel2)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(AvionicsTheme.line, lineWidth: 1)
                                )
                                .frame(width: 36, height: 32)
                            
                            Image(systemName: "waveform.and.mic")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(AvionicsTheme.cyan)
                        }
                    }
                    .buttonStyle(.plain)
                    
                    // Language Toggle
                    Menu {
                        ForEach(AppLanguage.allCases) { lang in
                            Button(action: {
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
                        .padding(.horizontal, 8)
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
            .background(AvionicsTheme.panel)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(AvionicsTheme.line),
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
