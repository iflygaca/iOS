<div align="center">

# 📱 **Fly GACA iOS**
### Unified Native iOS Suite for Saudi Civil Aviation
#### الموطن الأصلي الموحّد لتطبيقات الطيران المدني السعودي على نظام iOS

<p align="center">
  <img src="https://img.shields.io/badge/Made%20in-Saudi%20Arabia-006C35?style=for-the-badge&labelColor=0a0e12" alt="Saudi Arabia" />
  <img src="https://img.shields.io/badge/Bilingual-EN%20%E2%87%84%20AR-C8A04A?style=for-the-badge&labelColor=0a0e12" alt="Bilingual" />
  <img src="https://img.shields.io/badge/GACAR-74%20Parts%20Database-00e5ff?style=for-the-badge&labelColor=0a0e12" alt="74 GACAR Parts" />
  <img src="https://img.shields.io/badge/Swift-6%20Ready-F05138?style=for-the-badge&logo=swift&logoColor=white&labelColor=0a0e12" alt="Swift 6 Ready" />
  <img src="https://img.shields.io/badge/SwiftUI-iOS%2017%2B-0D96F6?style=for-the-badge&labelColor=0a0e12" alt="iOS 17+" />
  <img src="https://img.shields.io/badge/SRS-FSRS--6%20Engine-00ff88?style=for-the-badge&labelColor=0a0e12" alt="FSRS-6 Spaced Repetition" />
  <img src="https://img.shields.io/badge/FL380-100%25%20Offline%20Capable-8E75B2?style=for-the-badge&labelColor=0a0e12" alt="100% Offline" />
  <img src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge&labelColor=0a0e12" alt="License MIT" />
</p>

