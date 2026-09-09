import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

// MARK: - Avionics Theme Design System (Matching captadel.com)
enum AvionicsTheme {
    // Exact hex color tokens from captadel.com
    static let bg = Color(red: 5/255, green: 8/255, blue: 16/255)       // #050810
    static let panel = Color(red: 12/255, green: 18/255, blue: 32/255)   // #0c1220
    static let panel2 = Color(red: 17/255, green: 26/255, blue: 43/255)  // #111a2b
    static let line = Color(red: 26/255, green: 37/255, blue: 64/255)    // #1a2540
    static let ink = Color(red: 230/255, green: 237/255, blue: 246/255)  // #e6edf6
    static let inkDim = Color(red: 139/255, green: 152/255, blue: 173/255) // #8b98ad
    static let secondary = inkDim                                         // Secondary label / icon color
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

    // MARK: - Gradient Tokens (trendy glass/glow layer on top of the captadel.com palette)
    static let cyanTealGradient = LinearGradient(
        colors: [cyan, teal],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let mintCyanGradient = LinearGradient(
        colors: [mint, cyan],
        startPoint: .leading,
        endPoint: .trailing
    )

    static let inkFadeGradient = LinearGradient(
        colors: [ink, cyan],
        startPoint: .leading,
        endPoint: .trailing
    )

    static let liveRingGradient = AngularGradient(
        colors: [cyan, teal, mint, cyan],
        center: .center
    )

    static func heroAura(_ accent: Color = teal) -> RadialGradient {
        RadialGradient(
            colors: [accent.opacity(0.38), cyan.opacity(0.14), .clear],
            center: .center,
            startRadius: 6,
            endRadius: 150
        )
    }

    static func glassStroke(_ accent: Color) -> LinearGradient {
        LinearGradient(
            colors: [accent.opacity(0.65), line.opacity(0.5), accent.opacity(0.15)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - Haptics (cockpit tactile feedback)
enum Haptics {
    static func light() {
        #if canImport(UIKit) && !os(macOS)
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        #endif
    }

    static func medium() {
        #if canImport(UIKit) && !os(macOS)
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        #endif
    }

    #if canImport(UIKit) && !os(macOS)
    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
    #else
    static func impact(_ style: Any? = nil) {}
    #endif

    static func selection() {
        #if canImport(UIKit) && !os(macOS)
        UISelectionFeedbackGenerator().selectionChanged()
        #endif
    }

    static func success() {
        #if canImport(UIKit) && !os(macOS)
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        #endif
    }

    static func warning() {
        #if canImport(UIKit) && !os(macOS)
        UINotificationFeedbackGenerator().notificationOccurred(.warning)
        #endif
    }
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

// MARK: - Frosted Glass Panel (trendy glassmorphism layer)
struct GlassPanelModifier: ViewModifier {
    var accent: Color = AvionicsTheme.cyan
    var cornerRadius: CGFloat = 14
    var glow: Bool = true
    var tint: Double = 0.5

    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(.ultraThinMaterial)
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(AvionicsTheme.panel.opacity(tint))
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(AvionicsTheme.glassStroke(accent), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .shadow(color: glow ? accent.opacity(0.16) : .clear, radius: 18, x: 0, y: 10)
    }
}

extension View {
    func glassPanel(
        accent: Color = AvionicsTheme.cyan,
        cornerRadius: CGFloat = 14,
        glow: Bool = true,
        tint: Double = 0.5
    ) -> some View {
        modifier(GlassPanelModifier(accent: accent, cornerRadius: cornerRadius, glow: glow, tint: tint))
    }
}

// MARK: - Gradient Border (lightweight accent, no material blur — for chips/pills)
struct GradientBorderModifier: ViewModifier {
    var accent: Color
    var cornerRadius: CGFloat
    var lineWidth: CGFloat = 1

    func body(content: Content) -> some View {
        content.overlay(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(AvionicsTheme.glassStroke(accent), lineWidth: lineWidth)
        )
    }
}

extension View {
    func gradientBorder(_ accent: Color, cornerRadius: CGFloat, lineWidth: CGFloat = 1) -> some View {
        modifier(GradientBorderModifier(accent: accent, cornerRadius: cornerRadius, lineWidth: lineWidth))
    }
}

// MARK: - Pressable Micro-Interaction Button Style
struct PressableButtonStyle: ButtonStyle {
    var scale: CGFloat = 0.96

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scale : 1.0)
            .opacity(configuration.isPressed ? 0.88 : 1.0)
            .animation(.spring(response: 0.28, dampingFraction: 0.62), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == PressableButtonStyle {
    static var pressable: PressableButtonStyle { PressableButtonStyle() }
}

// MARK: - Rotating Glow Ring (avatar / live-status halo)
struct RotatingGlowRing: View {
    var lineWidth: CGFloat = 2
    @State private var rotation: Double = 0

    var body: some View {
        Circle()
            .stroke(AvionicsTheme.liveRingGradient, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
            .rotationEffect(.degrees(rotation))
            .onAppear {
                withAnimation(.linear(duration: 5).repeatForever(autoreverses: false)) {
                    rotation = 360
                }
            }
    }
}

// MARK: - Faint HUD Grid Overlay
struct RadarGridOverlay: View {
    var spacing: CGFloat = 30
    var lineColor: Color = AvionicsTheme.line

    var body: some View {
        Canvas { context, size in
            var x: CGFloat = 0
            while x <= size.width {
                var path = Path()
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: size.height))
                context.stroke(path, with: .color(lineColor), lineWidth: 0.5)
                x += spacing
            }
            var y: CGFloat = 0
            while y <= size.height {
                var path = Path()
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: size.width, y: y))
                context.stroke(path, with: .color(lineColor), lineWidth: 0.5)
                y += spacing
            }
        }
        .allowsHitTesting(false)
    }
}

// MARK: - Cockpit Ambient Backdrop (aurora glow blobs + faint HUD grid)
struct CockpitBackdrop: View {
    var body: some View {
        ZStack {
            AvionicsTheme.bg

            RadarGridOverlay()
                .opacity(0.045)

            Circle()
                .fill(AvionicsTheme.cyan.opacity(0.10))
                .frame(width: 280, height: 280)
                .blur(radius: 100)
                .offset(x: -130, y: -260)

            Circle()
                .fill(AvionicsTheme.mint.opacity(0.07))
                .frame(width: 240, height: 240)
                .blur(radius: 110)
                .offset(x: 150, y: 340)
        }
        .ignoresSafeArea()
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
