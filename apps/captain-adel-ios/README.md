# Captain Adel iOS (كابتن عادل)

[![CI - Build & Verification](https://github.com/iflygaca/Captain-Adel-iOS/actions/workflows/ci.yml/badge.svg)](https://github.com/iflygaca/Captain-Adel-iOS/actions/workflows/ci.yml)
[![CD - TestFlight Deployment](https://github.com/iflygaca/Captain-Adel-iOS/actions/workflows/testflight.yml/badge.svg)](https://github.com/iflygaca/Captain-Adel-iOS/actions/workflows/testflight.yml)
[![Release](https://img.shields.io/github/v/release/iflygaca/Captain-Adel-iOS?color=22d3ee&label=TestFlight)](https://github.com/iflygaca/Captain-Adel-iOS/releases/tag/v1.0.0)
[![iOS 17+](https://img.shields.io/badge/iOS-17.0%2B-050810.svg?logo=apple&logoColor=white)](https://apple.com)
[![Doctrine](https://img.shields.io/badge/Doctrine-Cite%20or%20Refuse-34d399.svg)](https://captadel.com)
[![FL380 Mode](https://img.shields.io/badge/FL380%20Mode-100%25%20Offline%20RAG-22d3ee.svg)](https://captadel.com)
[![Hugging Face Space](https://img.shields.io/badge/🤗%20Hugging%20Face-Space%20Demo-yellow.svg)](https://huggingface.co/spaces/flygaca/captain-adel)
[![Hugging Face Model](https://img.shields.io/badge/🤗%20Hugging%20Face-CaptAdel%20Model-orange.svg)](https://huggingface.co/flygaca/CaptAdel)
[![Hugging Face Dataset](https://img.shields.io/badge/🤗%20Hugging%20Face-174%20Evals-blue.svg)](https://huggingface.co/datasets/flygaca/gacar-assistant-evals)

An intelligent cockpit flight instructor and regulatory co-pilot for your iPhone and iPad. **Captain Adel (كابتن عادل)** is the native iOS application accompanying [captadel.com](https://captadel.com) and [Fly GACA](https://flygaca.com) — an independent educational and operational aeronautical reference for civil aviation in the Kingdom of Saudi Arabia.

Study Saudi civil aviation regulations, prepare for GACA theoretical examinations, verify FMC fuel/crosswind calculations, listen to live NOAA aviation weather for 18 Saudi airports, and converse hands-free with an AI co-pilot that strictly cites exact GACAR regulatory articles.

---

## 🏗 Fly GACA Family & Ecosystem

[📚 FlyGACA Web & API](https://github.com/iflygaca/FlyGACA) • 
[🤖 Captain Adel Core Engine](https://github.com/iflygaca/Captain-Adel) • 
[🤗 Hugging Face Models & Space](https://huggingface.co/flygaca) •
[📱 Unified iOS Apps](https://github.com/iflygaca/ios) • 
[🏢 Office & Governance](https://github.com/iflygaca/Office)

---

## 🇸🇦 عن التطبيق (بالعربية)

**كابتن عادل (Captain Adel)** مساعد طيران ذكي أصلي على الآيفون والآيباد، يعمل رفيقًا تنظيميًا
داخل قمرة القيادة. يتيح دراسة لوائح الطيران المدني السعودي (GACAR)، التحضير لاختبارات GACA
النظرية، التحقق من حسابات الوقود والرياح المعاكسة، والاستماع لتقارير الطقس الحية (METAR/TAF)
لـ 18 مطارًا سعوديًا — كل ذلك بلا اتصال بالإنترنت في وضع **FL380**. يدعم التطبيق التحدث الصوتي
بالعربية والإنجليزية، ويلتزم بمبدأ "استشهد أو امتنع": لا يستشهد بمادة نظامية إلا إذا كانت موجودة
فعليًا في المرجع الرسمي.

---

## 🖼️ Visuals

<div align="center">

| Cockpit Chat | Voice Comms | METAR/TAF Weather |
|:---:|:---:|:---:|
| ![Cockpit chat screenshot placeholder](https://placehold.co/280x580/050810/22d3ee?text=Cockpit+Chat) | ![Voice comms screenshot placeholder](https://placehold.co/280x580/050810/34d399?text=Voice+PTT) | ![METAR weather screenshot placeholder](https://placehold.co/280x580/050810/fbbf24?text=METAR+TAF) |

*Real device captures pending — placeholders mark where App Store screenshots will land.*

</div>

---

> [!IMPORTANT]
> **This repo's full history has been merged into [`iflygaca/ios`](https://github.com/iflygaca/ios)**,
> as `apps/captain-adel-ios/`, alongside FlyGACA iOS at `apps/flygaca-ios/` — the first step
> toward the Fly GACA family's one native-app vision (a single flagship app spanning study
> modules and the AI Instructor). This repo is **not archived or deleted**: it keeps working
> exactly as before (CI, TestFlight, issues, PRs) until a human decides otherwise, but new work
> should generally target `iflygaca/ios` going forward. See that repo's `apps/README.md` for what
> the merge did and what's still open.

---

## 🛩️ Cockpit Highlights & Features

### 🛩️ FL380 Flight Mode (100% Offline GACAR Vector Search)

**Why offline matters:** Airspace over the Kingdom is civilian; the internet is not airborne. Captain Adel iOS operates at Flight Level 380 with zero network dependency — the entire 74-part GACAR corpus, instructor brain, and voice co-pilot live on-device.

- **Zero Network Required**: Operates in pressurized cockpits with complete internet disconnection. No cellular, no WiFi, no fallback to cloud. The app is a self-contained regulatory reference and flight instructor.
- **Complete 74 GACAR Parts**: Comprehensive on-device corpus spanning all 6 regulatory divisions (Part 1 Definitions, Part 61 Pilot Certifications, Part 91 Operating Rules, Part 121 Commercial Operators, Part 145 Repair Stations, Aerodromes, SMS, etc.) — bundled as `Content/quiz.json` at build time, fetched from `https://flygaca.com/data/` at refresh time.
- **On-Device Vector Space Engine**: Deterministic TF-IDF tokenization and Cosine Similarity retrieval (<3ms latency) with bilingual Arabic/English text normalization (diacritics, hamza combinations, and aviation term handling). No neural embeddings, no model inference — pure deterministic math. Reproducible every time; never hallucinated.
- **Strict Cite-or-Refuse Doctrine**: The safety boundary. A cosine similarity threshold of **0.28** gates every answer. If a query's grounding score falls below that threshold, Captain Adel **explicitly refuses** rather than speculate. This is not a "confidence score" — it is an SOP. Example refusal: *"Your question isn't addressed in GACAR. Consult your Chief Pilot."* The doctrine is load-bearing; it is never relaxed for UX smoothness.
- **HUD Telemetry Tagging**: Every answer displays active retrieval telemetry (e.g. `FL380 RAG · §91.155 · 94% MATCH · 2ms`), showing exactly which Part/section answered the question, the match score, and latency — auditable grounding.

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

### 🌐 Hybrid Cloud/Offline Architecture

Captain Adel iOS has two modes that work seamlessly:

- **FL380 Mode (Offline, Default):** Uses the bundled on-device vector engine. Every answer is grounded to a cosine-similarity score against the on-device corpus. No external call; no latency beyond local TF-IDF. Use case: in-flight regulatory lookups, exam prep, dead-stick navigation reference.

- **Connected Mode (Cloud-Enhanced, Optional):** When internet is available (on the ground), Captain Adel can reach the Captain-Adel backend service (`captadel.com`) and consult the server-side instructor brain. The backend runs the same Cite-or-Refuse doctrine but with access to learner progress data, streaming multi-turn conversation, and voice output via the radio simulator. Same on-device corpus verification applies — if the backend answer fails the threshold, the app refuses it too.

Both modes answer the same way (cite exactly or refuse); the difference is depth. Connected mode can say *"You've trained 23 hours this month; let me personalize this explanation"* or stream a longer, conversational answer. Offline mode says *"§91.155 requires this"* with a link to the regulation.

The mode toggle lives in settings; the app never sneaks to the cloud.

### 🎨 Avionics Cockpit UI (`captadel.com` Parity)
- Deep midnight avionics palette (`#050810`, `#0c1220`, `#22d3ee`, `#34d399`, `#fbbf24`) — the same teal/sage/gold/clay as the web product's Falcon Theme.
- Rotating live status glow ring, callsign badge (`ADEL-1`), glassmorphic panels, and tactile spring haptic feedback.
- Full bilingual English and Arabic layout with native Right-to-Left (RTL) typography.
- **Why this matters for developers:** The UI is not a creative choice; it enforces the offline-first and deterministic-safety posture. Glassy panels signal data transparency; the telemetry badge means "here's exactly what grounded this answer"; the dark palette means legible in direct sunlight and cockpit overhead lighting.

---

## 🔐 Safety Constraints & Load-Bearing Decisions

Before you code: understand what cannot be changed here without breaking the app's core promise.

### The Cite-or-Refuse threshold is not configurable
The 0.28 cosine similarity threshold in `GACARVectorSearchEngine.swift` is **not** a tuning knob. It was set by analysis of the regulatory corpus structure, aviation safety requirements, and pilot misunderstanding patterns. Lowering it (e.g., to 0.20 for "more answers") introduces hallucination risk. Raising it (e.g., to 0.40 for "safer answers") makes the app useless — too many legitimate queries get refused. **Do not change it.** If a query *should* answer but doesn't, the root cause is corpus coverage, not the threshold.

### Offline-first is the safety envelope
The app's no-network default is not a feature; it is a constraint. Removing it or making cloud-mode default undermines the app's core value (regulatory reference, always available). Do not add features that only work cloud-connected. Do not auto-sync to cloud on any background condition. Do not store learner identifiable information on-device in plaintext.

### Bilingual correctness is a safety property
Arabic diacritization, hamza handling, and RTL layout are not cosmetics. A pilot reading an Arabic warning with wrong diacritics may parse it as a different word, with different meaning. Test Arabic text changes on real devices; do not assume iOS `Text` handles all Arabic normalization. The terminology glossary (`ar/_GLOSSARY.md` in Office) is the source of truth for regulatory Arabic; stay synchronized.

### The telemetry badge is mandatory
Every answer **must** show its grounding source (which Part/section, match score, latency). Do not hide this in settings or strip it for a "cleaner" UI. The badge is the pilot's receipt — proof that the answer came from official GACAR, not a guess.

---

## 🧪 Automated 31-Point Flight Verification Suite

Captain Adel iOS includes an automated aeronautical domain and regulatory integrity test suite executed via GitHub Actions CI and local test runners:

```bash
swiftc -sdk $(xcrun --show-sdk-path) MyApp/Models/*.swift MyApp/Services/*.swift scripts/run_unit_tests.swift -o /tmp/run_tests
/tmp/run_tests
```

### Verification Coverage:
- **Suite 1: 74-Part GACAR Corpus Integrity**: Validates all 74 regulatory parts across Divisions I–VI, zero duplicate IDs, and essential pilot parts (Parts 1, 61, 67, 91, 107, 121, 145).
- **Suite 2: On-Device Vector Search & Arabic Normalization**: Strips Arabic diacritics (tashkeel), normalizes Alef/Hamza variants, verifies $\ge 0.28$ cosine threshold acceptance on VFR minima, validates refusal on ungrounded queries, and sub-millisecond retrieval latency ($<1.0\text{ ms}$).
- **Suite 3: NOAA Aviation Weather & Vector Trigonometry**: Verifies all 18 Saudi aerodromes (`OE*`), crosswind angle normalization across $360^\circ$ north wrap-around, and tailwind warning flags.
- **Suite 4: FMC Flight Computers & Checklists**: Verifies GACAR §91.151 VFR day (30 min) / night (45 min) fuel reserves and cockpit checklist state progression.
- **Suite 5: Dynamic Citation Extraction**: Strict regex boundary matching to eliminate false-positive cross-part citations.

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

## 📦 Integration with the Fly GACA Family

### Where this code lives now
This repo's full history was merged into [`iflygaca/ios`](https://github.com/iflygaca/ios) as `apps/captain-adel-ios/` in August 2026. The merge was **not a deletion**; this repo stays live and independent, still running CI and TestFlight. But new work should start from `iflygaca/ios`, which also holds `apps/flygaca-ios/` (the study apps ELPT, AIP on shared `FlyGACAKit`).

**Why the merge?** The long-term vision is one native app that spans study, calculators, AI instructor, and regulations. Today that's infrastructure work (SwiftUI composition root, AppServices protocol layer, shared data store); the apps are still side-by-side. See `iflygaca/ios/apps/README.md` for the three-phase integration roadmap.

### Corpus ownership & sync
Captain Adel iOS reads the GACAR corpus from `https://flygaca.com/data/quiz.json`. That file is published by the **FlyGACA repository** — the product monorepo. This repo does not own, build, or version the corpus; it **consumes** it.

- **Content refresh:** The app fetches `quiz.json` and verifies it against a detached Ed25519 signature (`quiz.json.sig`). If the signature doesn't match, the refresh is **rejected** and the app continues with its bundled snapshot.
- **Signature key:** The public key lives in `Info.plist` as `FGCorpusPublicKey`. It is provisioned at build time via Xcode, not checked into this repo. This prevents arbitrary corpus replacement.
- **Bundled snapshot:** Every Xcode build includes a copy of the current `quiz.json` from FlyGACA. If the network is down or the remote signature is invalid, the app still works because it has this on-device copy.

### Voice assistant and backend integration
The cockpit voice features (speech recognition, synthesized VHF radio answers) connect to the **Captain-Adel backend service** (`captadel.com`). That service is built and deployed from the separate `iflygaca/Captain-Adel` repository.

- **What the backend does:** Instructor persona, learner-signal collection, streaming multi-turn conversation, account/progress sync.
- **What this iOS app does:** Voice I/O, offline-first UI, and local vector search as the fallback.
- **Failure mode:** If `captadel.com` is down, the app falls back to FL380 mode (on-device vector search only). The radio simulator still works; answers just come from the local corpus instead of the streaming instructor.

### The family contract
All repos in the family share `contracts/flygaca-family.json` — a byte-identical JSON file that defines:
- Legal entity facts (from Office)
- Chat protocol shape (from FlyGACA)
- Active repo roster (from Office)

If you change anything that would affect this contract (e.g., app name, icon, or chat message shape), the change must be synced to all three repos and gated by CI. The gate is there to catch integration bugs before they ship.

---

## ⚖️ Regulatory Disclaimer

**Captain Adel is an independent educational and pilot reference tool developed by Fly GACA.**

- It is **not** an official publication of the General Authority of Civil Aviation (GACA) of the Kingdom of Saudi Arabia.
- It does **not** replace the official GACAR publications, the AIP-KSA, your aircraft's Airplane Flight Manual (AFM/POH), or your air carrier's approved operations manuals.
- For operational pre-flight planning and in-flight legal compliance, always cross-verify with official GACA sources at [gaca.gov.sa](https://gaca.gov.sa).

**كابتن عادل أداة تعليمية مرجعية مستقلة من فلاي جاكا.** وهو غير تابع للهيئة العامة للطيران المدني
(GACA) ولا معتمد منها، ولا يغني عن لوائح GACAR الرسمية أو دليل معلومات الطيران AIP-KSA. للتخطيط
التشغيلي والامتثال القانوني، يُرجى دائمًا الرجوع إلى المصادر الرسمية على [gaca.gov.sa](https://gaca.gov.sa).

---

## 📬 Contact & Inquiries

- **Lead Aviator**: Captain Adel (كابتن عادل)
- **Website**: [captadel.com](https://captadel.com) & [flygaca.com](https://flygaca.com)
- **Email**: [i@flygaca.com](mailto:i@flygaca.com)
- **Repository**: [github.com/iflygaca/Captain-Adel-iOS](https://github.com/iflygaca/Captain-Adel-iOS)
