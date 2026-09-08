import SwiftUI

struct GACARLibraryView: View {
    @ObservedObject var aiService: CaptainAdelAIService
    @Binding var currentLanguage: AppLanguage
    @State private var searchText: String = ""
    @State private var selectedCategory: GACARCategory? = nil
    @State private var selectedPart: GACARPart? = nil
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header Bar & Telemetry
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(currentLanguage == .arabic ? "مستودع أنظمة GACAR" : "GACAR REGULATORY CORPUS")
                            .font(.system(size: 14, weight: .black, design: .monospaced))
                            .foregroundColor(AvionicsTheme.ink)
                        Text(currentLanguage == .arabic ? "74 جزءاً مُسنداً بالكامل" : "74 Parts Indexed & Grounded")
                            .font(.system(size: 10, weight: .medium, design: .monospaced))
                            .foregroundColor(AvionicsTheme.mint)
                    }
                    Spacer()
                    Image(systemName: "externaldrive.badge.checkmark")
                        .font(.system(size: 16))
                        .foregroundColor(AvionicsTheme.cyan)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(AvionicsTheme.panel)
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(AvionicsTheme.line),
                    alignment: .bottom
                )
                
                // Category Filter Chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        Button(action: { selectedCategory = nil }) {
                            Text(currentLanguage == .arabic ? "الكل (74)" : "ALL (74)")
                                .font(.system(size: 11, weight: .bold, design: .monospaced))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(selectedCategory == nil ? AvionicsTheme.cyan : AvionicsTheme.panel2)
                                .foregroundColor(selectedCategory == nil ? AvionicsTheme.bg : AvionicsTheme.inkDim)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(selectedCategory == nil ? AvionicsTheme.cyan : AvionicsTheme.line, lineWidth: 1)
                                )
                        }
                        
                        ForEach(GACARCategory.allCases) { cat in
                            Button(action: { selectedCategory = cat }) {
                                HStack(spacing: 4) {
                                    Image(systemName: cat.iconName)
                                        .font(.system(size: 9))
                                    Text(currentLanguage == .arabic ? cat.arabicName : cat.rawValue)
                                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(selectedCategory == cat ? AvionicsTheme.cyan : AvionicsTheme.panel2)
                                .foregroundColor(selectedCategory == cat ? AvionicsTheme.bg : AvionicsTheme.inkDim)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(selectedCategory == cat ? AvionicsTheme.cyan : AvionicsTheme.line, lineWidth: 1)
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                }
                .background(AvionicsTheme.panel.opacity(0.6))
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(AvionicsTheme.line),
                    alignment: .bottom
                )
                
                // Custom Cockpit Search Bar
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 12))
                        .foregroundColor(AvionicsTheme.cyan)
                    TextField(
                        currentLanguage == .arabic ? "ابحث في أجزاء أو فقرات GACAR..." : "Filter GACAR parts or § clauses...",
                        text: $searchText
                    )
                    .font(.system(size: 12.5, design: .monospaced))
                    .foregroundColor(AvionicsTheme.ink)
                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(AvionicsTheme.inkDim)
                        }
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 7)
                .background(AvionicsTheme.panel2)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(AvionicsTheme.line, lineWidth: 1)
                )
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
                
                // Parts List
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(filteredParts) { part in
                            Button(action: { selectedPart = part }) {
                                CockpitGACARPartRowView(part: part, language: currentLanguage)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                }
            }
            .background(AvionicsTheme.bg)
            .sheet(item: $selectedPart) { part in
                CockpitGACARPartDetailSheet(part: part, language: currentLanguage, aiService: aiService)
            }
        }
        .preferredColorScheme(.dark)
        .environment(\.layoutDirection, currentLanguage.isRTL ? .rightToLeft : .leftToRight)
    }
    
    private var filteredParts: [GACARPart] {
        aiService.gacarParts.filter { part in
            let matchesCategory = (selectedCategory == nil || part.category == selectedCategory)
            if searchText.isEmpty {
                return matchesCategory
            }
            let query = searchText.lowercased()
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
                RoundedRectangle(cornerRadius: 6)
                    .fill(AvionicsTheme.panel2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(AvionicsTheme.cyan.opacity(0.4), lineWidth: 1)
                    )
                    .frame(width: 40, height: 40)
                Image(systemName: part.category.iconName)
                    .font(.system(size: 18))
                    .foregroundColor(AvionicsTheme.cyan)
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
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(AvionicsTheme.panel)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(AvionicsTheme.line, lineWidth: 1)
                )
        )
    }
}

// MARK: - Cockpit Part Detail Sheet
struct CockpitGACARPartDetailSheet: View {
    let part: GACARPart
    let language: AppLanguage
    @ObservedObject var aiService: CaptainAdelAIService
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                AvionicsTheme.bg.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // Header Banner
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(part.partNumber)
                                    .font(.system(size: 24, weight: .heavy, design: .monospaced))
                                    .foregroundColor(AvionicsTheme.cyan)
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
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(AvionicsTheme.panel)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(AvionicsTheme.line, lineWidth: 1)
                                )
                        )
                        
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
                                
                                Button(action: {
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
                                    .foregroundColor(AvionicsTheme.cyan)
                                }
                                .padding(.top, 4)
                            }
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(AvionicsTheme.panel2)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(AvionicsTheme.line, lineWidth: 1)
                                    )
                            )
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
