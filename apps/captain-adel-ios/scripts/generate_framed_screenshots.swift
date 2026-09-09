import Foundation
import AppKit
import CoreGraphics
import ImageIO

// ==============================================================================
// Captain Adel iOS - App Store Marketing Screenshot Generator
// High-Resolution Avionics Frame Mockups with Bilingual Typography
// ==============================================================================

struct SlideConfig {
    let rawFilename: String
    let outFilename: String
    let badge: String
    let headlineEn: String
    let headlineAr: String
    let subtitleEn: String
}

let slides: [SlideConfig] = [
    SlideConfig(
        rawFilename: "01_copilot_chat.png",
        outFilename: "01_copilot_chat.png",
        badge: "✈️  COCKPIT AI FLIGHT INSTRUCTOR",
        headlineEn: "AI COPILOT & VOICE COMMS",
        headlineAr: "مساعد الطيران الذكي والتواصل الصوتي المباشر",
        subtitleEn: "Hands-free push-to-talk VHF radio · Grounded in GACAR Law"
    ),
    SlideConfig(
        rawFilename: "02_gacar_library.png",
        outFilename: "02_gacar_library.png",
        badge: "📖  74 GACAR REGULATORY PARTS",
        headlineEn: "FULL GACAR REGULATORY CORPUS",
        headlineAr: "موسوعة لوائح الطيران المدني السعودي الكاملة (٧٤ جزءاً)",
        subtitleEn: "100% offline vector search at FL380 · One-tap statutory citations"
    ),
    SlideConfig(
        rawFilename: "03_aviation_tools.png",
        outFilename: "03_aviation_tools.png",
        badge: "📡  26 SAUDI AIRPORTS & FMC COMPUTERS",
        headlineEn: "LIVE METAR & FMC FLIGHT SUITE",
        headlineAr: "طقس ٢٦ مطاراً سعودياً وحواسب الوقود والانحدار",
        subtitleEn: "Real-time NOAA METARs · VFR Fuel Reserves §91.151 · Crosswind Trig"
    ),
    SlideConfig(
        rawFilename: "04_about_doctrine.png",
        outFilename: "04_about_doctrine.png",
        badge: "⚖️  \"CITE OR REFUSE\" LEGAL DOCTRINE",
        headlineEn: "GROUNDED IN GACA LEGAL TEXT",
        headlineAr: "عقيدة التوثيق أو الامتناع — لا مجال للتخمين",
        subtitleEn: "Authoritative regulatory citations cross-referenced with GACA.gov.sa"
    )
]

struct TargetPreset {
    let name: String
    let width: CGFloat
    let height: CGFloat
    let outDir: String
}

let presets: [TargetPreset] = [
    TargetPreset(name: "6.9-inch iPhone", width: 1320, height: 2868, outDir: "fastlane/screenshots/6.9_inch"),
    TargetPreset(name: "6.5-inch iPhone", width: 1242, height: 2688, outDir: "fastlane/screenshots/6.5_inch"),
    TargetPreset(name: "13-inch iPad", width: 2064, height: 2752, outDir: "fastlane/screenshots/ipad_13_inch")
]

func hexColor(_ hex: UInt32, alpha: CGFloat = 1.0) -> NSColor {
    let r = CGFloat((hex >> 16) & 0xFF) / 255.0
    let g = CGFloat((hex >> 8) & 0xFF) / 255.0
    let b = CGFloat(hex & 0xFF) / 255.0
    return NSColor(srgbRed: r, green: g, blue: b, alpha: alpha)
}

