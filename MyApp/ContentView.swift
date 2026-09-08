import SwiftUI

struct ContentView: View {
    @StateObject private var aiService = CaptainAdelAIService()
    @State private var selectedTab: Int = 0
    @State private var currentLanguage: AppLanguage = .english
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Tab 1: Captain Adel AI Chat Assistant
            ChatView(aiService: aiService, currentLanguage: $currentLanguage)
                .tabItem {
                    Label(
                        currentLanguage == .arabic ? "كابتن عادل" : "Captain Adel",
                        systemImage: "airplane.circle.fill"
                    )
                }
                .tag(0)
            
            // Tab 2: GACAR Regulations Library Browser
            GACARLibraryView(aiService: aiService, currentLanguage: $currentLanguage)
                .tabItem {
                    Label(
                        currentLanguage == .arabic ? "أنظمة GACAR" : "GACAR Library",
                        systemImage: "book.closed.fill"
                    )
                }
                .tag(1)
            
            // Tab 3: Aviation Tools & Exam Prep
            AviationToolsView(currentLanguage: $currentLanguage)
                .tabItem {
                    Label(
                        currentLanguage == .arabic ? "الأدوات والاختبار" : "Tools & Quiz",
                        systemImage: "checklist"
                    )
                }
                .tag(2)
            
            // Tab 4: About Captain Adel & Model Info
            AboutView(currentLanguage: $currentLanguage)
                .tabItem {
                    Label(
                        currentLanguage == .arabic ? "عن التطبيق" : "About",
                        systemImage: "info.circle.fill"
                    )
                }
                .tag(3)
        }
        .accentColor(.blue)
    }
}

#Preview {
    ContentView()
}
