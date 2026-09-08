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
                // Category Selector Filter Chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        Button(action: { selectedCategory = nil }) {
                            Text(currentLanguage == .arabic ? "الكل (74 جزء)" : "All Parts (74)")
                                .font(.system(size: 13, weight: .semibold))
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(
                                    Capsule()
                                        .fill(selectedCategory == nil ? Color.blue : Color.primary.opacity(0.06))
                                )
                                .foregroundColor(selectedCategory == nil ? .white : .primary)
                        }
                        
                        ForEach(GACARCategory.allCases) { cat in
                            Button(action: { selectedCategory = cat }) {
                                HStack(spacing: 6) {
                                    Image(systemName: cat.iconName)
                                    Text(currentLanguage == .arabic ? cat.arabicName : cat.rawValue)
                                }
                                .font(.system(size: 13, weight: .semibold))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(
                                    Capsule()
                                        .fill(selectedCategory == cat ? Color.blue : Color.primary.opacity(0.06))
                                )
                                .foregroundColor(selectedCategory == cat ? .white : .primary)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                }
                
                Divider()
                
                // Parts List
                List {
                    Section {
                        ForEach(filteredParts) { part in
                            Button(action: { selectedPart = part }) {
                                GACARPartRowView(part: part, language: currentLanguage)
                            }
                        }
                    } header: {
                        Text(currentLanguage == .arabic ? "أجزاء لوائح GACAR المتاحة" : "GACAR Regulatory Parts")
                            .font(.caption.weight(.bold))
                    }
                }
                .listStyle(.plain)
                .searchable(
                    text: $searchText,
                    prompt: currentLanguage == .arabic ? "ابحث في أجزاء أو مواد GACAR..." : "Search GACAR parts or sections..."
                )
            }
            .navigationTitle(currentLanguage == .arabic ? "مكتبة أنظمة GACAR" : "GACAR Library")
            .sheet(item: $selectedPart) { part in
                GACARPartDetailSheet(part: part, language: currentLanguage, aiService: aiService)
            }
        }
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

// MARK: - Row View
struct GACARPartRowView: View {
    let part: GACARPart
    let language: AppLanguage
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 44, height: 44)
                Image(systemName: part.category.iconName)
                    .font(.system(size: 20))
                    .foregroundColor(.blue)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(part.partNumber)
                        .font(.system(size: 13, weight: .bold, design: .monospaced))
                        .foregroundColor(.blue)
                    
                    Spacer()
                    
                    Text(language == .arabic ? part.category.arabicName : part.category.rawValue)
                        .font(.caption2.weight(.bold))
                        .foregroundColor(.secondary)
                }
                
                Text(language == .arabic ? part.titleAr : part.titleEn)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text(language == .arabic ? part.summaryAr : part.summaryEn)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 6)
    }
}

// MARK: - Detail Sheet
struct GACARPartDetailSheet: View {
    let part: GACARPart
    let language: AppLanguage
    @ObservedObject var aiService: CaptainAdelAIService
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    // Header Banner
                    VStack(alignment: .leading, spacing: 8) {
                        Text(part.partNumber)
                            .font(.system(size: 28, weight: .heavy, design: .monospaced))
                            .foregroundColor(.blue)
                        
                        Text(language == .arabic ? part.titleAr : part.titleEn)
                            .font(.title2.weight(.bold))
                        
                        Text(language == .arabic ? part.summaryAr : part.summaryEn)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.blue.opacity(0.06))
                    )
                    
                    Text(language == .arabic ? "المواد والفقرات المفتاحية (§):" : "Key Sections & Clauses (§):")
                        .font(.headline)
                    
                    ForEach(part.keySections) { sec in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("§ \(sec.sectionCode)")
                                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                                    .foregroundColor(.blue)
                                Spacer()
                                Text(language == .arabic ? sec.titleAr : sec.titleEn)
                                    .font(.system(size: 13, weight: .semibold))
                            }
                            
                            Text(language == .arabic ? sec.contentAr : sec.contentEn)
                                .font(.system(size: 13))
                                .foregroundColor(.secondary)
                                .lineSpacing(4)
                            
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
                                .font(.caption.weight(.bold))
                                .foregroundColor(.blue)
                            }
                            .padding(.top, 4)
                        }
                        .padding(14)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.primary.opacity(0.03))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.primary.opacity(0.08), lineWidth: 1)
                                )
                        )
                    }
                }
                .padding(16)
            }
            .navigationTitle(part.partNumber)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(language == .arabic ? "إغلاق" : "Close") { dismiss() }
                }
            }
        }
    }
}
