# AGENTS.md

Guidance for AI coding assistants working in `iflygaca/ios`.

## What this is

This repo is the merged, unified home for the Fly GACA family's native iOS apps. It carries the
full git history of two previously separate repositories, each preserved as its own top-level
tree under `apps/` — **do not flatten them or move files between them casually**; see
`apps/README.md` for exactly what the merge did and didn't change.

| Path | App | Its own docs |
| --- | --- | --- |
| `apps/flygaca-ios/` | The `FlyGACAKit` study-app family (ELPT, AIP) | `apps/flygaca-ios/AGENTS.md` (dense, authoritative for that tree), `apps/flygaca-ios/apple/ARCHITECTURE.md`, `apps/flygaca-ios/ROADMAP.md` |
| `apps/captain-adel-ios/` | Captain Adel — the offline GACAR co-pilot app | `apps/captain-adel-ios/README.md`, `apps/captain-adel-ios/TESTFLIGHT_READINESS.md` |

**Treat each app's own `AGENTS.md`/`README.md` as authoritative for anything inside that app's
directory.** They were merged as-is and describe each app's own architecture, build commands, and
conventions accurately — just read them from their new path (e.g. `cd apps/flygaca-ios &&` before
running any command they list). A few cross-repo references inside those files (e.g.
`apps/flygaca-ios/AGENTS.md` still calling itself "ay2m/FlyGACA" and listing a family-repo table
from its old standalone context) are known-stale and were deliberately left alone in the merge —
don't "fix" them into this repo's context without checking `apps/README.md` first.

## The Fly GACA repo family

See [`iflygaca/FlyGACA-Family`](https://github.com/iflygaca/FlyGACA-Family)'s README for the
full roster. In short: `iflygaca/FlyGACA` is the web platform (React/Vite + Express), which stays
the source of truth for regulatory content and the exam-pack catalog that `apps/flygaca-ios`
consumes; `iflygaca/Captain-Adel` is the AI flight-instructor **service** (captadel.com) that
`apps/captain-adel-ios`'s cloud-mode AI features talk to; `iflygaca/Office` holds business and
governance docs. `iflygaca/FlyGACA-ios` and `iflygaca/Captain-Adel-iOS` are the two source repos
this one was merged from — both still exist on GitHub with a pointer back here (see
`apps/README.md`), and their own CI/TestFlight pipelines keep running independently until a human
decides to retire them.

## Working across the two apps

- **Independent by default.** Each app has its own Swift package / Xcode project, its own
  dependencies, and its own release cadence. A change to one should not need to touch the other.
- **CI is scoped per app.** Root `.github/workflows/flygaca-ios.yml`,
  `captain-adel-ios-ci.yml`, and `captain-adel-ios-testflight.yml` each trigger only on changes
  under their own `apps/<app>/` path — see the root `README.md`'s CI section.
- **No shared Swift code exists yet.** `apps/flygaca-ios/apple/FlyGACAKit`'s target graph
  (`CoreModels` → `StudyEngines`/`ContentKit`/`AppServices`/`PersistenceKit` → `PlatformLive` →
  `FeatureUI`) and `apps/captain-adel-ios/MyApp`'s flat SwiftUI app are two unrelated codebases
  today. Porting Captain Adel's features into `FlyGACAKit` as a shared target is real,
  unstarted follow-up work — see `apps/README.md#follow-up-deep-integration` before attempting
  it, since it needs a scoping decision from a human first (corpus strategy, bundle-id/App Store
  consequences).
- **No macOS/Xcode toolchain is available in a typical Linux Codex session.** You can run
  `cd apps/flygaca-ios/apple/FlyGACAKit && swift build && swift test` only where a Swift
  toolchain exists. Neither app's Xcode project can be built or archived without a real macOS +
  Xcode environment — verify Swift-only changes there; verify anything touching `captadel.xcodeproj`
  or `apple/FlyGACA.xcodeproj` (both XcodeGen-generated, never committed) on a Mac, or defer to CI.

## Disclaimer (mirrors every other Fly GACA surface — do not reword)

Fly GACA is an independent educational platform, not affiliated with, endorsed by, or operated
by GACA or the Government of Saudi Arabia. GACA (gaca.gov.sa) is always the authoritative
source; both apps cite it and defer to it.