func renderSlide(slide: SlideConfig, preset: TargetPreset, rawImage: NSImage) -> NSImage {
    let canvasW = preset.width
    let canvasH = preset.height
    let canvasSize = NSSize(width: canvasW, height: canvasH)
    
    let canvas = NSImage(size: canvasSize)
    canvas.lockFocus()
    
    guard let ctx = NSGraphicsContext.current?.cgContext else {
        canvas.unlockFocus()
        return canvas
    }
    
    // 1. Deep Avionics Dark Gradient Background
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let bgColors = [
        hexColor(0x0a101d).cgColor, // rich midnight blue at top
        hexColor(0x060913).cgColor, // deep navy
        hexColor(0x030508).cgColor  // cockpit black at bottom
    ] as CFArray
    let bgLocations: [CGFloat] = [0.0, 0.45, 1.0]
    if let bgGradient = CGGradient(colorsSpace: colorSpace, colors: bgColors, locations: bgLocations) {
        ctx.drawLinearGradient(bgGradient,
                               start: CGPoint(x: canvasW / 2, y: canvasH),
                               end: CGPoint(x: canvasW / 2, y: 0),
                               options: [])
    }
    
    // 2. Ambient Glowing Radial Light at Top Center
    let glowColors = [
        hexColor(0x22d3ee, alpha: 0.18).cgColor,
        hexColor(0x38bdf8, alpha: 0.08).cgColor,
        hexColor(0x050810, alpha: 0.0).cgColor
    ] as CFArray
    let glowLocations: [CGFloat] = [0.0, 0.4, 1.0]
    if let glowGradient = CGGradient(colorsSpace: colorSpace, colors: glowColors, locations: glowLocations) {
        ctx.drawRadialGradient(glowGradient,
                               startCenter: CGPoint(x: canvasW / 2, y: canvasH - 180),
                               startRadius: 20,
                               endCenter: CGPoint(x: canvasW / 2, y: canvasH - 180),
                               endRadius: canvasW * 0.75,
                               options: [])
    }
    
    // 3. Top Category Badge Pill
    let scale = canvasW / 1320.0
    let badgeY = canvasH - (180.0 * scale)
    let badgeFont = NSFont.monospacedSystemFont(ofSize: 22.0 * scale, weight: .bold)
    let badgeAttrs: [NSAttributedString.Key: Any] = [
        .font: badgeFont,
        .foregroundColor: hexColor(0x38bdf8)
    ]
    let badgeStr = NSAttributedString(string: slide.badge, attributes: badgeAttrs)
    let badgeTextSize = badgeStr.size()
    let pillPaddingH: CGFloat = 28.0 * scale
    let pillPaddingV: CGFloat = 12.0 * scale
    let pillRect = CGRect(
        x: (canvasW - badgeTextSize.width - (pillPaddingH * 2)) / 2,
        y: badgeY,
        width: badgeTextSize.width + (pillPaddingH * 2),
        height: badgeTextSize.height + (pillPaddingV * 2)
    )
    
    // Pill background & border
    let pillPath = CGPath(roundedRect: pillRect, cornerWidth: pillRect.height / 2, cornerHeight: pillRect.height / 2, transform: nil)
    ctx.addPath(pillPath)
    ctx.setFillColor(hexColor(0x0f172a, alpha: 0.85).cgColor)
    ctx.fillPath()
    
    ctx.addPath(pillPath)
    ctx.setStrokeColor(hexColor(0x22d3ee, alpha: 0.45).cgColor)
    ctx.setLineWidth(2.0 * scale)
    ctx.strokePath()
    
    badgeStr.draw(at: CGPoint(x: pillRect.origin.x + pillPaddingH, y: pillRect.origin.y + pillPaddingV))
    
    // 4. Primary English Headline
    let headlineEnY = pillRect.origin.y - (95.0 * scale)
    let headlineEnFont = NSFont.systemFont(ofSize: 58.0 * scale, weight: .black)
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .center
    
    let headlineEnAttrs: [NSAttributedString.Key: Any] = [
        .font: headlineEnFont,
        .foregroundColor: NSColor.white,
        .paragraphStyle: paragraphStyle
    ]
    let headlineEnStr = NSAttributedString(string: slide.headlineEn, attributes: headlineEnAttrs)
    let headlineEnRect = CGRect(x: 40 * scale, y: headlineEnY, width: canvasW - (80 * scale), height: 75 * scale)
    headlineEnStr.draw(in: headlineEnRect)
    
    // 5. Arabic Callout
    let headlineArY = headlineEnRect.origin.y - (65.0 * scale)
    let arabicFont = NSFont(name: "GeezaPro-Bold", size: 36.0 * scale) ?? NSFont.boldSystemFont(ofSize: 36.0 * scale)
    let arabicAttrs: [NSAttributedString.Key: Any] = [
        .font: arabicFont,
        .foregroundColor: hexColor(0x34d399), // Mint Green
        .paragraphStyle: paragraphStyle
    ]
    let headlineArStr = NSAttributedString(string: slide.headlineAr, attributes: arabicAttrs)
    let headlineArRect = CGRect(x: 40 * scale, y: headlineArY, width: canvasW - (80 * scale), height: 55 * scale)
    headlineArStr.draw(in: headlineArRect)
    
    // 6. Subtitle / Value Prop
    let subY = headlineArRect.origin.y - (55.0 * scale)
    let subFont = NSFont.systemFont(ofSize: 26.0 * scale, weight: .medium)
    let subAttrs: [NSAttributedString.Key: Any] = [
        .font: subFont,
        .foregroundColor: hexColor(0x94a3b8), // Slate gray
        .paragraphStyle: paragraphStyle
    ]
    let subStr = NSAttributedString(string: slide.subtitleEn, attributes: subAttrs)
    let subRect = CGRect(x: 40 * scale, y: subY, width: canvasW - (80 * scale), height: 45 * scale)
    subStr.draw(in: subRect)
    
    // 7. Render Device Frame & Embedded Screen
    let frameTop = subRect.origin.y - (45.0 * scale)
    let frameBottom: CGFloat = -120.0 * scale // overflows bottom elegantly for heroic perspective
    let frameH = frameTop - frameBottom
    let frameW = frameH * (1206.0 / 2622.0)
    let frameX = (canvasW - frameW) / 2
    let frameRect = CGRect(x: frameX, y: frameBottom, width: frameW, height: frameH)
    
    let outerCornerRadius: CGFloat = 68.0 * scale
    let bezelWidth: CGFloat = 12.0 * scale
    
    // Outer Bezel Shadow
    ctx.saveGState()
    ctx.setShadow(offset: CGSize(width: 0, height: -25 * scale), blur: 40 * scale, color: hexColor(0x000000, alpha: 0.7).cgColor)
    let outerPath = CGPath(roundedRect: frameRect, cornerWidth: outerCornerRadius, cornerHeight: outerCornerRadius, transform: nil)
    ctx.addPath(outerPath)
    ctx.setFillColor(hexColor(0x1e293b).cgColor)
    ctx.fillPath()
    ctx.restoreGState()
    
    // Bezel border stroke (titanium highlight)
    ctx.addPath(outerPath)
    ctx.setStrokeColor(hexColor(0x38bdf8, alpha: 0.35).cgColor)
    ctx.setLineWidth(3.0 * scale)
    ctx.strokePath()
    
    // Inner Screen Rect & Clip
    let screenRect = frameRect.insetBy(dx: bezelWidth, dy: bezelWidth)
    let innerCornerRadius = max(0, outerCornerRadius - bezelWidth)
    let innerPath = CGPath(roundedRect: screenRect, cornerWidth: innerCornerRadius, cornerHeight: innerCornerRadius, transform: nil)
    
    ctx.saveGState()
    ctx.addPath(innerPath)
    ctx.clip()
    
    // Draw the raw app screenshot inside the screen frame
    rawImage.draw(in: screenRect, from: NSRect(origin: .zero, size: rawImage.size), operation: .sourceOver, fraction: 1.0)
    
    // Dynamic Island at Top of Screen
    let islandW: CGFloat = screenRect.width * 0.28
    let islandH: CGFloat = 34.0 * scale
    let islandX = screenRect.origin.x + (screenRect.width - islandW) / 2
    let islandY = screenRect.origin.y + screenRect.height - islandH - (18.0 * scale)
    let islandRect = CGRect(x: islandX, y: islandY, width: islandW, height: islandH)
    let islandPath = CGPath(roundedRect: islandRect, cornerWidth: islandH / 2, cornerHeight: islandH / 2, transform: nil)
    ctx.addPath(islandPath)
    ctx.setFillColor(NSColor.black.cgColor)
    ctx.fillPath()
    
    // Inner border glow around screen
    ctx.restoreGState()
    ctx.addPath(innerPath)
    ctx.setStrokeColor(hexColor(0x22d3ee, alpha: 0.15).cgColor)
    ctx.setLineWidth(1.5 * scale)
    ctx.strokePath()
    
    canvas.unlockFocus()
    return canvas
}

