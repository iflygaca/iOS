# Captain Adel iOS (كابتن عادل)

[![CI - Build & Verification](https://github.com/iflygaca/Captain-Adel-iOS/actions/workflows/ci.yml/badge.svg)](https://github.com/iflygaca/Captain-Adel-iOS/actions/workflows/ci.yml)
[![CD - TestFlight Deployment](https://github.com/iflygaca/Captain-Adel-iOS/actions/workflows/testflight.yml/badge.svg)](https://github.com/iflygaca/Captain-Adel-iOS/actions/workflows/testflight.yml)
[![Release](https://img.shields.io/github/v/release/iflygaca/Captain-Adel-iOS?color=22d3ee&label=TestFlight)](https://github.com/iflygaca/Captain-Adel-iOS/releases/tag/v1.0.0)
[![iOS 17+](https://img.shields.io/badge/iOS-17.0%2B-050810.svg?logo=apple&logoColor=white)](https://apple.com)
[![Doctrine](https://img.shields.io/badge/Doctrine-Cite%20or%20Refuse-34d399.svg)](https://captadel.com)
[![Corpus](https://img.shields.io/badge/Corpus-74%20GACAR%20Parts-38bdf8.svg)](https://gaca.gov.sa)
[![Aerodromes](https://img.shields.io/badge/Aerodromes-26%20KSA%20Airports-fbbf24.svg)](https://aviationweather.gov)
[![Quantized RAG](https://img.shields.io/badge/FL380%20RAG-Int8%20Quantized%20%3C1ms-a78bfa.svg)](https://captadel.com)

**Captain Adel (كابتن عادل)** is the high-performance native iOS aviation co-pilot and regulatory avionics suite accompanying [captadel.com](https://captadel.com) and [Fly GACA](https://flygaca.com) — engineered for professional aviators, flight dispatchers, drone operators, and flight students across the Kingdom of Saudi Arabia.

Built strictly under the **"Cite or Refuse"** legal doctrine, Captain Adel provides statutory regulatory citations grounded directly in the official **Saudi Civil Aviation Regulations (GACAR)** published by the General Authority of Civil Aviation ([gaca.gov.sa](https://gaca.gov.sa)).

---

## ✈️ Core Capabilities & Avionics Highlights

### 1. 🌐 Complete 74-Part GACAR Regulatory Corpus (100% On-Device)
- **Comprehensive Coverage**: Fully indexed database spanning all 74 GACAR regulatory parts across all 6 administrative divisions:
  - **Flight Operations**: Part 91 (General Operating Rules), Part 121 (Commercial Air Carriers), Part 125 (Large Airplanes), Part 135 (Commuter/On-Demand), Part 133 (Rotorcraft External Loads), Part 137 (Agricultural), Part 177 (Dangerous Goods), Part 178 (Search & Rescue).
  - **Personnel Licensing**: Part 61 (Pilot Certifications), Part 63 (Flight Engineers/Navigators), Part 64 (Cabin Crew), Part 65 (Dispatchers/Air Traffic Controllers), Part 66 (Aircraft Maintenance Engineers), Part 68 (Drone Remote Pilot Medicals), Part 120 (Drug & Alcohol Testing), Part 141 (Pilot Schools), Part 142 (Training Centers), Part 143 (Flight Simulators & Ground Schools).
  - **Airworthiness & Maintenance**: Part 21 (Certification Procedures), Part 23/25/27/29 (Airworthiness Standards), Part 33 (Engines), Part 35 (Propellers), Part 39 (Airworthiness Directives), Part 43 (Maintenance & Alterations), Part 45 (Identification & Markings), Part 145 (Approved Maintenance Organizations), Part 147 (Maintenance Training).
  - **Airports & Airspace**: Part 71 (Airspace), Part 73 (Special Use Airspace), Part 77 (Safe Flight Obstructions), Part 139 (Aerodrome Certification & ARFF), Part 151/152/156 (Airport Systems & Master Planning), Part 170–176 (Air Traffic Services, Radio Navigation, Weather & NOTAM/AIP).
  - **UAS & Drones**: Part 107 (Commercial Small Unmanned Aircraft Systems), Part 101 (Moored Balloons & Kites), Part 103 (Ultralight Vehicles).
  - **General Safety**: Part 1 (Definitions & Abbreviations), Part 5 (Safety Management Systems - SMS), Part 13 (Enforcement Procedures).
- **One-Tap Statutory Citation Copy**: Instantly copy legal citations formatted for flight logs, dispatch releases, or regulatory filings with visual confirmation.
- **Trending Topic Discovery Chips**: One-tap query filters for `#Part 61`, `#Part 91`, `#Part 107`, `#Part 121`, `#Part 67`, `#Part 139`, `#Part 65`, and `#Part 43`.

---

### 2. ⚡ Offline CoreML & On-Device Quantized RAG Engine (FL380 Disconnected Mode)
- **Zero Internet Requirement**: Designed for unpressurized and pressurized cockpits operating at FL380 with zero connectivity.
- **Int8 Vector Quantization**: Document vector weights are quantized to 8-bit integers (`[-127, 127]`) with dynamic scaling, reducing memory footprint by **75%** and speeding up cosine dot products.
- **BM25 Saturation & Length Normalization**: Industry-standard $k_1 = 1.2, b = 0.75$ ranking with Arabic morphology stemmer (tashkeel, hamza, and alif normalization).
- **Sub-Millisecond L1 Cache**: High-speed thread-safe in-memory cache delivers `< 1ms` retrieval on common cockpit inquiries.
- **Strict "Cite or Refuse" Doctrine**: Enforces a strict cosine threshold (0.28). If a question falls outside the GACAR legal corpus (e.g. suborbital spacecraft or maritime law), Captain Adel explicitly refuses rather than hallucinating:
  > *"I can't ground that in the GACAR corpus. I'd rather refuse than guess — the authoritative source is always GACA at gaca.gov.sa."*
- **Real-Time HUD Telemetry**: Every response displays an active avionics telemetry tag (e.g. `FL380 QUANTIZED RAG (Int8) · §91.151 · 94% MATCH · 1ms`).

---

### 3. 📡 Live Saudi METAR & TAF Weather Engine (26 Aerodromes)
- **Complete Kingdom Coverage**: Decodes live aviation weather directly from NOAA Aviation Weather Center for all **26 Saudi airports**:
  - **International Hubs**: Riyadh (`OERK`), Jeddah (`OEJN`), Dammam (`OEDF`), Madinah (`OEMA`)
  - **Vision 2030 Destinations**: Red Sea International (`OERS`), NEOM Bay (`OENN`), Al Ula (`OEAO`)
  - **Regional & Domestic Aerodromes**: Abha (`OEAB`), Tabuk (`OETB`), Taif (`OETR`), Qassim (`OEGS`), Yanbu (`OEYN`), Jazan (`OEGN`), Al-Ahsa (`OEAH`), Al Baha (`OEBA`), Hail (`OEHL`), Najran (`OENG`), Wadi Al-Dawasir (`OEWD`), Sharurah (`OESH`), Rafha (`OERF`), Bisha (`OEBH`), Arar (`OERR`), Dawadmi (`OEDM`), Al Wajh (`OEWJ`), Qurayyat (`OEGT`), Turaif (`OETR_TURAIF`).
- **Aeronautical Decoders**: Flight category badges (**VFR**, **MVFR**, **IFR**, **LIFR**), crosswind/headwind component resolution, cloud ceiling, temperature/dewpoint spread, and QNH altimeter setting.

---

### 4. 🧮 FMC Flight Computer Suite
Four interactive, real-time aeronautical calculators calibrated to GACAR and ICAO standards:
1. **VFR Fuel Reserve Calculator (§ 91.151)**: Computes cruise fuel and mandatory reserves for Day VFR (30 minutes) and Night VFR (45 minutes) at pilot-specified fuel burn rates.
2. **Crosswind & Headwind Trigonometric Resolver**: Calculates exact crosswind and headwind components given runway magnetic heading and wind vector ($v_{\text{cross}} = V \cdot \sin(\theta)$, $v_{\text{head}} = V \cdot \cos(\theta)$).
3. **High-OAT Density Altitude Computer**: Calculates Pressure Altitude (PA), ISA temperature, and Density Altitude (DA) for extreme Saudi summer heat conditions ($OAT > 45^\circ\text{C}$).
4. **Top of Descent (TOD 3:1 Glide Slope Rule)**: Computes distance to begin descent ($NM = \Delta Alt / 1000 \times 3$), target vertical speed ($FPM = -GS \times 5$), and descent duration in minutes.

---

### 5. 🎓 GACAR Theoretical Exam Prep Bank (26 Questions)
- **Comprehensive Question Bank**: 26 multi-choice questions with bilingual explanations (Arabic & English) covering Part 61, Part 91, Part 107, Part 121, Part 67, and Part 139.
- **Direct Statutory References**: Every answer cites the exact GACAR regulation code (e.g. `GACAR Part 61.57`, `GACAR Part 91.151`, `GACAR Part 107.29`).
- **Interactive Flashcards**: Instant scoring, feedback, and study reference links.

---

### 6. 🎙️ Hands-Free Cockpit Voice Comms Engine
- **Bilingual Speech Recognition (`SFSpeechRecognizer`)**: Real-time microphone capture in Saudi Arabic (`ar-SA`) or English (`en-US`).
- **Automated Silence Detection**: Transmits pilot queries hands-free after 1.4 seconds of silence.
- **Synthesized Voice Radio (`AVSpeechSynthesizer`)**: Plays Captain Adel's regulatory answers over simulated VHF cockpit radio (`COM 1 · 121.500 MHz`).
- **16-Bar Reactive Waveform**: Dynamic neon cyan audio visualizer reflecting microphone input levels.
- **Instant Push-To-Talk (PTT)**: Tap to override transmission and speak immediately.

---

## 🛠️ Architecture & Directory Structure

```
MyApp/
├── MyApp.swift                           # SwiftUI application entry point & lifecycle
├── ContentView.swift                     # Cockpit 4-tab bar & floating navigation capsule
├── AvionicsTheme.swift                   # Glassmorphic themes, colors, typography & haptics
├── Models/
│   ├── GACARModels.swift                 # Chat, citations, categories & METAR data models
│   ├── GACARCorpusDatabase.swift         # Complete 74 GACAR regulatory parts & sections
│   └── AIProviderConfig.swift            # LLM provider settings (Apple Intelligence, Gemini, DeepSeek, Groq)
├── Services/
│   ├── CaptainAdelAIService.swift        # Hybrid cloud/offline AI co-pilot coordinator
│   ├── GACARVectorSearchEngine.swift     # Int8 Quantized RAG Engine & BM25 retrieval
│   ├── CockpitVoiceCommsService.swift    # Speech recognition & voice synthesizer service
│   ├── METARService.swift                # 26 Saudi aerodromes NOAA weather decoder
│   ├── QuizService.swift                 # 26-question GACAR exam prep question bank
│   └── KeychainHelper.swift              # Secure biometric keychain storage for API keys
├── Views/
│   ├── ChatView.swift                    # Cockpit AI chat, prompt chips & PTT voice comms
│   ├── GACARLibraryView.swift            # 74-Part regulatory browser, search & citation copy
│   ├── AviationToolsView.swift           # METAR weather, FMC computers & exam quiz prep
│   ├── AboutView.swift                   # System telemetry, data bank breakdown & doctrine
│   └── Components/
│       ├── HeaderHUDView.swift           # Top avionics HUD bar & FL380 offline toggle
│       ├── AudioWaveformView.swift       # 16-bar reactive audio visualizer
│       ├── CitationCardView.swift        # Interactive statutory citation display card
│       └── AISettingsSheet.swift         # AI provider selection & custom API keys
└── Assets.xcassets                       # AppIcon, Captain Adel portraits, and brand assets
```

---

## 🧪 Automated Unit & Verification Test Suite

A standalone verification suite validates mathematical accuracy, regulatory corpus integrity, and doctrine compliance:

```bash
python3 scripts/run_automated_tests.py
```

### Verified Test Suites (29/29 Passing):
- **Suite 1: FMC Flight Computer Mathematics** (Day/Night VFR fuel reserves §91.151, crosswind trig, Riyadh 45°C density altitude, 3:1 TOD descent).
- **Suite 2: Saudi Aerodromes Coverage** (All 26 aerodromes verified, including Red Sea `OERS` and NEOM `OENN`).
- **Suite 3: Quiz Question Bank Integrity** (26 exam questions verified across Parts 61, 91, 107, 121, 67, 139).
- **Suite 4: GACAR Regulatory Corpus Integrity** (All 74 GACAR parts verified, §91.151 and §121.619 verified).
- **Suite 5: "Cite or Refuse" Doctrine** (Refusal threshold constant, refusal path, and `gaca.gov.sa` grounding verified).

---

## 🚀 Build, Archiving & TestFlight Deployment

### 1. Requirements
- macOS 14+ (Sonoma or Sequoia)
- Xcode 16+ or Xcode Beta
- iOS 17.0+ Simulator or physical device

### 2. Local Build via Xcode
```bash
xcodebuild -project captadel.xcodeproj \
           -scheme MyApp \
           -destination "platform=iOS Simulator,name=iPhone 17" \
           build
```

### 3. Automated TestFlight Archiving
Run the automated archiving script to generate a signed release `.xcarchive` and exportable `.ipa`:
```bash
./scripts/archive_testflight.sh
```

### 4. Fastlane Deployment
```bash
bundle install
bundle exec fastlane beta
```

### 5. Simulator Verification & Live Screenshots
Capture all 4 tabs on a running simulator:
```bash
python3 scripts/capture_ui_test.py
```
Generated screenshots are stored in `fastlane/screenshots/raw/`:
- `01_copilot_chat.png` (Cockpit Copilot Chat & Voice Comms)
- `02_gacar_library.png` (74-Part GACAR Regulatory Library)
- `03_aviation_tools.png` (26 Aerodromes METAR, FMC Calculators & Exam Bank)
- `04_about_doctrine.png` (Avionics Data Bank Telemetry & Cite-or-Refuse Doctrine)

---

## ⚖️ Regulatory Notice & Doctrine

**Captain Adel is an independent educational and pilot decision-support tool developed by Fly GACA.**

- It is **not** an official publication of the General Authority of Civil Aviation (GACA) of the Kingdom of Saudi Arabia.
- It does **not** supersede official GACAR regulations, the AIP-KSA, the Aircraft Flight Manual (AFM/POH), or your airline's Operations Manual (OM-A).
- For operational pre-flight planning and statutory compliance, always cross-reference official GACA publications at [gaca.gov.sa](https://gaca.gov.sa).

---

## 📬 Contact & Official Links

- **Lead Aviator**: Captain Adel (كابتن عادل)
- **Avionics Portal**: [captadel.com](https://captadel.com)
- **Aviation Platform**: [flygaca.com](https://flygaca.com)
- **Official Regulator**: [gaca.gov.sa](https://gaca.gov.sa)
- **Inquiries**: [i@flygaca.com](mailto:i@flygaca.com)
