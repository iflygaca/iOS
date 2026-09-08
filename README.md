# iOS

The unified native iOS home for the Fly GACA family — **`iflygaca/ios`**.

This repo merges the full git history of two previously separate repositories, each kept
as its own top-level app under `apps/`:

| App | Path | What it is |
| --- | --- | --- |
| **FlyGACA iOS** | [`apps/flygaca-ios/`](apps/flygaca-ios/) | The `FlyGACAKit` Swift package family — ELPT and AIP study apps (exam prep, flashcards, spaced repetition, mock exams) sharing one layered package (`CoreModels` → `StudyEngines`/`ContentKit`/`AppServices`/`PersistenceKit` → `PlatformLive` → `FeatureUI`). |
| **Captain Adel iOS** | [`apps/captain-adel-ios/`](apps/captain-adel-ios/) | The standalone "Captain Adel" cockpit app — an offline GACAR regulatory co-pilot with on-device TF-IDF/cosine-similarity retrieval, bilingual voice comms, and live METAR/TAF weather for Saudi aerodromes. |

Merged 2026-09-08 from [`iflygaca/FlyGACA-ios`](https://github.com/iflygaca/FlyGACA-ios) and
[`iflygaca/Captain-Adel-iOS`](https://github.com/iflygaca/Captain-Adel-iOS) — see
[`apps/README.md`](apps/README.md) for how the merge was done, what changed, and what stayed
untouched. **Both source repos remain on GitHub**, each carrying a notice pointing here; they are
not deleted or archived (this session has no ability to archive a GitHub repo), and their own
CI/CD and TestFlight pipelines keep running unchanged in place until a human decides otherwise.

## Why merge

The [Fly GACA family roster](https://github.com/iflygaca/FlyGACA-Family) already describes
`FlyGACA-ios` as the flagship all-in-one native app spanning "Academics, Calculators, **AI
Instructor**, Regulations" — but the AI Instructor (Captain Adel) experience didn't actually live
in that codebase; it existed as a separate, fully-built standalone app. This repo is the first
step toward that one-app vision: both codebases now share one home, one issue tracker, and one
git history, so they can converge without losing either team's work.

**This pass is a side-by-side merge, not a deep architectural integration.** Captain Adel's chat,
voice, METAR, and on-device RAG engine are not yet ported into `FlyGACAKit`'s `PlatformLive`/
`FeatureUI` layers as a shared app target — that is real, substantial engineering work (new
`ChatClient`/`PaymentProviding`-style service seams, a new `FeatureUI` screen, reconciling two
different offline-corpus strategies) tracked as follow-up in
[`apps/README.md`](apps/README.md#follow-up-deep-integration). Each app builds and ships
independently today, exactly as it did in its own repo.

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

## Disclaimer

Fly GACA is an independent educational platform, not affiliated with, endorsed by, or operated
by GACA or the Government of Saudi Arabia. GACA (gaca.gov.sa) is always the authoritative
source; both apps in this repo cite it and defer to it.
