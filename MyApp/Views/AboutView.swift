import SwiftUI

struct AboutView: View {
    @Binding var currentLanguage: AppLanguage
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        NavigationStack {
            ZStack {
                AvionicsTheme.bg.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        // Hero Portrait Card
                        VStack(spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(AvionicsTheme.teal, lineWidth: 2)
                                    .frame(width: 100, height: 100)
                                
                                Image.captainPortrait
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 96, height: 96)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            
                            VStack(spacing: 4) {
                                HStack(spacing: 6) {
                                    Text(currentLanguage == .arabic ? "كابتن عادل" : "CAPTAIN ADEL")
                                        .font(.system(size: 20, weight: .heavy, design: .monospaced))
                                        .foregroundColor(AvionicsTheme.ink)
                                    Text("ADEL-1")
                                        .font(.system(size: 9, weight: .bold, design: .monospaced))
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(AvionicsTheme.cyan.opacity(0.15))
                                        .foregroundColor(AvionicsTheme.cyan)
                                        .cornerRadius(3)
                                }
                                
                                Text(currentLanguage == .arabic ? "مدرّب الطيران الذكي للوائح الطيران المدني السعودي (GACAR)" : "AI Flight Instructor for Saudi Civil Aviation (GACAR)")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(AvionicsTheme.teal)
                                    .multilineTextAlignment(.center)
                            }
                            
                            HStack(spacing: 8) {
                                badgePill("Fly GACA", icon: "paperplane.fill", color: AvionicsTheme.cyan)
                                badgePill("CaptAdel AI", icon: "cpu", color: AvionicsTheme.mint)
                                badgePill("OERK Base", icon: "location.fill", color: AvionicsTheme.amber)
                            }
                        }
                        .padding(18)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(AvionicsTheme.panel)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(AvionicsTheme.line, lineWidth: 1)
                                )
                        )
                        
                        // captadel.com Doctrine Card: "Cite or Refuse"
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "quote.opening")
                                    .foregroundColor(AvionicsTheme.cyan)
                                Text(currentLanguage == .arabic ? "عقيدة كابتن عادل (THE DOCTRINE)" : "THE DOCTRINE // CITE OR REFUSE")
                                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                                    .foregroundColor(AvionicsTheme.cyan)
                            }
                            
                            Text(currentLanguage == .arabic ?
                                 "«عالم الطيران لا يحتمل التخمين الواثق. يبحث النظام برمجياً في نصوص لوائح GACAR الـ 74 كاملة، وتُسلّم المواد المسترجعة للنموذج، ليجيب عادل منها حصراً. وإذا لم تدعم اللائحة الإجابة، فإنه يعتذر صراحة بدلاً من أن يبتدع إجابة من عنده.»" :
                                 "“Aviation is no place for confident guessing. Retrieval runs in code over the GACAR corpus, the cited passages are handed to the model, and Adel answers only from them. If the corpus can't support the question, he says so — cite or refuse, every time.”")
                                .font(.system(size: 13))
                                .foregroundColor(AvionicsTheme.ink)
                                .lineSpacing(4)
                        }
                        .padding(14)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(AvionicsTheme.panel2)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(AvionicsTheme.teal.opacity(0.4), lineWidth: 1)
                                )
                        )
                        
                        // Model Architecture Card (Hugging Face)
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "cpu.fill")
                                    .foregroundColor(AvionicsTheme.mint)
                                Text(currentLanguage == .arabic ? "النموذج ومحرك الاسترجاع (RAG)" : "AI & EMBEDDINGS ARCHITECTURE")
                                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                                    .foregroundColor(AvionicsTheme.mint)
                            }
                            
                            Text(currentLanguage == .arabic ?
                                 "يعتمد كابتن عادل على نموذج الاسترجاع الثنائي اللغة flygaca/CaptAdel المنشور على Hugging Face، والمُدرّب خصيصاً على نصوص لوائح الطيران المدني السعودي والخرائط الجوية." :
                                 "Powered by the bilingual (Arabic/English) flygaca/CaptAdel embeddings model hosted on Hugging Face. Fine-tuned on all 74 GACAR Parts and aviation handbooks for accurate semantic retrieval.")
                                .font(.system(size: 12.5))
                                .foregroundColor(AvionicsTheme.inkDim)
                                .lineSpacing(3)
                            
                            Button(action: {
                                if let url = URL(string: "https://huggingface.co/flygaca/CaptAdel") {
                                    openURL(url)
                                }
                            }) {
                                HStack(spacing: 4) {
                                    Image(systemName: "arrow.up.right.square")
                                    Text(currentLanguage == .arabic ? "عرض flygaca/CaptAdel على Hugging Face" : "VIEW flygaca/CaptAdel ON HUGGING FACE")
                                }
                                .font(.system(size: 10.5, weight: .bold, design: .monospaced))
                                .foregroundColor(AvionicsTheme.cyan)
                            }
                            .padding(.top, 2)
                        }
                        .padding(14)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(AvionicsTheme.panel)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(AvionicsTheme.line, lineWidth: 1)
                                )
                        )
                        
                        // Legal Disclaimer Card
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(AvionicsTheme.amber)
                                Text(currentLanguage == .arabic ? "إخلاء مسؤولية مهم" : "OFFICIAL REGULATORY DISCLAIMER")
                                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                                    .foregroundColor(AvionicsTheme.amber)
                            }
                            
                            Text(currentLanguage == .arabic ?
                                 "كابتن عادل مشروع تعليمي مستقل وغير تابع رسمياً للهيئة العامة للطيران المدني (GACA). التطبيق مخصص للتعليم والدراسة الأرضية فقط. المرجع الرسمي لكافة اللوائح والتعاميم هو gaca.gov.sa." :
                                 "Captain Adel and Fly GACA are independent educational initiatives not officially affiliated with the General Authority of Civil Aviation (GACA). For operational flight decisions, always consult official publications at gaca.gov.sa.")
                                .font(.system(size: 12))
                                .foregroundColor(AvionicsTheme.inkDim)
                                .lineSpacing(3)
                            
                            Button(action: {
                                if let url = URL(string: "https://gaca.gov.sa") {
                                    openURL(url)
                                }
                            }) {
                                HStack(spacing: 4) {
                                    Image(systemName: "link")
                                    Text(currentLanguage == .arabic ? "زيارة موقع GACA الرسمي" : "OFFICIAL GACA WEBSITE (gaca.gov.sa)")
                                }
                                .font(.system(size: 10.5, weight: .bold, design: .monospaced))
                                .foregroundColor(AvionicsTheme.amber)
                            }
                            .padding(.top, 2)
                        }
                        .padding(14)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(AvionicsTheme.panel)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(AvionicsTheme.amber.opacity(0.4), lineWidth: 1)
                                )
                        )
                        
                        // App Preferences
                        VStack(alignment: .leading, spacing: 12) {
                            Text(currentLanguage == .arabic ? "إعدادات اللغة والمصدر" : "SYSTEM PREFERENCES")
                                .font(.system(size: 11, weight: .bold, design: .monospaced))
                                .foregroundColor(AvionicsTheme.inkDim)
                            
                            HStack {
                                Text(currentLanguage == .arabic ? "لغة الواجهة" : "Primary Language")
                                    .font(.system(size: 13, design: .monospaced))
                                    .foregroundColor(AvionicsTheme.ink)
                                Spacer()
                                Picker("", selection: $currentLanguage) {
                                    ForEach(AppLanguage.allCases) { lang in
                                        Text("\(lang.flagEmoji) \(lang.displayName)").tag(lang)
                                    }
                                }
                                .pickerStyle(.menu)
                            }
                            
                            Divider().background(AvionicsTheme.line)
                            
                            HStack {
                                Text("WEBSITE")
                                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                                    .foregroundColor(AvionicsTheme.inkDim)
                                Spacer()
                                Button(action: {
                                    if let url = URL(string: "https://captadel.com") {
                                        openURL(url)
                                    }
                                }) {
                                    Text("captadel.com ↗")
                                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                                        .foregroundColor(AvionicsTheme.cyan)
                                }
                            }
                        }
                        .padding(14)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(AvionicsTheme.panel)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(AvionicsTheme.line, lineWidth: 1)
                                )
                        )
                    }
                    .padding(14)
                }
            }
            .navigationTitle(currentLanguage == .arabic ? "عن كابتن عادل" : "DOCTRINE & ABOUT")
            .navigationBarTitleDisplayMode(.inline)
        }
        .preferredColorScheme(.dark)
        .environment(\.layoutDirection, currentLanguage.isRTL ? .rightToLeft : .leftToRight)
    }
    
    private func badgePill(_ text: String, icon: String, color: Color) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 8))
            Text(text)
                .font(.system(size: 9.5, weight: .bold, design: .monospaced))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(color.opacity(0.12))
        .foregroundColor(color)
        .overlay(
            RoundedRectangle(cornerRadius: 3)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }
}
