import SwiftUI

struct ContentView: View {
    @StateObject private var aiService = CaptainAdelAIService()
    @State private var selectedTab: Int = 0
    @State private var currentLanguage: AppLanguage = .english

    var body: some View {
        TabView(selection: $selectedTab) {
            // Tab 1: Captain Adel AI Chat Assistant
            ChatView(aiService: aiService, currentLanguage: $currentLanguage)
                .tag(0)

            // Tab 2: GACAR Regulations Library Browser
            GACARLibraryView(aiService: aiService, currentLanguage: $currentLanguage)
                .tag(1)

            // Tab 3: Aviation Tools & Exam Prep
            AviationToolsView(currentLanguage: $currentLanguage)
                .tag(2)

            // Tab 4: About Captain Adel & Model Info
            AboutView(currentLanguage: $currentLanguage)
                .tag(3)
        }
        #if os(iOS)
        .toolbar(.hidden, for: .tabBar)
        #endif
        .accentColor(AvionicsTheme.cyan)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            CockpitTabBar(selectedTab: $selectedTab, language: currentLanguage)
        }
        .background(AvionicsTheme.bg.ignoresSafeArea())
        .preferredColorScheme(.dark)
        .environment(\.layoutDirection, currentLanguage.isRTL ? .rightToLeft : .leftToRight)
    }
}

// MARK: - Floating Glass Cockpit Tab Bar
struct CockpitTabBar: View {
    @Binding var selectedTab: Int
    let language: AppLanguage
    @Namespace private var tabNamespace

    private struct TabItem {
        let icon: String
        let en: String
        let ar: String
    }

    private let items: [TabItem] = [
        TabItem(icon: "airplane.circle.fill", en: "Capt. Adel", ar: "كابتن عادل"),
        TabItem(icon: "book.pages.fill", en: "GACAR", ar: "الأنظمة"),
        TabItem(icon: "gauge.with.needle.fill", en: "Avionics", ar: "الأدوات"),
        TabItem(icon: "shield.lefthalf.filled", en: "Doctrine", ar: "العقيدة")
    ]

    var body: some View {
        HStack(spacing: 4) {
            ForEach(items.indices, id: \.self) { index in
                let item = items[index]
                let isSelected = selectedTab == index

                Button(action: {
                    Haptics.selection()
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                        selectedTab = index
                    }
                }) {
                    VStack(spacing: 3) {
                        Image(systemName: item.icon)
                            .font(.system(size: 17, weight: isSelected ? .bold : .regular))
                        Text(language == .arabic ? item.ar : item.en)
                            .font(.system(size: 8.5, weight: .bold, design: .monospaced))
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                    }
                    .foregroundColor(isSelected ? AvionicsTheme.bg : AvionicsTheme.inkDim)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 9)
                    .background(
                        ZStack {
                            if isSelected {
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(AvionicsTheme.mintCyanGradient)
                                    .matchedGeometryEffect(id: "tabHighlight", in: tabNamespace)
                                    .shadow(color: AvionicsTheme.cyan.opacity(0.5), radius: 10, x: 0, y: 4)
                            }
                        }
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(6)
        .glassPanel(accent: AvionicsTheme.cyan, cornerRadius: 22, glow: true, tint: 0.7)
        .padding(.horizontal, 14)
        .padding(.bottom, 6)
    }
}

#Preview {
    ContentView()
}
