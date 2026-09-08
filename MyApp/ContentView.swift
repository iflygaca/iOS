import SwiftUI

struct ContentView: View {
    @StateObject private var aiService = CaptainAdelAIService()
    @State private var selectedTab: Int = 0
    @State private var currentLanguage: AppLanguage = .english
    
    init() {
        #if canImport(UIKit)
        // Configure Cockpit Avionics TabBar Appearance
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(AvionicsTheme.panel)
        appearance.shadowColor = UIColor(AvionicsTheme.line)
        
        let itemAppearance = UITabBarItemAppearance()
        itemAppearance.normal.iconColor = UIColor(AvionicsTheme.inkDim)
        itemAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(AvionicsTheme.inkDim),
            .font: UIFont.monospacedSystemFont(ofSize: 10, weight: .semibold)
        ]
        
        itemAppearance.selected.iconColor = UIColor(AvionicsTheme.cyan)
        itemAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(AvionicsTheme.cyan),
            .font: UIFont.monospacedSystemFont(ofSize: 10, weight: .bold)
        ]
        
        appearance.stackedLayoutAppearance = itemAppearance
        appearance.inlineLayoutAppearance = itemAppearance
        appearance.compactInlineLayoutAppearance = itemAppearance
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        #endif
    }
    
    var body: some View {
        ZStack {
            AvionicsTheme.bg.ignoresSafeArea()
            
            TabView(selection: $selectedTab) {
                // Tab 1: Captain Adel AI Chat Assistant
                ChatView(aiService: aiService, currentLanguage: $currentLanguage)
                    .tabItem {
                        Label(
                            currentLanguage == .arabic ? "كابتن عادل" : "Capt. Adel",
                            systemImage: "airplane.circle.fill"
                        )
                    }
                    .tag(0)
                
                // Tab 2: GACAR Regulations Library Browser
                GACARLibraryView(aiService: aiService, currentLanguage: $currentLanguage)
                    .tabItem {
                        Label(
                            currentLanguage == .arabic ? "أنظمة GACAR" : "GACAR Corpus",
                            systemImage: "book.pages.fill"
                        )
                    }
                    .tag(1)
                
                // Tab 3: Aviation Tools & Exam Prep
                AviationToolsView(currentLanguage: $currentLanguage)
                    .tabItem {
                        Label(
                            currentLanguage == .arabic ? "الأدوات والاختبار" : "Avionics & Prep",
                            systemImage: "gauge.with.needle.fill"
                        )
                    }
                    .tag(2)
                
                // Tab 4: About Captain Adel & Model Info
                AboutView(currentLanguage: $currentLanguage)
                    .tabItem {
                        Label(
                            currentLanguage == .arabic ? "عن عادل" : "Doctrine",
                            systemImage: "shield.lefthalf.filled"
                        )
                    }
                    .tag(3)
            }
            .accentColor(AvionicsTheme.cyan)
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