[**🌐 Web Platform**](https://flygaca.com) · [**🤖 Captain Adel AI**](https://captadel.com) · [**🤗 Hugging Face Spaces**](https://huggingface.co/spaces/flygaca/captain-adel) · [**🏢 Operations & Governance**](https://github.com/iflygaca/Office)

</div>

---

> [!IMPORTANT]
> **Independent Educational Platform.** Fly GACA is an independent educational initiative and is not affiliated with, endorsed by, or operated by the General Authority of Civil Aviation (GACA) or the Government of Saudi Arabia. The authoritative source for all civil aviation regulations is always [gaca.gov.sa](https://gaca.gov.sa).
>
> **منصة تعليمية مستقلة.** فلاي جاكا منصة تعليمية مستقلة، غير تابعة للهيئة العامة للطيران المدني (GACA) ولا معتمدة منها ولا للحكومة السعودية. الهيئة ([gaca.gov.sa](https://gaca.gov.sa)) هي دائمًا المصدر الرسمي والمعتمد لكافة الأنظمة واللوائح؛ وكلا التطبيقين في هذا المستودع يستشهدان بها ويلتزمان بمرجعيتها.

---

## ⚡ Avionics HUD Telemetry

```asciidoc
========================================================================================
  FLYGACA COCKPIT AVIONICS & NATIVE iOS TELEMETRY
========================================================================================
  [SYSTEM STATUS]       ACTIVE & FLIGHT READY (FL380 PASS)
  [DEPLOYMENT TARGET]   iOS 17.0+ / iPadOS 17.0+ / macOS 14.0+ (Universal Swift)
  [STUDY ENGINE]        FSRS-6 Free Spaced Repetition Scheduler (4-grade, zero-IO)
  [GACAR CORPUS]        74 Complete Regulatory Parts (Parts 1 to 183)
  [VECTOR ENGINE]       Int8 Quantized On-Device Semantic Search (Cosine Threshold >= 0.28)
  [WEATHER NETWORK]     26 Saudi Civil & Military Aerodromes (Live NOAA METAR / TAF)
  [VOICE COMMS]         AVAudioEngine Low-Latency Stream + Bilingual AVSpeech (EN/AR)
  [DATA RESIDENCY]      100% On-Device / Local SQLite & SwiftData / Zero Tracking
========================================================================================
```

---

## 🇸🇦 عن هذا المستودع (بالعربية)

هذا المستودع هو **الموطن الأصلي الموحّد** لكافة تطبيقات فلاي جاكا على أجهزة الآيفون والآيباد. يجمع بين نظامين متكاملين لطاقم الطيران:

1. **فلاي جاكا للتحضير الأكاديمي (`apps/flygaca-ios/`):**
   - حزمة `FlyGACAKit` المستقلة المكتوبة بالكامل بلغة سويفت الحديثة.
   - تطبيق دراسة اختبار كفاءة اللغة الإنجليزية للطيارين (**ELPT**).
   - تطبيق دليل معلومات الطيران السعودي (**AIP**).
   - خوارزمية التكرار المتباعد الذكية **FSRS-6** مع بطاقات الاستذكار ومحاكاة الاختبارات الموقوتة بحد النجاح التنظيمي (75% في 30 دقيقة).

2. **كابتن عادل رفيق قمرة القيادة (`apps/captain-adel-ios/`):**
   - مساعد تنظيمي ملاحي يعمل بدون اتصال بالإنترنت في وضع الطيران (FL380).
   - محرك بحث متجهات ذكي على الجهاز يستوعب جميع **لوائح الطيران المدني السعودي (74 جزءاً كاملاً)**.
   - حاسبات إدارة الرحلة (FMC): حساب الرياح العكسية المتعامدة، وقود VFR النهاري والليلي حسب المادة §91.151، وارتفاع الكثافة.
   - اتصال صوتي ثنائي اللغة (عربي / إنجليزي) وقوائم تفقد قمرة القيادة (Checklists) مع بطاقات استشهاد نظامية موثقة.

---

## 🎯 What's Inside?

This repository houses the unified iOS codebase for Fly GACA under a mono-repo structure, delivering two purpose-built flight bags:

| Flight Bag Application | Subtree Path | Primary Capabilities | Technical Architecture |
| :--- | :--- | :--- | :--- |
| **FlyGACA Study Suite** | [`apps/flygaca-ios/`](apps/flygaca-ios/) | • **ELPT Exam Prep** (Saudi Pilot English)<br>• **AIP Study Bank** (Aeronautical Information)<br>• **FSRS-6 Spaced Repetition Engine**<br>• Timed mock exams with 75% pass gating | Zero-dependency Swift Package (`FlyGACAKit`):<br>`CoreModels` → `StudyEngines` → `ContentKit` → `AppServices` → `PersistenceKit` → `FeatureUI` |
| **Captain Adel Co-Pilot** | [`apps/captain-adel-ios/`](apps/captain-adel-ios/) | • **74-Part GACAR Search** (Grounding cos $\ge$ 0.28)<br>• **Cite-or-Refuse Safety Doctrine**<br>• **FMC Calculators** (Crosswind, VFR Fuel, TOD)<br>• **26 Saudi Aerodromes** (NOAA METAR/TAF)<br>• **Bilingual Cockpit Comms** (Arabic/English) | SwiftUI 5.9+, `GACARVectorSearchEngine` with Int8 Quantization, `AVAudioEngine` real-time audio capture, `CockpitChecklistDatabase` |

---

## 🏛 System Architecture & Convergence Path

```
                                 iflygaca / iOS
                                        │
        ┌───────────────────────────────┴───────────────────────────────┐
        ▼                                                               ▼
apps/flygaca-ios/                                           apps/captain-adel-ios/
┌──────────────────────────────────────┐                   ┌───────────────────────────────────┐
│ FlyGACAKit (Shared SPM)             │                   │ Standalone Avionics Target        │
│ ├─ CoreModels                        │                   │ ├─ GACARCorpusDatabase (74 Parts) │
│ ├─ StudyEngines (FSRS-6)             │                   │ ├─ GACARVectorSearchEngine        │
│ ├─ ContentKit (Signed JSON Loader)   │                   │ ├─ FMC Flight Calculators         │
│ ├─ PersistenceKit (SwiftData)        │                   │ ├─ METARService (26 Aerodromes)   │
│ └─ FeatureUI (Bilingual Views)       │                   │ └─ CockpitVoiceCommsService       │
└──────────────────────────────────────┘                   └───────────────────────────────────┘
        │                                                               │
        └──────────────────────────────┬────────────────────────────────┘
                                       ▼
                       Phase 2 Integration (Planned):
   Export Captain Adel ChatEngine to FlyGACAKit PlatformLive Service Provider
```

### Roadmap to Convergence:
- **Phase 1 (Complete):** Monorepo unification. Both apps build, test, and ship independently with zero cross-contamination.
- **Phase 2 (Active):** Port Captain Adel's RAG and vector retrieval engine into `FlyGACAKit/PlatformLive` via a zero-dependency `ChatClient` protocol seam.
- **Phase 3 (Next):** Unified flight bag app switchable between **Academic Study Mode** and **Cockpit Tarmac Mode**, sharing a unified App Group cache (`group.com.FlyGACA`).

---

## 🚀 Quick Start & Building

### Prerequisites
- macOS 14.0+ (Sonoma or Sequoia)
- Xcode 16.0+ or 27.0+ with iOS 17.0+ Simulator SDK
- Swift 5.9+ toolchain

### 1. Test the Study Suite (`FlyGACAKit`)
The fastest way to verify all academic and spaced-repetition logic:
```bash
cd apps/flygaca-ios/apple/FlyGACAKit
swift test --scratch-path /tmp/flygacakit-build
```

### 2. Run XcodeGen & Open Study Apps
```bash
cd apps/flygaca-ios
npm run ios:generate     # Generates apple/FlyGACA.xcodeproj from project.yml
open apple/FlyGACA.xcodeproj
```

### 3. Build & Run Captain Adel iOS
```bash
cd apps/captain-adel-ios
open captadel.xcodeproj
# Or build directly via CLI:
xcodebuild -project captadel.xcodeproj -scheme MyApp -destination 'generic/platform=iOS Simulator' build
```

### 4. Run Standalone Unit Test Verification
Validate the 31-point flight test suite (74 GACAR parts, crosswind wrap-around, Cite-or-Refuse gate, and checklists):
```bash
cd apps/captain-adel-ios
swiftc -parse-as-library scripts/run_unit_tests.swift MyApp/Models/*.swift MyApp/Services/*.swift MyApp/AvionicsTheme.swift -o /tmp/run_tests && /tmp/run_tests
```

---

## 🧪 Continuous Integration & Workflows

Workflows in `.github/workflows/` are strictly path-scoped to ensure fast and isolated builds:

| Workflow | Path Trigger | Validations Performed |
| :--- | :--- | :--- |
| `flygaca-ios.yml` | `apps/flygaca-ios/**` | Swift package test matrix, XcodeGen synthesis, debug/release archives for ELPT & AIP. |
| `captain-adel-ios-ci.yml` | `apps/captain-adel-ios/**` | Xcodebuild simulator compilation, 74-part corpus schema verification, 31-point flight tests. |
| `captain-adel-ios-testflight.yml` | Tag: `captain-adel-v*.*.*` | Fastlane TestFlight distribution pipeline with automated dSYM upload. |

---

## 🇸🇦 Data Sovereignty & Saudi PDPL Compliance

- **Zero Cloud Reliance in Flight:** All regulatory search, FMC math, and flashcard SRS logic execute 100% on the device.
- **No Personal Identifiable Information:** The apps collect zero biometrics, passport data, or flight manifests.
- **Offline First:** Fully compliant with cockpit electronic flight bag (EFB) regulations when operating with cellular and Wi-Fi antennas disabled.

---

<div align="center">

**Study Offline · Fly Prepared · Master the Regulations**

[Report Issues](https://github.com/iflygaca/ios/issues) · [Discussions](https://github.com/iflygaca/ios/discussions) · [Ecosystem Roster](https://github.com/iflygaca/FlyGACA-Family)

<sub>🇸🇦 صنع في المملكة العربية السعودية · Crafted with excellence in Saudi Arabia</sub>

</div>
