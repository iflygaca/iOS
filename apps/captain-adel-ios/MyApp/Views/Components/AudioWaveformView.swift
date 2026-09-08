import SwiftUI

struct AudioWaveformView: View {
    @State private var phase: Double = 0.0
    var isListening: Bool = true
    var isSpeaking: Bool = false
    var audioPower: Float = 0.0
    
    var body: some View {
        HStack(spacing: 5) {
            ForEach(0..<16, id: \.self) { index in
                RoundedRectangle(cornerRadius: 3)
                    .fill(barGradient(for: index))
                    .frame(width: 4.5, height: height(for: index))
                    .animation(.spring(response: 0.25, dampingFraction: 0.65), value: audioPower)
            }
        }
        .onAppear {
            withAnimation(
                .easeInOut(duration: 0.6)
                .repeatForever(autoreverses: true)
            ) {
                phase = 1.0
            }
        }
    }
    
    private func barGradient(for index: Int) -> LinearGradient {
        if isSpeaking {
            return LinearGradient(
                colors: [AvionicsTheme.amber, AvionicsTheme.cyan],
                startPoint: .bottom,
                endPoint: .top
            )
        } else if isListening {
            return LinearGradient(
                colors: [AvionicsTheme.cyan, AvionicsTheme.mint],
                startPoint: .bottom,
                endPoint: .top
            )
        } else {
            return LinearGradient(
                colors: [AvionicsTheme.inkDim.opacity(0.3), AvionicsTheme.inkDim.opacity(0.15)],
                startPoint: .bottom,
                endPoint: .top
            )
        }
    }
    
    private func height(for index: Int) -> CGFloat {
        if !isListening && !isSpeaking {
            return 8
        }
        
        let base: CGFloat = 8
        let powerBoost = CGFloat(audioPower) * 45.0
        let multiplier: CGFloat = isListening ? (24 + powerBoost) : 32
        let sinValue = sin(Double(index) * 0.45 + (phase * .pi * 2))
        return min(max(base + CGFloat(abs(sinValue)) * multiplier, 6), 65)
    }
}
