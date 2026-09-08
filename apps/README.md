# apps/

Two previously separate repositories, merged into this one with `git subtree`, full history
preserved:

| Directory | Merged from | Original default branch | Commits carried over |
| --- | --- | --- | --- |
| `flygaca-ios/` | [`iflygaca/FlyGACA-ios`](https://github.com/iflygaca/FlyGACA-ios) | `main` | full history |
| `captain-adel-ios/` | [`iflygaca/Captain-Adel-iOS`](https://github.com/iflygaca/Captain-Adel-iOS) | `main` | full history |

## What actually changed in the merge

Nothing in either app's Swift/Xcode source changed. The only edits were to make each app's own
CI and docs correct in its new location:

- Each app's own `.github/workflows/` and `.github/dependabot.yml` were removed — GitHub Actions
  only reads workflows from the repo-root `.github/workflows/`, so nested copies under `apps/*/`
  were already inert here. The same workflows now live at the `ios` repo root
  (`flygaca-ios.yml`, `captain-adel-ios-ci.yml`, `captain-adel-ios-testflight.yml`), scoped to
  their app via `paths:` filters and `working-directory:`, with artifact/cache paths re-prefixed
  with `apps/<app>/`. Behavior is otherwise unchanged — see the root `README.md`'s CI section.
- `captain-adel-ios`'s TestFlight workflow now triggers on `captain-adel-v*.*.*` tags instead of
  the bare `v*.*.*` it used standalone, so it doesn't collide with `flygaca-ios` release tags
  sharing this repo.
- Everything else — `apple/`, `MyApp/`, `docs/`, `scripts/`, `fastlane/`, `Package.swift`,
  `project.yml`, `captadel.xcodeproj`, every doc — is untouched, byte-for-byte, from each
  source repo's `main` branch at merge time.

Cross-repo references inside each app's own docs (e.g. `apps/flygaca-ios/CLAUDE.md` still says
"ay2m/FlyGACA is the native SwiftUI home…" and lists the family repo table from its old
standalone context) were **not** rewritten — that's a larger doc-accuracy pass, not part of this
merge, and each app's own docs remain internally self-consistent about its own build/test/release
process either way.

## Follow-up: deep integration

The family's stated vision (see the root `README.md` and `iflygaca/FlyGACA-Family`) is one
flagship app spanning study modules *and* the Captain Adel AI Instructor. Getting there from this
side-by-side merge means, roughly:

1. **Decide the shared corpus strategy.** `flygaca-ios` refreshes `quiz.json` from
   `flygaca.com/data/quiz.json` under an Ed25519 signature (`ContentKit/CorpusSignatureVerifier`,
   currently inert — no public key provisioned). `captain-adel-ios` ships its own on-device
   74-part GACAR corpus with a TF-IDF/cosine-similarity engine (`GACARVectorSearchEngine`,
   `GACARCorpusDatabase`) and no signing at all. One app needs one corpus story.
2. **Port Captain Adel's chat as a new `PlatformLive` service + `FeatureUI` screen.**
   `flygaca-ios`'s `AppServices/Services.swift` already declares a `ChatClient` protocol and
   `PlatformLive` already has a `CaptainAdelSSEClient` — but nothing in `FeatureUI` constructs it
   yet (see `apps/flygaca-ios/CLAUDE.md`'s "PlatformLive is written but not wired in"). Captain
   Adel iOS's `ChatView.swift` / `CaptainAdelAIService.swift` are the reference implementation to
   port from, not a wrapper to keep running standalone forever.
3. **Reconcile voice and weather as optional feature modules.** Captain Adel's
   `CockpitVoiceCommsService` (Speech/AVFoundation) and `METARService` (NOAA feed) have no
   equivalent in `FlyGACAKit`'s target graph — they'd land as new library targets (or inside
   `PlatformLive`) rather than being bolted onto `FeatureUI` directly, per the "networking and
   platform SDKs never leak upstream of `PlatformLive`" rule in `apps/flygaca-ios/CLAUDE.md`.
4. **One app target, one bundle id, one App Store listing** — replacing today's two bundle ids
   (`com.flygaca.elpt`/`.aip` vs `com.flygaca.captainadel`) is an Apple-portal decision with real
   product and pricing consequences, not something to default into silently.

None of this was attempted in this merge — it needs a human decision on scope and sequencing
before any of steps 1–4 start, and it needs a macOS/Xcode environment to actually verify (this
merge was performed without one — see the root README's CI section for what was and wasn't
verified here).
