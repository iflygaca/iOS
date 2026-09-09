import SwiftUI

struct GACARLibraryView: View {
    @ObservedObject var aiService: CaptainAdelAIService
    @Binding var currentLanguage: AppLanguage
    @State private var searchText: String = ""
    @State private var selectedCategory: GACARCategory? = nil
    @State private var selectedPart: GACARPart? = nil
    @FocusState private var isSearchFocused: Bool

    // Quick discovery hashtag pills for high-traffic regulatory domains
    private let trendingTags: [(tag: String, labelAr: String, labelEn: String)] = [
        ("Part 61", "رخص الطيارين", "Pilot Licensing"),
        ("Part 91", "قواعد التشغيل العامة", "General Operations"),
        ("Part 107", "الدرونز UAS", "Drones / UAS"),
        ("Part 121", "الناقلات الجوية", "Air Carriers"),
        ("Part 67", "المعايير الطبية", "Medical Standards"),
        ("Part 139", "المطارات والإنقاذ", "Aerodromes & ARFF"),
        ("Part 65", "المرحلون والفنيون", "Dispatchers & Airmen"),
        ("Part 43", "الصيانة والإصلاح", "Maintenance")
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header Bar & Telemetry
                HStack(spacing: 10) {
                    ZStack {
                        Circle()
                            .fill(AvionicsTheme.cyan.opacity(0.14))
                            .frame(width: 34, height: 34)
                        Image(systemName: "externaldrive.badge.checkmark")
                            .font(.system(size: 15))
                            .foregroundStyle(AvionicsTheme.mintCyanGradient)
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text(currentLanguage == .arabic ? "مستودع أنظمة GACAR" : "GACAR REGULATORY CORPUS")
                            .font(.system(size: 14, weight: .black, design: .monospaced))
                            .foregroundColor(AvionicsTheme.ink)
                        Text(currentLanguage == .arabic ? "74 جزءاً مسنداً بالكامل • بحث متقدم" : "74 Parts Indexed & Grounded • RAG Search")
                            .font(.system(size: 10, weight: .medium, design: .monospaced))
                            .foregroundColor(AvionicsTheme.mint)
                    }
                    Spacer()
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(.ultraThinMaterial)
                .background(AvionicsTheme.panel.opacity(0.85))
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(AvionicsTheme.line),
                    alignment: .bottom
                )

                // Custom Cockpit Search Bar
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(AvionicsTheme.mintCyanGradient)
                    TextField(
                        currentLanguage == .arabic ? "ابحث في أجزاء أو فقرات GACAR..." : "Filter GACAR parts or § clauses...",
                        text: $searchText
                    )
                    .font(.system(size: 12.5, design: .monospaced))
                    .foregroundColor(AvionicsTheme.ink)
                    .focused($isSearchFocused)
                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(AvionicsTheme.inkDim)
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 9)
                .background(Capsule().fill(AvionicsTheme.panel2))
                .overlay(
                    Capsule().stroke(
                        isSearchFocused ? AnyShapeStyle(AvionicsTheme.cyanTealGradient) : AnyShapeStyle(AvionicsTheme.line),
                        lineWidth: 1.2
                    )
                )
                .animation(.easeInOut(duration: 0.2), value: isSearchFocused)
                .padding(.horizontal, 14)
                .padding(.top, 10)
                .padding(.bottom, 6)

