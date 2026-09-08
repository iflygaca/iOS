# Captain Adel iOS (كابتن عادل)

[![CI - Build & Verification](https://github.com/iflygaca/Captain-Adel-iOS/actions/workflows/ci.yml/badge.svg)](https://github.com/iflygaca/Captain-Adel-iOS/actions/workflows/ci.yml)
[![CD - TestFlight Deployment](https://github.com/iflygaca/Captain-Adel-iOS/actions/workflows/testflight.yml/badge.svg)](https://github.com/iflygaca/Captain-Adel-iOS/actions/workflows/testflight.yml)
[![Release](https://img.shields.io/github/v/release/iflygaca/Captain-Adel-iOS?color=22d3ee&label=TestFlight)](https://github.com/iflygaca/Captain-Adel-iOS/releases/tag/v1.0.0)
[![iOS 17+](https://img.shields.io/badge/iOS-17.0%2B-050810.svg?logo=apple&logoColor=white)](https://apple.com)
[![Doctrine](https://img.shields.io/badge/Doctrine-Cite%20or%20Refuse-34d399.svg)](https://captadel.com)
[![FL380 Mode](https://img.shields.io/badge/FL380%20Mode-100%25%20Offline%20RAG-22d3ee.svg)](https://captadel.com)

An intelligent cockpit flight instructor and regulatory co-pilot for your iPhone and iPad. **Captain Adel (كابتن عادل)** is the native iOS application accompanying [captadel.com](https://captadel.com) and [Fly GACA](https://flygaca.com) — an independent educational and operational aeronautical reference for civil aviation in the Kingdom of Saudi Arabia.

Study Saudi civil aviation regulations, prepare for GACA theoretical examinations, verify FMC fuel/crosswind calculations, listen to live NOAA aviation weather for 18 Saudi airports, and converse hands-free with an AI co-pilot that strictly cites exact GACAR regulatory articles.

---

##  cockpit Highlights & Features

### 🛩️ FL380 Flight Mode (100% Offline GACAR Vector Search)
- **Zero Network Required**: Operates in pressurized cockpits at Flight Level 380 with complete disconnection from the internet.
- **Complete 74 GACAR Parts**: Comprehensive on-device corpus spanning all 6 regulatory divisions (Part 1 Definitions, Part 61 Pilot Certifications, Part 91 Operating Rules, Part 121 Commercial Operators, Part 145 Repair Stations, Aerodromes, SMS, etc.).
- **On-Device Vector Space Engine**: Fast TF-IDF tokenization and Cosine Similarity retrieval (<3ms latency) with bilingual Arabic/English text normalization (tashkeel, hamza, and aviation token handling).
- **Strict Cite-or-Refuse Doctrine**: Strict 0.28 cosine similarity thresholding. If a query lacks definitive statutory grounding in the GACAR regulations, Captain Adel explicitly refuses rather than hallucinating citations.
- **HUD Telemetry Tagging**: Every answer displays active retrieval telemetry (e.g. `FL380 RAG · §91.155 · 94% MATCH · 2ms`).

### 🎙️ Hands-Free Cockpit Voice Comms Engine
- **Bilingual Speech Recognition (`SFSpeechRecognizer`)**: Real-time microphone capture in Saudi Arabic (`ar-SA`) or English (`en-US`).
- **Hands-Free Transmission**: Automatic 1.4-second silence detection sends pilot queries hands-free.
- **Synthesized Voice Radio (`AVSpeechSynthesizer`)**: Speaks Captain Adel's regulatory answers over simulated VHF cockpit radio (`COM 1 · 121.500 MHz`).
- **Instant Interruption**: Tap the Push-To-Talk (PTT) neon button to immediately cut transmission and speak.
- **Reactive Waveform**: 16 dynamic neon cyan/mint audio bars responding directly to microphone energy levels.

### 📡 Live Saudi METAR/TAF Aviation Weather Engine
- **Real-Time NOAA Aviation Feed**: Direct feed from `aviationweather.gov` for 18 civil aerodromes:
  - **Major Hubs**: Riyadh (`OERK`), Jeddah (`OEJN`), Dammam (`OEDF`), Madinah (`OEMA`)
  - **Regional & Desert Fields**: Abha (`OEAB`), Al Ula (`OEAO`), Tabuk (`OETB`), Taif (`OETR`), Qassim (`OEGS`), Yanbu (`OEYN`), Jazan (`OEGN`), Al-Ahsa (`OEAH`), Al Baha (`OEBA`), Hail (`OEHL`), Najran (`OENG`), Wadi Al-Dawasir (`OEWD`), Sharurah (`OESH`), Rafha (`OERF`)
- **Automated Flight Categories**: Color-coded badges for **VFR** (Mint), **MVFR** (Cyan), **IFR** (Amber), and **LIFR** (Purple).
- **Terminal Display & Grid**: High-contrast cockpit terminal card with decoded wind vectors, crosswinds, flight visibility, temperature/dewpoint, and QNH altimeter settings.
- **Pull-To-Refresh**: Native `.refreshable` support with offline cached fallback.

### 🎨 Avionics Cockpit UI (`captadel.com` Parity)
- Deep midnight avionics palette (`#050810`, `#0c1220`, `#22d3ee`, `#34d399`, `#fbbf24`).
- Rotating live status glow ring, callsign badge (`ADEL-1`), glassmorphic panels, and tactile spring haptic feedback.
- Full bilingual English and Arabic layout with native Right-to-Left (RTL) typography.

---

## 🛠️ Architecture & Tech Stack

```
MyApp/
├── MyApp.swift                           # SwiftUI App entry point
├── ContentView.swift                     # Cockpit tab navigation & floating capsule bar
├── AvionicsTheme.swift                   # Glassmorphism, colors, fonts, haptics & styling
├── Models/
│   ├── GACARModels.swift                 # Chat, citations, METAR & quiz data structures
│   ├── GACARCorpusDatabase.swift         # On-device 74 GACAR regulatory parts & sections
│   └── AIProviderConfig.swift            # Provider configuration & credentials
├── Services/
│   ├── CaptainAdelAIService.swift        # Hybrid cloud/offline AI co-pilot coordinator
│   ├── GACARVectorSearchEngine.swift     # On-device TF-IDF & Cosine Similarity vector engine
│   ├── CockpitVoiceCommsService.swift    # SFSpeechRecognizer & AVSpeechSynthesizer engine
│   ├── METARService.swift                # Live NOAA aviation weather fetcher & decoder
│   ├── QuizService.swift                 # GACAR exam prep questions & flashcards
│   └── KeychainHelper.swift              # Secure local token & key storage
└── Views/
    ├── ChatView.swift                    # Cockpit AI chat & Voice Assistant modal
    ├── GACARLibraryView.swift            # 74-Part regulatory browser & search
    ├── AviationToolsView.swift           # METAR weather, exam prep & FMC calculators
    ├── AboutView.swift                   # System telemetry, model info & credentials
    └── Components/
        ├── HeaderHUDView.swift           # Avionics HUD bar & FL380 quick toggle
        ├── AudioWaveformView.swift       # 16-bar reactive audio visualizer
        ├── CitationCardView.swift        # Interactive GACAR statutory citation card
        └── AISettingsSheet.swift         # AI engine, FL380 mode & telemetry settings
```

- **Framework**: SwiftUI (iOS 17.0+)
- **Speech**: Apple `Speech` & `AVFoundation`
- **Networking**: `URLSession` with background retry and offline cache
- **Build System**: Xcode 16+ / Xcode Beta (`captadel.xcodeproj`)
- **Bundle ID**: `com.flygaca.captainadel`

---

## 🚀 Quick Start & Development

### Requirements
- **macOS** Sonoma or Sequoia (macOS 14+)
- **Xcode** 16.0 or Xcode-beta
- **iOS Simulator** or physical device running **iOS 17.0+**

### Local Build & Run

1. **Clone the repository:**
   ```bash
   git clone https://github.com/iflygaca/Captain-Adel-iOS.git
   cd Captain-Adel-iOS
   ```

2. **Open the Xcode Project:**
   ```bash
   open captadel.xcodeproj
   ```

3. **Build via Command Line:**
   ```bash
   xcodebuild -project captadel.xcodeproj \
              -scheme MyApp \
              -destination "platform=iOS Simulator,name=iPhone 17 Pro" \
              build
   ```

---

## 📦 App Store & TestFlight Deployment

Captain Adel iOS includes automated CI/CD pipelines and local archiving scripts:

### Option 1: Standalone Local Archiving (1-Command)
```bash
./scripts/archive_testflight.sh
```
Builds `build/MyApp.xcarchive`, exports a signed `.ipa` using `ExportOptions.plist`, and prepares it for Xcode Organizer or upload.

### Option 2: Fastlane Beta Delivery
```bash
bundle install
bundle exec fastlane beta
```

### Option 3: GitHub Actions Continuous Deployment
Pushing any version tag (e.g. `v1.0.0`) or triggering the manual dispatch workflow in GitHub Actions executes [`.github/workflows/testflight.yml`](.github/workflows/testflight.yml), compiling and shipping the build to TestFlight automatically.

For complete developer account setup, refer to [**`TESTFLIGHT_READINESS.md`**](TESTFLIGHT_READINESS.md).

---

## ⚖️ Regulatory Disclaimer

**Captain Adel is an independent educational and pilot reference tool developed by Fly GACA.**

- It is **not** an official publication of the General Authority of Civil Aviation (GACA) of the Kingdom of Saudi Arabia.
- It does **not** replace the official GACAR publications, the AIP-KSA, your aircraft's Airplane Flight Manual (AFM/POH), or your air carrier's approved operations manuals.
- For operational pre-flight planning and in-flight legal compliance, always cross-verify with official GACA sources at [gaca.gov.sa](https://gaca.gov.sa).

---

## 📬 Contact & Inquiries

- **Lead Aviator**: Captain Adel (كابتن عادل)
- **Website**: [captadel.com](https://captadel.com) & [flygaca.com](https://flygaca.com)
- **Email**: [i@flygaca.com](mailto:i@flygaca.com)
- **Repository**: [github.com/iflygaca/Captain-Adel-iOS](https://github.com/iflygaca/Captain-Adel-iOS)
