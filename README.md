<div align="center">

# 📱 **Fly GACA iOS**
### The Unified Native iOS Home for the Fly GACA Family
#### التطبيقات الأصلية الموحّدة لعائلة فلاي جاكا على الآيفون

<p align="center">
  <img src="https://img.shields.io/badge/Made%20in-Saudi%20Arabia-006C35?style=for-the-badge&labelColor=0a0e12" alt="صنع في السعودية" />
  <img src="https://img.shields.io/badge/Bilingual-EN%20%E2%87%84%20AR-C8A04A?style=for-the-badge&labelColor=0a0e12" alt="Bilingual EN/AR" />
  <img src="https://img.shields.io/badge/STATUS-MERGED%20HOME-00ff88?style=for-the-badge&labelColor=0a0e12" alt="Status: Merged Home" />
  <img src="https://img.shields.io/badge/Swift-5.9%2B-F05138?style=for-the-badge&logo=swift&logoColor=white&labelColor=0a0e12" alt="Swift 5.9+" />
  <img src="https://img.shields.io/badge/SwiftUI-iOS%2017%2B-0D96F6?style=for-the-badge&labelColor=0a0e12" alt="SwiftUI iOS 17+" />
  <img src="https://img.shields.io/badge/Offline-100%25%20Capable-8E75B2?style=for-the-badge&labelColor=0a0e12" alt="100% Offline" />
  <img src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge&labelColor=0a0e12" alt="License MIT" />
</p>

</div>

---

## 🏗 Fly GACA Family