func savePNG(image: NSImage, path: String) {
    guard let tiffData = image.tiffRepresentation,
          let bitmap = NSBitmapImageRep(data: tiffData),
          let pngData = bitmap.representation(using: .png, properties: [:]) else {
        print("Error converting to PNG for \(path)")
        return
    }
    do {
        let url = URL(fileURLWithPath: path)
        try pngData.write(to: url)
        print("✓ Successfully saved: \(path)")
    } catch {
        print("Error saving \(path): \(error)")
    }
}

// ==============================================================================
// Main Execution Loop
// ==============================================================================
let fileManager = FileManager.default
let currentDir = fileManager.currentDirectoryPath

print("=======================================================")
print("🎨 CAPTAIN ADEL APP STORE SCREENSHOT FRAME GENERATOR")
print("=======================================================")

for preset in presets {
    let targetDirPath = "\(currentDir)/\(preset.outDir)"
    try? fileManager.createDirectory(atPath: targetDirPath, withIntermediateDirectories: true, attributes: nil)
    print("\n--- Generating preset: \(preset.name) (\(Int(preset.width))x\(Int(preset.height))) ---")
    
    for slide in slides {
        let rawPath = "\(currentDir)/fastlane/screenshots/raw/\(slide.rawFilename)"
        guard let rawImage = NSImage(contentsOfFile: rawPath) else {
            print("❌ Could not load raw screenshot: \(rawPath)")
            continue
        }
        
        let framedImage = renderSlide(slide: slide, preset: preset, rawImage: rawImage)
        let outPath = "\(targetDirPath)/\(slide.outFilename)"
        savePNG(image: framedImage, path: outPath)
    }
}

print("\n=======================================================")
print("🏁 ALL APP STORE SCREENSHOTS GENERATED SUCCESSFULLY!")
print("=======================================================")