                // Category Filter Chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        categoryChip(
                            label: currentLanguage == .arabic ? "الكل (74)" : "ALL (74)",
                            isSelected: selectedCategory == nil
                        ) {
                            selectedCategory = nil
                        }

                        ForEach(GACARCategory.allCases) { cat in
                            categoryChip(
                                label: currentLanguage == .arabic ? cat.arabicName : cat.rawValue,
                                icon: cat.iconName,
                                isSelected: selectedCategory == cat
                            ) {
                                selectedCategory = cat
                            }
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 6)
                }
                .background(AvionicsTheme.panel.opacity(0.5))

                // Quick Discovery Topic Hashtags
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(trendingTags, id: \.tag) { item in
                            let isCurrent = searchText.lowercased().contains(item.tag.lowercased())
                            Button(action: {
                                Haptics.light()
                                if isCurrent {
                                    searchText = ""
                                } else {
                                    searchText = item.tag
                                }
                            }) {
                                HStack(spacing: 4) {
                                    Text("#\(item.tag)")
                                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                                    Text(currentLanguage == .arabic ? "• \(item.labelAr)" : "• \(item.labelEn)")
                                        .font(.system(size: 9.5))
                                }
                                .padding(.horizontal, 9)
                                .padding(.vertical, 4)
                                .background(
                                    Capsule()
                                        .fill(isCurrent ? AvionicsTheme.cyan.opacity(0.2) : AvionicsTheme.panel2.opacity(0.7))
                                )
                                .foregroundColor(isCurrent ? AvionicsTheme.cyan : AvionicsTheme.inkDim)
                                .overlay(
                                    Capsule()
                                        .stroke(isCurrent ? AvionicsTheme.cyan : AvionicsTheme.line.opacity(0.6), lineWidth: 0.8)
                                )
                            }
                            .buttonStyle(.pressable)
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 5)
                }
                .background(AvionicsTheme.panel.opacity(0.3))
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(AvionicsTheme.line),
                    alignment: .bottom
                )

                // Parts List
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(filteredParts) { part in
                            Button(action: {
                                Haptics.light()
                                selectedPart = part
                            }) {
                                CockpitGACARPartRowView(part: part, language: currentLanguage)
                            }
                            .buttonStyle(.pressable)
                        }

                        if filteredParts.isEmpty {
                            emptyStateView
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                }
                .background(CockpitBackdrop())
            }
            .background(AvionicsTheme.bg)
            .sheet(item: $selectedPart) { part in
                CockpitGACARPartDetailSheet(part: part, language: currentLanguage, aiService: aiService)
            }
        }
        .preferredColorScheme(.dark)
        .environment(\.layoutDirection, currentLanguage.isRTL ? .rightToLeft : .leftToRight)
    }

    private func categoryChip(label: String, icon: String? = nil, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: {
            Haptics.selection()
            action()
        }) {
            HStack(spacing: 4) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 9))
                }
                Text(label)
                    .font(.system(size: 10.5, weight: .bold, design: .monospaced))
            }
            .padding(.horizontal, 11)
            .padding(.vertical, 7)
            .foregroundColor(isSelected ? AvionicsTheme.bg : AvionicsTheme.inkDim)
            .background(
                Capsule().fill(
                    isSelected ? AnyShapeStyle(AvionicsTheme.mintCyanGradient) : AnyShapeStyle(AvionicsTheme.panel2)
                )
            )
            .overlay(
                Capsule().stroke(isSelected ? Color.clear : AvionicsTheme.line, lineWidth: 1)
            )
            .shadow(color: isSelected ? AvionicsTheme.cyan.opacity(0.35) : .clear, radius: 8, x: 0, y: 3)
        }
        .buttonStyle(.pressable)
    }

    private var emptyStateView: some View {
        VStack(spacing: 10) {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 32))
                .foregroundColor(AvionicsTheme.inkDim)
            Text(currentLanguage == .arabic ? "لا توجد نتائج مطابقة" : "No matching GACAR parts found")
                .font(.system(size: 12, weight: .semibold, design: .monospaced))
                .foregroundColor(AvionicsTheme.inkDim)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }

    private var filteredParts: [GACARPart] {
        aiService.gacarParts.filter { part in
            let matchesCategory = (selectedCategory == nil || part.category == selectedCategory)
            if searchText.isEmpty {
                return matchesCategory
            }
            let query = searchText.lowercased().replacingOccurrences(of: "#", with: "")
            let matchesText = part.partNumber.lowercased().contains(query) ||
            part.titleEn.lowercased().contains(query) ||
            part.titleAr.contains(query) ||
            part.summaryEn.lowercased().contains(query) ||
            part.keySections.contains { $0.sectionCode.contains(query) || $0.titleEn.lowercased().contains(query) }
            return matchesCategory && matchesText
        }
    }
}

// MARK: - Cockpit Part Row View
struct CockpitGACARPartRowView: View {
    let part: GACARPart
    let language: AppLanguage

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(AvionicsTheme.panel2)
                    .frame(width: 42, height: 42)
                Circle()
                    .stroke(AvionicsTheme.glassStroke(AvionicsTheme.cyan), lineWidth: 1.2)
                    .frame(width: 42, height: 42)
                Image(systemName: part.category.iconName)
                    .font(.system(size: 17))
                    .foregroundStyle(AvionicsTheme.mintCyanGradient)
            }

            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    Text(part.partNumber)
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .foregroundColor(AvionicsTheme.cyan)

                    Spacer()

                    Text(language == .arabic ? part.category.arabicName : part.category.rawValue)
                        .font(.system(size: 9.5, weight: .semibold, design: .monospaced))
                        .foregroundColor(AvionicsTheme.teal)
                }

                Text(language == .arabic ? part.titleAr : part.titleEn)
                    .font(.system(size: 13.5, weight: .bold))
                    .foregroundColor(AvionicsTheme.ink)

                Text(language == .arabic ? part.summaryAr : part.summaryEn)
                    .font(.system(size: 11))
                    .foregroundColor(AvionicsTheme.inkDim)
                    .lineLimit(2)
            }

            Image(systemName: "chevron.right")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(AvionicsTheme.inkDim)
                .padding(.top, 14)
        }
        .padding(12)
        .glassPanel(accent: AvionicsTheme.cyan, cornerRadius: 12, glow: false, tint: 0.6)
    }
}

