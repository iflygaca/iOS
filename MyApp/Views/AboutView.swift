import SwiftUI

struct AboutView: View {
    @Binding var currentLanguage: AppLanguage
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Hero Card
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [.blue, .cyan],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 80, height: 80)
                                .shadow(color: .blue.opacity(0.3), radius: 10)
                            
                            Image(systemName: "airplane")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                        Text(currentLanguage == .arabic ? "كابتن عادل (Captain Adel)" : "Captain Adel")
                            .font(.system(size: 24, weight: .heavy, design: .rounded))
                        
                        Text(currentLanguage == .arabic ? "مدرب الطيران الذكي ومستشارك في لوائح الطيران المدني (GACAR)" : "Bilingual AI Flight Instructor & Saudi Aviation Regulatory Assistant")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        HStack(spacing: 8) {
                            badgePill("Fly GACA", icon: "paperplane.fill", color: .blue)
                            badgePill("HuggingFace CaptAdel", icon: "cpu", color: .purple)
                            badgePill("v1.0.0", icon: "tag.fill", color: .green)
                        }
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.blue.opacity(0.06))
                    )
                    
                    // Model Architecture Card
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "cpu.fill")
                                .foregroundColor(.purple)
                            Text(currentLanguage == .arabic ? "النموذج ومحرك RAG" : "AI & RAG Model Architecture")
                                .font(.headline)
                        }
                        
                        Text(currentLanguage == .arabic ?
                             "كابتن عادل يعتمد على نموذج الاسترجاع الثنائي اللغة (CaptAdel) المنشور على Hugging Face (flygaca/CaptAdel)، والذي تم تدريبه خصيصاً على استرجاع واستخراج مواد لوائح GACAR الـ 74، وأدلة الطيران السعودية والـ FAA." :
                             "Captain Adel is powered by the bilingual (Arabic / English) embedding model flygaca/CaptAdel hosted on Hugging Face. Fine-tuned on all 74 GACAR Parts and aviation handbooks for accurate semantic retrieval.")
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                            .lineSpacing(4)
                        
                        Button(action: {
                            if let url = URL(string: "https://huggingface.co/flygaca/CaptAdel") {
                                openURL(url)
                            }
                        }) {
                            HStack {
                                Image(systemName: "arrow.up.right.square.fill")
                                Text(currentLanguage == .arabic ? "عرض نموذج CaptAdel على HuggingFace" : "View flygaca/CaptAdel on HuggingFace")
                            }
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.purple)
                        }
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.purple.opacity(0.05))
                    )
                    
                    // General Disclaimer Section
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.orange)
                            Text(currentLanguage == .arabic ? "إخلاء مسؤولية مهم" : "Important Legal Disclaimer")
                                .font(.headline)
                        }
                        
                        Text(currentLanguage == .arabic ?
                             "منصة Fly GACA تطبيق مستقل وغير تابعة للهيئة العامة للطيران المدني (GACA). التطبيق مصمم لأغراض التعليم والدراسة الأرضية فقط ولا يجب الاعتماد عليه كمرجع عملي نهائي أثناء الطيران. للحصول على اللوائح والنشرات الرسمية يرجى زيارة gaca.gov.sa." :
                             "Fly GACA and Captain Adel are independent educational projects not officially affiliated with or operated by the General Authority of Civil Aviation (GACA). For operational decisions, always refer directly to official publications at gaca.gov.sa.")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                            .lineSpacing(4)
                        
                        Button(action: {
                            if let url = URL(string: "https://gaca.gov.sa") {
                                openURL(url)
                            }
                        }) {
                            HStack {
                                Image(systemName: "link")
                                Text(currentLanguage == .arabic ? "زيارة موقع GACA الرسمي" : "Visit Official GACA Website (gaca.gov.sa)")
                            }
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.orange)
                        }
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.orange.opacity(0.06))
                    )
                    
                    // App Preferences
                    VStack(alignment: .leading, spacing: 12) {
                        Text(currentLanguage == .arabic ? "إعدادات التطبيق" : "App Preferences")
                            .font(.headline)
                        
                        HStack {
                            Text(currentLanguage == .arabic ? "لغة التطبيق" : "App Language")
                            Spacer()
                            Picker("", selection: $currentLanguage) {
                                ForEach(AppLanguage.allCases) { lang in
                                    Text("\(lang.flagEmoji) \(lang.displayName)").tag(lang)
                                }
                            }
                            .pickerStyle(.menu)
                        }
                        
                        Divider()
                        
                        HStack {
                            Text(currentLanguage == .arabic ? "صناعة في السعودية" : "Made in KSA")
                                .font(.subheadline)
                            Spacer()
                            Text("🇸🇦 صنع في السعودية")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.primary.opacity(0.03))
                    )
                }
                .padding(16)
            }
            .navigationTitle(currentLanguage == .arabic ? "عن التطبيق" : "About Captain Adel")
        }
        .environment(\.layoutDirection, currentLanguage.isRTL ? .rightToLeft : .leftToRight)
    }
    
    private func badgePill(_ text: String, icon: String, color: Color) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 10))
            Text(text)
                .font(.system(size: 11, weight: .bold))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(Capsule().fill(color.opacity(0.12)))
        .foregroundColor(color)
    }
}
