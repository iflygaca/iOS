import SwiftUI

// MARK: - Avionics Theme Design System (Matching captadel.com)
enum AvionicsTheme {
    // Exact hex color tokens from captadel.com
    static let bg = Color(red: 5/255, green: 8/255, blue: 16/255)       // #050810
    static let panel = Color(red: 12/255, green: 18/255, blue: 32/255)   // #0c1220
    static let panel2 = Color(red: 17/255, green: 26/255, blue: 43/255)  // #111a2b
    static let line = Color(red: 26/255, green: 37/255, blue: 64/255)    // #1a2540
    static let ink = Color(red: 230/255, green: 237/255, blue: 246/255)  // #e6edf6
    static let inkDim = Color(red: 139/255, green: 152/255, blue: 173/255) // #8b98ad
    static let cyan = Color(red: 34/255, green: 211/255, blue: 238/255)  // #22d3ee
    static let teal = Color(red: 45/255, green: 142/255, blue: 168/255)  // #2d8ea8
    static let mint = Color(red: 52/255, green: 211/255, blue: 153/255)  // #34d399
    static let amber = Color(red: 251/255, green: 191/255, blue: 36/255) // #fbbf24
    static let red = Color(red: 248/255, green: 113/255, blue: 113/255)  // #f87171
    
    // GACAR Parts list for the ticker tape
    static let tickerParts = [
        "GACAR PART 1 — DEFINITIONS & ABBREVIATIONS",
        "GACAR PART 61 — CERTIFICATION: PILOTS & INSTRUCTORS",
        "GACAR PART 91 — GENERAL OPERATING & FLIGHT RULES",
        "GACAR PART 121 — COMMERCIAL AIR TRANSPORT",
        "GACAR PART 135 — COMMUTER & ON-DEMAND OPERATIONS",
        "GACAR PART 141 — PILOT TRAINING SCHOOLS",
        "GACAR PART 43 — MAINTENANCE & PREVENTIVE WORK",
        "GACAR PART 65 — AIRMEN OTHER THAN FLIGHT CREW",
        "GACAR PART 107 — UNMANNED AIRCRAFT SYSTEMS (DRONES)"
    ]
}

// MARK: - Cross-Platform Image Provider
extension Image {
    static var captainAvatar: Image {
        #if canImport(AppKit) && !targetEnvironment(macCatalyst)
        if let img = NSImage(contentsOfFile: "/Users/ad/Documents/GitHub/Captain-Adel-iOS/MyApp/Assets.xcassets/CaptainAvatar.imageset/avatar.png") {
            return Image(nsImage: img)
        }
        #endif
        return Image("avatar")
    }
    
    static var captainPortrait: Image {
        #if canImport(AppKit) && !targetEnvironment(macCatalyst)
        if let img = NSImage(contentsOfFile: "/Users/ad/Documents/GitHub/Captain-Adel-iOS/MyApp/Assets.xcassets/CaptainAdelPortrait.imageset/captain-adel.jpg") {
            return Image(nsImage: img)
        }
        #endif
        return Image("captain-adel")
    }
}

// MARK: - Cockpit Tactical Card Modifier
struct CockpitCardModifier: ViewModifier {
    var borderColor: Color = AvionicsTheme.line
    var backgroundColor: Color = AvionicsTheme.panel
    var cornerRadius: CGFloat = 8

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(borderColor, lineWidth: 1)
                    )
            )
    }
}

extension View {
    func cockpitCard(
        borderColor: Color = AvionicsTheme.line,
        backgroundColor: Color = AvionicsTheme.panel,
        cornerRadius: CGFloat = 8
    ) -> some View {
        self.modifier(CockpitCardModifier(
            borderColor: borderColor,
            backgroundColor: backgroundColor,
            cornerRadius: cornerRadius
        ))
    }
}

// MARK: - Pulsing Radar Dot View
struct PulsingDotView: View {
    var color: Color = AvionicsTheme.mint
    var size: CGFloat = 7
    @State private var isPulsing = false
    
    var body: some View {
        ZStack {
            Circle()
                .fill(color.opacity(0.35))
                .frame(width: size * 2.2, height: size * 2.2)
                .scaleEffect(isPulsing ? 1.4 : 0.8)
                .opacity(isPulsing ? 0 : 0.8)
                .animation(.easeInOut(duration: 1.6).repeatForever(autoreverses: false), value: isPulsing)
            
            Circle()
                .fill(color)
                .frame(width: size, height: size)
        }
        .onAppear {
            isPulsing = true
        }
    }
}

// MARK: - GACAR Running Tape Ticker View
struct GACARTickerTapeView: View {
    @State private var offset: CGFloat = 0
    let items = AvionicsTheme.tickerParts
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 24) {
                ForEach(0..<2, id: \.self) { _ in
                    HStack(spacing: 20) {
                        ForEach(items, id: \.self) { item in
                            HStack(spacing: 6) {
                                Image(systemName: "airplane")
                                    .font(.system(size: 8))
                                    .foregroundColor(AvionicsTheme.cyan)
                                Text(item)
                                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                                    .foregroundColor(AvionicsTheme.inkDim)
                                Text("•")
                                    .font(.system(size: 8))
                                    .foregroundColor(AvionicsTheme.line)
                            }
                        }
                    }
                }
            }
            .fixedSize()
            .offset(x: offset)
            .onAppear {
                withAnimation(.linear(duration: 40).repeatForever(autoreverses: false)) {
                    offset = -700
                }
            }
        }
        .frame(height: 22)
        .clipped()
        .background(AvionicsTheme.panel2.opacity(0.8))
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(AvionicsTheme.line),
            alignment: .bottom
        )
    }
}