// MARK: - Cockpit Part Detail Sheet
struct CockpitGACARPartDetailSheet: View {
    let part: GACARPart
    let language: AppLanguage
    @ObservedObject var aiService: CaptainAdelAIService
    @Environment(\.dismiss) private var dismiss
    @State private var copiedSectionCode: String? = nil

    var body: some View {
        NavigationStack {
            ZStack {
                CockpitBackdrop()

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // Header Banner
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(part.partNumber)
                                    .font(.system(size: 24, weight: .heavy, design: .monospaced))
                                    .foregroundStyle(AvionicsTheme.mintCyanGradient)
                                Spacer()
                                Text(language == .arabic ? part.category.arabicName : part.category.rawValue)
                                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                                    .foregroundColor(AvionicsTheme.teal)
                            }

                            Text(language == .arabic ? part.titleAr : part.titleEn)
                                .font(.title3.weight(.bold))
                                .foregroundColor(AvionicsTheme.ink)

                            Text(language == .arabic ? part.summaryAr : part.summaryEn)
                                .font(.system(size: 12.5))
                                .foregroundColor(AvionicsTheme.inkDim)
                                .lineSpacing(3)
                        }
                        .padding(16)
                        .glassPanel(accent: AvionicsTheme.cyan, cornerRadius: 14)

                        Text(language == .arabic ? "المواد والفقرات المفتاحية (§):" : "KEY SECTIONS & CLAUSES (§):")
                            .font(.system(size: 11, weight: .bold, design: .monospaced))
                            .foregroundColor(AvionicsTheme.inkDim)

                        ForEach(part.keySections) { sec in
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("§ \(sec.sectionCode)")
                                        .font(.system(size: 13, weight: .bold, design: .monospaced))
                                        .foregroundColor(AvionicsTheme.cyan)
                                    Spacer()
                                    Text(language == .arabic ? sec.titleAr : sec.titleEn)
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(AvionicsTheme.ink)
                                }

                                Text(language == .arabic ? sec.contentAr : sec.contentEn)
                                    .font(.system(size: 12))
                                    .foregroundColor(AvionicsTheme.inkDim)
                                    .lineSpacing(3)

                                HStack(spacing: 10) {
                                    Button(action: {
                                        Haptics.light()
                                        dismiss()
                                        Task {
                                            await aiService.sendMessage("Explain GACAR § \(sec.sectionCode) \(sec.titleEn)")
                                        }
                                    }) {
                                        HStack(spacing: 4) {
                                            Image(systemName: "sparkles")
                                            Text(language == .arabic ? "اسأل كابتن عادل عن هذه المادة" : "Ask Captain Adel about § \(sec.sectionCode)")
                                        }
                                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                                        .foregroundStyle(AvionicsTheme.mintCyanGradient)
                                    }
                                    .buttonStyle(.pressable)

                                    Spacer()

                                    Button(action: {
                                        Haptics.success()
                                        let text = "GACAR \(part.partNumber) § \(sec.sectionCode): \(sec.titleEn)\n\(sec.contentEn)\n(Source: GACA Saudi Civil Aviation Regulations)"
                                        UIPasteboard.general.string = text
                                        withAnimation {
                                            copiedSectionCode = sec.sectionCode
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            if copiedSectionCode == sec.sectionCode {
                                                copiedSectionCode = nil
                                            }
                                        }
                                    }) {
                                        HStack(spacing: 4) {
                                            Image(systemName: copiedSectionCode == sec.sectionCode ? "checkmark" : "doc.on.doc")
                                            Text(copiedSectionCode == sec.sectionCode ? (language == .arabic ? "تم النسخ" : "Copied!") : (language == .arabic ? "نسخ السند" : "Copy"))
                                        }
                                        .font(.system(size: 10, weight: .semibold, design: .monospaced))
                                        .foregroundColor(copiedSectionCode == sec.sectionCode ? AvionicsTheme.mint : AvionicsTheme.inkDim)
                                    }
                                    .buttonStyle(.pressable)
                                }
                                .padding(.top, 4)
                            }
                            .padding(12)
                            .glassPanel(accent: AvionicsTheme.teal, cornerRadius: 10, glow: false, tint: 0.6)
                        }
                    }
                    .padding(16)
                }
            }
            .navigationTitle(part.partNumber)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(language == .arabic ? "إغلاق" : "Close") { dismiss() }
                        .foregroundColor(AvionicsTheme.cyan)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
