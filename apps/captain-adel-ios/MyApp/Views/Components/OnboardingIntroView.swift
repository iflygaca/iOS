import SwiftUI

struct OnboardingIntroView: View {
    @Binding var currentLanguage: AppLanguage
    @Binding var isPresented: Bool
    @State private var currentStep: Int = 0

    private struct OnboardingStep {
        let icon: String
        let titleEn: String
        let titleAr: String
        let descEn: String
        let descAr: String
        let badgeEn: String
        let badgeAr: String
        let accentColor: Color
    }

    private let steps: [OnboardingStep] = [
        OnboardingStep(
            icon: "airplane.circle.fill",
            titleEn: "Welcome to Captain Adel",
            titleAr: "مرحباً بك في قمرة كابتن عادل",
            descEn: "Your intelligent AI flight instructor and tactical aviation co-pilot, specialized in Saudi General Authority of Civil Aviation (GACAR) regulations.",
            descAr: "مساعدك الذكي ومعلم الطيران المخصص للأنظمة واللوائح المعتمدة من الهيئة العامة للطيران المدني في المملكة العربية السعودية.",
            badgeEn: "TACTICAL FLIGHT CO-PILOT",
            badgeAr: "مساعد الطيران التكتيكي",
            accentColor: AvionicsTheme.cyan
        ),
        OnboardingStep(
            icon: "airplane.departure",
            titleEn: "FL380 Offline Mode",
            titleAr: "وضع الطيران المنعزل FL380",
            descEn: "Equipped with a 100% on-device semantic vector database. Access regulatory knowledge and citations mid-flight without cellular or satellite connection.",
            descAr: "قاعدة بيانات متجهة مدمجة تعمل دون اتصال بالإنترنت 100٪. استرجع اللوائح ومواد الأنظمة في الأجواء عند انقطاع الشبكة.",
            badgeEn: "100% ON-DEVICE RAG",
            badgeAr: "بحث ذكي دون إنترنت",
            accentColor: AvionicsTheme.mint
        ),
        OnboardingStep(
            icon: "mic.badge.waveform.fill",
            titleEn: "Hands-Free Voice Comms",
            titleAr: "اتصال صوتي بدون استخدام اليدين",
            descEn: "Speak directly with Captain Adel during critical flight phases. Audio speech recognition and tactical voice synthesis keep your eyes on the horizon.",
            descAr: "تحدث مع كابتن عادل بصوتك مباشرة خلال مراحل الطيران الحرجة واستمع للإجابات بنطق صوتي متقن لضمان سلامة الطيران.",
            badgeEn: "COCKPIT VOICE COMMS",
            badgeAr: "نظام صوتي تفاعلي",
            accentColor: AvionicsTheme.teal
        ),
        OnboardingStep(
            icon: "checklist.checked",
            titleEn: "Avionics & Checklists",
            titleAr: "أدوات الطيار وقوائم الفحص",
            descEn: "Live METAR decoder for all Saudi airports, crosswind and fuel calculators, GACAR exam prep flashcards, and emergency QRF checklists.",
            descAr: "فك شفرات طقس METAR لجميع مطارات المملكة، وحاسبات الرياح والوقود، وبطاقات استذكار اختبارات الطيران، وقوائم طوارئ تفاعلية.",
            badgeEn: "COMPLETE FLIGHT DECK",
            badgeAr: "حقيبة طيران متكاملة",
            accentColor: AvionicsTheme.gold
        )
    ]