[📚 FlyGACA Web & API](https://github.com/iflygaca/FlyGACA) • 
[🤖 Captain Adel AI](https://github.com/iflygaca/Captain-Adel) • 
[📱 Unified iOS Apps (this repo)](https://github.com/iflygaca/ios) • 
[🏢 Office & Governance](https://github.com/iflygaca/Office)

---

> [!IMPORTANT]
> **Independent Educational Platform.** Fly GACA is an independent educational platform, not
> affiliated with, endorsed by, or operated by GACA or the Government of Saudi Arabia. GACA
> ([gaca.gov.sa](https://gaca.gov.sa)) is always the authoritative source; both apps in this repo
> cite it and defer to it.
>
> **منصة تعليمية مستقلة.** فلاي جاكا منصة تعليمية مستقلة، غير تابعة للهيئة العامة للطيران المدني
> (GACA) ولا معتمدة منها ولا للحكومة السعودية. الهيئة ([gaca.gov.sa](https://gaca.gov.sa)) هي
> دائمًا المصدر الرسمي؛ وكلا التطبيقين في هذا المستودع يستشهدان بها ويلتزمان بمرجعيتها.

---

## 🇸🇦 عن هذا المستودع (بالعربية)

هذا المستودع هو **الموطن الأصلي الموحّد** لتطبيقات فلاي جاكا على الآيفون. يضم التاريخ الكامل
لمستودعين كانا منفصلين، وكل منهما محفوظ كشجرة مستقلة تحت `apps/`:

- **فلاي جاكا للآيفون** (`apps/flygaca-ios/`) — حزمة `FlyGACAKit` وتطبيقا الدراسة **ELPT** و
  **AIP**: تحضير للاختبارات، بطاقات تعليمية، تكرار متباعد، واختبارات محاكاة.
- **كابتن عادل للآيفون** (`apps/captain-adel-ios/`) — تطبيق "كابتن عادل" المستقل، رفيق تنظيمي
  لقمرة القيادة يعمل بلا اتصال بالإنترنت، مع بحث نصي على الجهاز واتصال صوتي ثنائي اللغة وطقس حي.

هذا الدمج **خطوة أولى نحو رؤية تطبيق واحد موحّد** يجمع الدراسة والحاسبات ومدرّب الذكاء الاصطناعي
واللوائح التنظيمية في مكان واحد. كل تطبيق لا يزال يُبنى ويُنشر بشكل مستقل تمامًا كما كان في
مستودعه الخاص — هذا دمج جنبًا إلى جنب وليس تكاملًا معماريًا عميقًا بعد.

---

## 🎯 What's this?

This repo merges the full git history of two previously separate repositories, each kept
as its own top-level app under `apps/` — they build independently, they test independently,
and they ship independently today:

| App | Path | What it solves |
| --- | --- | --- |
| **FlyGACA iOS** | [`apps/flygaca-ios/`](apps/flygaca-ios/) | **Structured learning for exam modules.** The `FlyGACAKit` Swift package family (ELPT, AIP) — exam prep, flashcards with spaced repetition, mock exams timed to regulatory pass marks (75% in 30 minutes). Everything offline; study progress syncs across app targets. Built on a zero-dependency package (`CoreModels` → `StudyEngines`/`ContentKit`/`AppServices`/`PersistenceKit` → `PlatformLive` → `FeatureUI`) so Swift changes are instant to test. |
| **Captain Adel iOS** | [`apps/captain-adel-ios/`](apps/captain-adel-ios/) | **Regulatory lookup on the tarmac.** The standalone "Captain Adel" cockpit app — an offline GACAR regulatory co-pilot with on-device vector search (TF-IDF + cosine similarity), bilingual voice comms (EN/AR, text-to-speech), and live METAR/TAF weather for 61 Saudi aerodromes. No internet required after the first run. Built for the moment a crew needs to verify a procedure *before* takeoff. |

### The Vision: One App
The Fly GACA family's goal has always been **"Academics, Calculators, AI Instructor, Regulations"** in a single native experience. Today, these two apps are side-by-side in one git tree, one issue tracker, one CI system — the architectural integration is real follow-up work, tracked in [`apps/README.md`](apps/README.md#follow-up-deep-integration).

**Why merge now?** Because a crew deserves both experiences from one app home. And because the engineering path from "two separate repos" → "two trees in one repo" → "integrated feature set sharing FlyGACAKit's study + Captain Adel's lookup" is now visible.

**Merged 2026-09-08** from [`iflygaca/FlyGACA-ios`](https://github.com/iflygaca/FlyGACA-ios) and
[`iflygaca/Captain-Adel-iOS`](https://github.com/iflygaca/Captain-Adel-iOS) — see
[`apps/README.md`](apps/README.md) for the merge mechanics, what changed, and what stayed
untouched. **Both source repos remain on GitHub**, each with a pointer here; they are
not archived, and their CI/CD and TestFlight pipelines continue running independently until a human decides otherwise.

---

## 🏛 Repository Architecture

```
iflygaca/ios
│
├─ apps/flygaca-ios/            (FlyGACAKit family — ELPT, AIP)
│   └─ apple/FlyGACAKit/
│       CoreModels → StudyEngines / ContentKit / AppServices / PersistenceKit
│                  → PlatformLive → FeatureUI
│
└─ apps/captain-adel-ios/       (Captain Adel — offline GACAR co-pilot)
    └─ MyApp/
        On-device TF-IDF vector search · Bilingual voice comms · METAR/TAF weather
```

Both trees build, test, and ship independently today via their own scoped GitHub Actions
workflows — see [CI](#-ci) below.

## 🔄 Why merge — and why it matters

### The Problem
The Fly GACA family goal is one native iOS experience: **"Academics, Calculators, AI Instructor, Regulations"** — but these were shipped as two separate repositories, two app binaries, two issue trackers. A crew had to choose: study mode (FlyGACA) *or* lookup-on-tarmac (Captain Adel), not both. And a bug fix in one repo couldn't inform design decisions in the other without manual cross-communication.

### The Solution (This Merge)
**Move from "two separate apps" to "two app targets in one codebase, working toward one unified native experience."**

**This merger is Phase 1 of a 3-phase convergence plan:**

1. **Phase 1 (done, this merge):** One git home, one CI, one issue tracker. Both apps build independently; no shared Swift code yet. Full history preserved; no loss of context.
2. **Phase 2 (planned):** `FlyGACAKit` opens a `ChatClient` service seam. Captain Adel's chat engine is ported into `PlatformLive`. The underlying study and chat engines remain separate but their UIs can share a screen.
3. **Phase 3 (future):** Unified app picker at install — crew can install just the study module, just the cockpit mode, or both, and they share one App Group (shared progress, shared GACAR corpus cache).

### Architecture Today (Phase 1)
Each app is **independent, unchanged, ready to ship**:
- `apps/flygaca-ios/` — FlyGACAKit family (ELPT, AIP); no new dependencies; Swift 5.9+
- `apps/captain-adel-ios/` — Standalone Captain Adel iOS app; on-device retrieval; voice comms; no cloud dependency in offline mode

**This is intentional.** Captain Adel's chat, voice, METAR, and on-device RAG engine are *not* yet ported into `FlyGACAKit`'s `PlatformLive`/`FeatureUI` layers — that is real, substantial engineering work (new service seams, screen layout, corpus strategy reconciliation) tracked in
[`apps/README.md`](apps/README.md#follow-up-deep-integration) with a detailed scope. Each app builds and ships independently today, exactly as it did in its own repo. The merger just gives them a shared home and a visible roadmap to convergence.

---

## 🖼️ Visuals

<div align="center">

| FlyGACA — Study Mode | FlyGACA — Flashcards | Captain Adel — Cockpit Chat |
|:---:|:---:|:---:|
| ![Study mode screenshot placeholder](https://placehold.co/260x560/0a0e12/0D96F6?text=Study+Mode) | ![Flashcards screenshot placeholder](https://placehold.co/260x560/0a0e12/00ff88?text=SRS+Flashcards) | ![Captain Adel chat screenshot placeholder](https://placehold.co/260x560/050810/22d3ee?text=Cockpit+Chat) |

*Screenshots are placeholders pending a unified capture pass — each app's own screenshot pipeline
is documented under its `apps/<app>/` tree (`apple/Scripts/html-render/` for FlyGACA iOS,
`scripts/archive_testflight.sh`-adjacent tooling for Captain Adel iOS).*

</div>

---

## Building

Each app keeps its own build system, requirements, and CI, unchanged by the merge:

```bash
# FlyGACA iOS (FlyGACAKit family — ELPT, AIP)
cd apps/flygaca-ios
cd apple/FlyGACAKit && swift build && swift test   # fastest way to verify a Swift-side change
cd .. && npm run ios:generate                       # XcodeGen → apple/FlyGACA.xcodeproj

# Captain Adel iOS (captadel.xcodeproj)
cd apps/captain-adel-ios
open captadel.xcodeproj
```

See each app's own `README.md` / `CLAUDE.md` for full detail — `apps/flygaca-ios/CLAUDE.md` is
the denser of the two and documents the shared-package architecture, content pipeline, and
signing/TestFlight runbooks; `apps/captain-adel-ios/README.md` and `TESTFLIGHT_READINESS.md`
cover Captain Adel's own release process.

## CI

Root `.github/workflows/` carries three workflows, each scoped to its app via
`paths:`/`working-directory:` so a change to one app never triggers the other's build:

- `flygaca-ios.yml` — Swift package tests, XcodeGen validation, debug/release builds for
  `flygaca`/`elpt`/`aip`, and (on `main`, when signing secrets are present) TestFlight upload.
- `captain-adel-ios-ci.yml` — simulator build + asset/corpus integrity checks.
- `captain-adel-ios-testflight.yml` — Fastlane TestFlight deploy, now triggered on
  `captain-adel-v*.*.*` tags (renamed from the bare `v*.*.*` scheme it used as a standalone repo,
  to avoid colliding with `flygaca-ios`'s own release tags in this shared repo).

---

## 🧑‍💻 Contributing

We welcome pilots, iOS engineers, designers, and aviation enthusiasts.

1. **Fork** this repo
2. **Create** a feature branch under the app you're changing (`apps/flygaca-ios/` or
   `apps/captain-adel-ios/`)
3. **Test** thoroughly with that app's own commands (see [Building](#building) above)
4. **Push** and open a **Pull Request**

## 📜 License

MIT © BDA Company International, operating as Fly GACA

---

## Disclaimer

Fly GACA is an independent educational platform, not affiliated with, endorsed by, or operated
by GACA or the Government of Saudi Arabia. GACA (gaca.gov.sa) is always the authoritative
source; both apps in this repo cite it and defer to it.

---

<div align="center">

**Study offline. Fly prepared. Master the regulations.**

[Report Issues](https://github.com/iflygaca/ios/issues) · [Star ⭐](https://github.com/iflygaca/ios)

🇸🇦 صنع في السعودية · Made in Saudi Arabia

</div>
