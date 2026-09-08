import SwiftUI

struct AudioWaveformView: View {
    @State private var phase: Double = 0.0
    @State private var isAnimating: Bool = true
    let isListening: Bool
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<12, id: \.self) { index in
                RoundedRectangle(cornerRadius: 3)
                    .fill(
                        LinearGradient(
                            colors: isListening ? [Color.cyan, Color.blue] : [Color.blue, Color.purple],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                    .frame(width: 4, height: height(for: index))
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
    
    private func height(for index: Int) -> CGFloat {
        let base: CGFloat = 8
        let multiplier: CGFloat = isListening ? 28 : 18
        let sinValue = sin(Double(index) * 0.5 + (phase * .pi * 2))
        return base + CGFloat(abs(sinValue)) * multiplier
    }
}