    var body: some View {
        ZStack {
            // Cockpit dark starry backdrop
            AvionicsTheme.bg.ignoresSafeArea()
            CockpitBackdrop().ignoresSafeArea()

            VStack(spacing: 0) {
                // Top Control Bar: Language Switch & Skip Button
                HStack {
                    Button(action: {
                        Haptics.selection()
                        withAnimation {
                            currentLanguage = (currentLanguage == .arabic ? .english : .arabic)
                        }
                    }) {
                        HStack(spacing: 5) {
                            Image(systemName: "globe")
                                .font(.system(size: 11))
                            Text(currentLanguage == .arabic ? "English" : "العربية")
                                .font(.system(size: 11, weight: .bold, design: .monospaced))
                        }
                        .foregroundColor(AvionicsTheme.cyan)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(AvionicsTheme.panel2)
                        .cornerRadius(20)
                        .overlay(Capsule().stroke(AvionicsTheme.cyan.opacity(0.4), lineWidth: 1))
                    }
                    .buttonStyle(.plain)

                    Spacer()

                    Button(action: finishBriefing) {
                        Text(currentLanguage == .arabic ? "تخطي" : "Skip")
                            .font(.system(size: 12, weight: .semibold, design: .monospaced))
                            .foregroundColor(AvionicsTheme.inkDim)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)

                Spacer()

                // Center Slide Carousel
                TabView(selection: $currentStep) {
                    ForEach(steps.indices, id: \.self) { idx in
                        stepSlideView(step: steps[idx], index: idx)
                            .tag(idx)
                    }
                }
                #if !os(macOS)
                .tabViewStyle(.page(indexDisplayMode: .never))
                #endif
                .frame(maxHeight: 520)

                Spacer()

                // Step Indicators & Navigation Action
                VStack(spacing: 16) {
                    // HUD Stepper Dots
                    HStack(spacing: 8) {
                        ForEach(steps.indices, id: \.self) { idx in
                            Capsule()
                                .fill(currentStep == idx ? AvionicsTheme.cyan : AvionicsTheme.line)
                                .frame(width: currentStep == idx ? 24 : 8, height: 6)
                                .animation(.spring(response: 0.3), value: currentStep)
                        }
                    }

                    // Main Action CTA Button
                    Button(action: nextStepOrFinish) {
                        HStack(spacing: 8) {
                            Text(currentStep == steps.count - 1 ?
                                 (currentLanguage == .arabic ? "دخول قمرة القيادة 🛫" : "GET AIRBORNE 🛫") :
                                 (currentLanguage == .arabic ? "المتابعة" : "CONTINUE"))
                                .font(.system(size: 14, weight: .black, design: .monospaced))

                            Image(systemName: currentStep == steps.count - 1 ? "airplane" : "arrow.right")
                                .font(.system(size: 13, weight: .bold))
                        }
                        .foregroundColor(AvionicsTheme.bg)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(AvionicsTheme.mintCyanGradient)
                        )
                        .shadow(color: AvionicsTheme.cyan.opacity(0.4), radius: 10, x: 0, y: 4)
                    }
                    .buttonStyle(.pressable)
                    .padding(.horizontal, 24)
                }
                .padding(.bottom, 32)
            }
        }
        .preferredColorScheme(.dark)
        .environment(\.layoutDirection, currentLanguage.isRTL ? .rightToLeft : .leftToRight)
    }

    private func stepSlideView(step: OnboardingStep, index: Int) -> some View {
        VStack(spacing: 20) {
            // Visual Emblem / Hero Graphic
            ZStack {
                Circle()
                    .fill(step.accentColor.opacity(0.08))
                    .frame(width: 170, height: 170)

                Circle()
                    .stroke(step.accentColor.opacity(0.3), lineWidth: 1.5)
                    .frame(width: 160, height: 160)

                Circle()
                    .stroke(step.accentColor.opacity(0.15), style: StrokeStyle(lineWidth: 1, dash: [4, 4]))
                    .frame(width: 135, height: 135)

                if index == 0 {
                    // Show Captain Adel Avatar as the official app logo!
                    Image.captainAvatar
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 110, height: 110)
                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                        .shadow(color: step.accentColor.opacity(0.45), radius: 12, x: 0, y: 4)
                } else if index == 3 {
                    // Show Pre-Flight Inspection Visual
                    Image.captainWalkaround
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 110, height: 110)
                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                        .shadow(color: step.accentColor.opacity(0.45), radius: 12, x: 0, y: 4)
                } else {
                    Image(systemName: step.icon)
                        .font(.system(size: 54, weight: .light))
                        .foregroundColor(step.accentColor)
                        .shadow(color: step.accentColor.opacity(0.6), radius: 10)
                }
            }
            .padding(.top, 10)

            // Step Badge
            Text(currentLanguage == .arabic ? step.badgeAr : step.badgeEn)
                .font(.system(size: 9.5, weight: .black, design: .monospaced))
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(step.accentColor.opacity(0.18))
                .foregroundColor(step.accentColor)
                .cornerRadius(6)
                .overlay(RoundedRectangle(cornerRadius: 6).stroke(step.accentColor.opacity(0.4), lineWidth: 1))

            // Titles
            VStack(spacing: 8) {
                Text(currentLanguage == .arabic ? step.titleAr : step.titleEn)
                    .font(.system(size: 22, weight: .black, design: .monospaced))
                    .foregroundColor(AvionicsTheme.ink)
                    .multilineTextAlignment(.center)

                Text(currentLanguage == .arabic ? step.descAr : step.descEn)
                    .font(.system(size: 13.5))
                    .lineSpacing(4)
                    .foregroundColor(AvionicsTheme.inkDim)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 28)
            }
        }
        .padding(.horizontal, 16)
    }

    private func nextStepOrFinish() {
        Haptics.medium()
        if currentStep < steps.count - 1 {
            withAnimation(.spring(response: 0.35)) {
                currentStep += 1
            }
        } else {
            finishBriefing()
        }
    }

    private func finishBriefing() {
        Haptics.success()
        UserDefaults.standard.set(true, forKey: "hasCompletedBriefing")
        withAnimation(.easeInOut(duration: 0.3)) {
            isPresented = false
        }
    }
}
