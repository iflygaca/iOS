import SwiftUI

struct HeaderHUDView: View {
    @Binding var currentLanguage: AppLanguage
    let onVoiceModeTap: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(alignment: .center) {
                // Captain Adel Badge & Title
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.blue, Color.cyan],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 44, height: 44)
                            .shadow(color: .blue.opacity(0.4), radius: 6, x: 0, y: 3)
                        
                        Image(systemName: "airplane.circle.fill")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 6) {
                            Text(currentLanguage == .arabic ? "كابتن عادل" : "Captain Adel")
                                .font(.system(size: 19, weight: .heavy, design: .rounded))
                                .foregroundColor(.primary)
                            
                            // Verification Badge
                            Image(systemName: "checkmark.seal.fill")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                        
                        Text(currentLanguage == .arabic ? "مدرب الطيران الذكي • GACAR RAG" : "Saudi AI Flight Instructor • GACAR RAG")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                // Right Controls: Voice button + Language Switcher
                HStack(spacing: 8) {
                    Button(action: onVoiceModeTap) {
                        ZStack {
                            Circle()
                                .fill(Color.blue.opacity(0.15))
                                .frame(width: 38, height: 38)
                            Image(systemName: "waveform.and.mic")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.blue)
                        }
                    }
                    .buttonStyle(.plain)
                    
                    // Language Switcher Menu
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
                            Text(currentLanguage.flagEmoji)
                                .font(.subheadline)
                            Text(currentLanguage == .arabic ? "عربي" : "EN")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.primary)
                            Image(systemName: "chevron.down")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 7)
                        .background(
                            Capsule()
                                .fill(.ultraThinMaterial)
                                .overlay(
                                    Capsule()
                                        .stroke(Color.primary.opacity(0.12), lineWidth: 1)
                                )
                        )
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            
            // Cockpit RAG Status Bar
            HStack(spacing: 12) {
                HStack(spacing: 5) {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 7, height: 7)
                        .shadow(color: .green, radius: 4)
                    Text("GACAR v2026 Engine")
                        .font(.system(size: 10, weight: .semibold, design: .monospaced))
                        .foregroundColor(.green)
                }
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "doc.text.magnifyingglass")
                        .font(.system(size: 9))
                    Text("74 Parts Grounded")
                        .font(.system(size: 10, weight: .medium, design: .monospaced))
                }
                .foregroundColor(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 4)
            .background(Color.primary.opacity(0.03))
        }
        .background(.ultraThinMaterial)
    }
}
