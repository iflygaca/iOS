# Roadmap — ay2m/FlyGACA (the native iOS family)

What's next for the Fly GACA iOS apps. The extraction from the web monorepo is **complete** —
this repo generates, builds, tests and archives its apps (ELPT, AIP) on its own. This file looks
**forward** and is the **single source of truth for open work in this repo**; the extraction
history lives in [`MIGRATION.md`](./MIGRATION.md) (history only — no open items are tracked
there).

> **Paused: the licence-exam modules.** PPL, CPL, IR and ATPL are on hold pending a strategic
> decision, and were removed from this repo on 2026-08-10 — targets, xcconfigs, bundled content,
> icons, npm scripts, CI matrices and the screenshot sets. Nothing is lost: they live in git
> history, their App Store metadata repos are intact and marked parked, and their web study
> packs are untouched and still selling at `flygaca.com/study/packs/*`. Restoring one is a
> revert of that commit plus its Apple-portal steps. Until then the family is **ELPT + AIP**,
> and no roadmap item below covers a paused module.

## How to read this

- **Now / Next / Later** are horizon buckets, not date commitments — priorities shift as Apple
  processing, content review and the web roadmap move.
- Each item is tagged **[product]** (something users get), **[platform]** (infra, signing, CI,
  release plumbing) or **[docs]** (contributor/reader-facing writing).
- Shipped items stay visible as ~~strikethrough~~ + **Done.** with a date, rather than being
  deleted.
- Precedence, so this file never becomes a second source of truth: `apple/ARCHITECTURE.md` §5
  owns the engineering *phase design* (Phases 1–4, owned here — not restated in this file; Phase
  4, PlatformLive, is the big one below). `docs/RUNBOOK-ios-xcodebuild.md`
  carries its own differently numbered "Phase Roadmap" — a known divergent snapshot; where they
  disagree, `ARCHITECTURE.md` wins. The family lineup and wave plan stay canonical in the
  monorepo's `docs/APPS-FAMILY-ROADMAP.md`; each app's store-listing milestones live in its own
  metadata repo (`ay2m/ELPT`, `ay2m/AIP`). This file wins only for "what this repo does
  next".

## Now — Documentation and Foundation

- **[docs] Phase 0: Documentation correction** — Update ROADMAP.md for both apps, fix CLAUDE.md pointer table (this PR).
- **[product] Phase 1: Lock the flagship catalog** — In `iflygaca/flygaca`, extend catalog schema with `status` field per module (`"available"` for ELPT/AIP, `"comingSoon"` for PPL/CPL/IR/ATPL`). Regenerate `catalog.json` via `sync-content.sh`. In `apps/flygaca-ios`, update `AcademicsCatalogView.swift` and `MainDashboardView.swift` to render `"comingSoon"` as locked, non-tappable tile.
- **[product] Phase 2: Real Library content sync** — In `iflygaca/flygaca`, add generator to copy `public/data/gacar-index.json` and the full `public/data/parts/*.html` into `apps/flygaca-ios/apple/Apps/FlyGACA/Content/regulations/` (index + parts subfolder). Do the same for `airports.json`. In `apps/flygaca-ios`, update `ContentKit` to load the new structure and rebuild `RegulationsLibraryView` to browse the full 74-part text.

## Next — Features and Metrics

- **[product] Phase 3: Port Tools from Captain Adel iOS** — Port the 4 FMC calculator formulas as pure functions (with unit tests). Add live METAR fetch inside `PlatformLive` via a new `WeatherProviding` protocol (with mock in `AppServices/Mocks.swift`). Wire into `FlightDeckToolsView.swift`.
- **[product] Phase 4: Port the exam bank as content** — In `iflygaca/flygaca`, add the 26 GACAR questions as a new quiz bank (or fold into existing). Sync via existing quiz content path; confirm it shows up in Academics tab.
- **[product] Phase 5: Guides section** — In `iflygaca/flygaca`, identify web Guides content (licensing walkthrough, medical certificate, licence conversion, English proficiency test). Add generator to emit `guides.json` into `apps/flygaca-ios/apple/Apps/FlyGACA/Content/guides/`. In `apps/flygaca-ios`, add `CoreModels` types, `ContentKit` loader, and new `FeatureUI/Guides/GuidesView.swift` + `GuideDetailView.swift`. (Design decision: 6th tab for Guides.)
- **[product] Phase 6: StoreKit metering for Captain Adel chat** — Add StoreKit 2 auto-renewable subscription product (App Store Connect + StoreKit Configuration file). In `PlatformLive`, add `StoreKitEntitlementsService` implementing `EntitlementsProviding`. Add free-quota counter (SwiftData-backed daily reset) in `PersistenceKit`; `CaptainAdelChatView` checks before sending message; show paywall when exhausted. Coordinate with backend for server-side receipt validation.
- **[product] Phase 7: Rate-limit coordination** — Confirm with `flygaca-rag-chat` owners that anonymous mobile client cannot exceed per-anonymous-user quota. Likely fix: device-bound identifier header or App Attest–backed token checked server-side.
- **[product] Phase 8: Apple portal setup for the flagship** — Confirm/create App ID for `com.flygaca.app`. Confirm `PROVISIONING_PROFILE_SPECIFIER` = `FlyGACA FlyGACA AppStore`. Populate `PROFILE_FLYGACA_B64` GitHub secret for TestFlight lane. Create App Store Connect record: Price: Free, age rating, territories. Register the StoreKit subscription product from Phase 6.

## Later — Integration and Cleanup

- **[product] Phase 9: Remove ported features from Captain Adel iOS** — (Gate: only after Phases 2-4 are shipped and verified in FlyGACA) Delete `GACARLibraryView.swift`, `AviationToolsView.swift` + `METARService.swift`, `QuizService.swift`. Update tab bar to leave Chat + About. Keep chat-related files (`GACARCorpusDatabase.swift`, `GACARVectorSearchEngine.swift`, `CaptainAdelAIService.swift`, `CockpitVoiceCommsService.swift`, `Views/Components/*`).
- **[product] Phase 10: Later, optional** — Point `GACARCorpusDatabase.swift` (Captain Adel iOS) at the same synced `parts/*.html` + `gacar-index.json` snapshot used by FlyGACA, instead of maintaining a third hand-typed copy. Decide corpus freshness policy (app-binary update vs. signed remote-refresh channel).
