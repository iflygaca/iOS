# Roadmap — ay2m/FlyGACA (the native iOS family)

What's next for the Fly GACA iOS apps. The extraction from the web monorepo is **complete** —
this repo generates, builds, tests and archives its apps (ELPT, AIP, **and the `FlyGACA`
flagship**) on its own. This file looks **forward** and is the **single source of truth for open
work in this repo**; the extraction history lives in [`MIGRATION.md`](./MIGRATION.md) (history
only — no open items are tracked there).

This roadmap has **two tracks**, because the two products ship on different timelines and answer
different questions: the **standalone module apps** (ELPT, AIP today; more modules later) are the
ASA-style paid exam-prep line; the **`FlyGACA` flagship** is the free umbrella app (library, tools,
guides, Captain Adel) that funnels into them. "Now / Next / Later" for the module-apps track is
below; the flagship's own Now/Next/Later is in its own section further down — don't merge the two,
they have different Definitions of Done and different App Store listings.

> **Paused: the licence-exam modules.** PPL, CPL, IR and ATPL are on hold pending a strategic
> decision, and were removed from this repo **as standalone app targets** on 2026-08-10 —
> targets, xcconfigs, per-module Content snapshots, icons, npm scripts, CI matrices and the
> screenshot sets. Nothing is lost: they live in git history, their App Store metadata repos are
> intact and marked parked, and their web study packs are untouched and still selling at
> `flygaca.com/study/packs/*`. Restoring one **as a standalone app** is a revert of that commit
> plus its Apple-portal steps. Until then the module-apps family is **ELPT + AIP**, and no
> module-apps roadmap item below covers a paused module.
>
> **Important nuance found 2026-09-12**: the *flagship* `FlyGACA` target's own bundled
> `Content/catalog.json` still lists `ppl-exam`/`cpl`/`ir`/`atpl` as regular, unlocked entries —
> this predates the pause and was never cleaned up when the standalone targets were removed. See
> "①  Lock the flagship catalog" below — this is being fixed to a "Coming soon" (locked, visible,
> unopenable) tile per module, not a full removal, so the flagship can tease the licence line
> without shipping content nobody decided to ship.

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

## Now — light the path to TestFlight

- **[platform] Sign-in-with-Apple primary App ID — decided in the docs, not yet done in the
  portal.** The capability was removed from `apple/Apps/Shared/App.entitlements` in 2026-08 and
  the registered App IDs don't carry it, so nothing is blocked today. The primary is
  **`com.flygaca.elpt`** with AIP grouped under it, and every doc now says so —
  `docs/RUNBOOK-ios-firebase.md` §4a (the click-path), `docs/PORTAL-RUNSHEET-wave1.md` §1.2 and
  `docs/RUNBOOK-ios-release.md`; the old `com.flygaca.ppl` designation is recorded as moot, since
  no Apple user identifier was ever issued under it. What remains is the **portal work itself**
  when sign-in ships: enable the capability on both App IDs, group AIP under ELPT, regenerate the
  profiles.
- ~~**[platform] Create the signing secrets and the store records.**~~ **Done 2026-08-16.**
  Run [#69](https://github.com/iflygaca/FlyGACA-ios/actions/runs/31916879238) signed, exported and
  uploaded both apps — so the App Group, both App IDs, the distribution cert, both
  `FlyGACA <APP> AppStore` profiles, the App Store Connect API key and the nine GitHub secrets
  all exist and work end to end. `1.0.0 (69)` is in TestFlight for ELPT and AIP.
- **[platform] Finish the App Store Connect records so testers can install.** Builds reach
  TestFlight but installs fail with *"The requested app is not available or doesn't exist"* —
  an App Store lookup failure, not a build problem. Outstanding on the records themselves:
  **Pricing and Availability** (no price point and no territories are set — `SAR 79` per app per
  `apple/ARCHITECTURE.md` §4) and the **age-rating questionnaire** (4+, all-"None"). Triage
  order, including the tester-account check that comes first, is
  [`docs/PORTAL-RUNSHEET-wave1.md`](./docs/PORTAL-RUNSHEET-wave1.md) §5.1. Portal-only work —
  nothing in this repo changes.
- ~~**[product] Close the content skew.**~~ **Done 2026-08-05**: a reviewed `sync-content.sh`
  run brought ELPT to 4 banks and AIP to 3, and refreshed the grown question sets (validated:
  bankIds ⇔ banks, exam config unchanged). Store listings and bundles agree
  ([`SEO-PLAN.md`](./SEO-PLAN.md) item 0.3). ELPT bundles a 5th scenario bank on top.
- ~~**[platform] Register the Firebase iOS apps.**~~ **Done 2026-08-15.** Registered `com.flygaca.elpt` and `com.flygaca.aip` in Firebase project `flygaca-app` and generated `GoogleService-Info.plist` files for both apps (`docs/RUNBOOK-ios-firebase.md`).
- ~~**[docs] Author the repo docs suite.**~~ **Done 2026-08-04** (this PR): `CAUSE.md`,
  `ROADMAP.md`, `MIGRATION.md`, `SEO-PLAN.md`, `THE-BOOK-OF-FLY-GACA.md`, `CONTRIBUTING.md`,
  `docs/RUNBOOK-ios-release.md`, `docs/README.md`, a README refresh and CLAUDE.md pointers.

## Next — the store shelf

- ~~**[platform] Wire `AppleTests/ScreenshotTests.swift` into the project.**~~ **Done 2026-08-15.**
  Wired `AppleTests` as a `bundle.ui-testing` target in `apple/project.yml` with `testTargets: [AppleTests]`
  in the target templates.
- **[product] Ship the store listings.** The listing copy, keywords and screenshots live
  in the ELPT and AIP metadata repos and ship from there (fastlane `deliver` layout); tracked here only
  as the family gate — an app without its listing can't leave TestFlight. Strategy:
  [`SEO-PLAN.md`](./SEO-PLAN.md).
- **[platform] ~~Localize the app (EN + AR).~~ Done 2026-08-05.** FeatureUI's UI chrome now
  ships bilingual — a `Loc` bundle resolver over `Resources/{en,ar}.lproj` (34 keys) — and every
  app advertises `CFBundleLocalizations = [en, ar]`, so iOS serves Arabic (and SwiftUI mirrors
  RTL) on an Arabic device: first-class for the `ar-SA` storefront. Content stays English
  (monorepo-generated). Details + the monorepo mirror are in [`SEO-PLAN.md`](./SEO-PLAN.md)'s
  session log. Remaining follow-up: re-render the Arabic screenshots over the real Arabic UI.
- **[platform] Keep the parity vectors tracking the web.** If the web's SRS / exam-scoring /
  streak contracts move (`src/calc/study/srs.ts` and friends in the monorepo), extend
  `apple/FlyGACAKit/Tests/StudyEnginesTests/` in the same change that syncs the port — the
  vectors are the cross-platform contract, not decoration.

## Later — the platform phase and the long shelf

- ~~**[platform] PlatformLive**~~ **Done 2026-08-15.** Implemented `PlatformLive` library target in `apple/FlyGACAKit` (`FirebaseAuthService`, `FirebaseProgressSync` targeting `users/{uid}/progress/summary`, `CaptainAdelSSEClient` streaming SSE, and unit test suite `PlatformLiveTests`).
- **[product] The app bundle.** "Saudi Pilot Study Pack" — the paid App Store bundle (Apple
  allows up to 10 apps) once both apps are live, with completing-the-bundle credit for users who
  already bought one. Pricing: SAR 79 per app, SAR 139 for the app bundle (`apple/ARCHITECTURE.md` §4).
- **[product] Wave 3 modules.** FOI (`foi`), AGI (`agi`), Dispatcher, AME and the rest — each
  enters the monorepo's `prepCatalog.ts` first, then becomes a `Content/` folder + a small
  xcconfig + a 3-line `apple/project.yml` target here. A module is data, not code.
- **[platform] ~~Retire the monorepo's legacy `apple/` copy.~~ Done 2026-08-10.** The era of two
  trees is over: `FlyGACA-app` deleted its `apple/` mirror, this repo is the sole home of the app
  code, and `sync-content.sh` lost its `--all` mode. The monorepo keeps only the content
  generators (`build-ios-content.mjs` / `gen-app-icons.mjs`), which now write straight into this
  repo's `apple/Apps` via `--out`. All `apple/` docs and Swift/config are hand-owned here now.
- ~~**[platform] Consider path filters for `ios.yml`.**~~ **Done 2026-08-15.** Added `paths-ignore` for `**.md` and `docs/**` on `push` and `pull_request` triggers in `.github/workflows/ios.yml`.
- **[docs] Re-review `THE-BOOK-OF-FLY-GACA.md`'s dated stamps** whenever any repo's shape
  moves — the Book describes, it does not govern, and its "Last reviewed" dates are the honesty
  mechanism.

## The `FlyGACA` flagship app — its own roadmap

Decided 2026-09-12: the flagship stays **free** (it is the top-of-funnel for ELPT/AIP and any
future module app, not a revenue line itself), and **Captain Adel inside it is metered** — a
small free daily quota, then an auto-renewable subscription.

**Product split, sharpened 2026-09-12**: Captain Adel (in either app) is **chat only**; FlyGACA is
**library + tools + guides**, module apps unchanged. The standalone **Captain Adel iOS app**
(`apps/captain-adel-ios`, `com.flygaca.captainadel`) keeps its own account/runtime/corpus
independence — no shared login, no shared entitlement, no user migration — but it is **not**
independent at the *code and content* level: it currently carries Library/Tools/Quiz features that
belong in FlyGACA by this split, and those get ported here rather than rebuilt twice (see "Next"
below). Once ported and shipped, they're removed from Captain Adel iOS, which then really is chat
+ voice + citations only. See `apps/captain-adel-ios/ROADMAP.md` for the removal side and the
exact stay/move file list. Anywhere below that says "Captain Adel" means the chat tab **inside
`FlyGACA`**, not the other app.

What already exists, found while auditing this repo (not documented anywhere before this pass):
a `FlyGACA` app target (`com.flygaca.app`) building and testing in CI (`flygaca-ios.yml`
matrix, TestFlight lane included), a 5-tab `MainAppView` (Home / Academics / Flight Deck Tools /
Captain Adel AI / Regulations Library), and a `CaptainAdelChatView` **already wired** to the real
`PlatformLive.CaptainAdelSSEClient` hitting `https://flygaca.com/api/chat` — not a mock. Treat all
of that as *built*; the items below are what's actually missing, not "wire up PlatformLive" (it's
wired).

### Now

- **① Lock the flagship catalog.** `Apps/FlyGACA/Content/catalog.json` lists `ppl-exam`, `cpl`,
  `ir`, `atpl` as regular open entries. Change them to a locked "Coming soon" tile in
  `AcademicsCatalogView`/`MainDashboardView` (visible, not tappable into content) instead of
  either shipping paused content unreviewed or hiding the licence line entirely. This is a
  `catalog.json` schema addition (a `status: "comingSoon"` field) generated in the monorepo's
  `build-ios-content.mjs`, plus the small `FeatureUI` change to render a locked state — coordinate
  the schema addition with whoever owns that script in `ay2m/FlyGACA`.
- **② Correct the documentation drift.** `CLAUDE.md` (both this repo's root and this app's own),
  `apple/ARCHITECTURE.md` §5's Roadmap table, and `apps/README.md#follow-up-deep-integration` all
  currently say PlatformLive/Captain Adel chat is "not wired in yet". It is. Update those four
  places in the same PR as ①, so the next person (human or agent) doesn't re-discover this the
  hard way or, worse, tries to "build" something that already ships.
- **③ Confirm the Apple-portal state for `com.flygaca.app`.** `docs/PORTAL-RUNSHEET-wave1.md`
  covers ELPT/AIP; it needs a flagship section: App ID exists?, `PROVISIONING_PROFILE_SPECIFIER`
  = `FlyGACA FlyGACA AppStore` actually issued (the name is auto-derived from `project.yml`'s
  `${target_name}` template — double-check it isn't rejected as malformed), `PROFILE_FLYGACA_B64`
  secret populated, App Store Connect record created with **Price: Free** (not the SAR 79/139
  paid-app default `ARCHITECTURE.md` §4 describes for ELPT/AIP).

### Next

- **[product] Build the Guides section.** No equivalent of the web's Guides (licensing walkthrough,
  medical, licence conversion, English proficiency test) exists in `FeatureUI` today. New tab or
  a Home-dashboard section (design call, not an engineering one) backed by new content synced from
  `content/guides` in `ay2m/FlyGACA` through an extension to `build-ios-content.mjs` /
  `sync-content.sh` — the same "content lives in the monorepo, Swift lives here" split as every
  other content type.
- **[platform] Captain Adel metering via StoreKit — not Moyasar.** `PlatformLive` already has
  `MoyasarPaymentService`, but Moyasar is a web payment rail; Apple requires **StoreKit /
  In-App Purchase** for unlocking any digital feature inside an iOS app. This needs: a StoreKit
  auto-renewable subscription product (e.g. "FlyGACA Pro"), server-side receipt validation
  (coordinate with `flygaca-backend`/`flygaca-billing-payments` for where that validation and the
  entitlement record live — likely a new `packEntitlements`-style check next to the existing
  Firestore-backed `EntitlementsProviding`), and a client-side free-quota counter (e.g. 5
  messages/day) gating `CaptainAdelChatView` before the paywall shows.
- **[platform] Rate-limit coordination.** `CaptainAdelChatView` calls `flygaca.com/api/chat`
  directly, unauthenticated, with no client identifier today. Before this ships broadly, confirm
  with `flygaca-rag-chat`/`flygaca-backend` that an anonymous mobile client can't blow through the
  same quota the web's anonymous tier relies on — this may need a device-bound identifier or an
  App Attest–backed token, decided together with the metering work above (same PR family).

### Next — the real Library, ported Tools, and closing the clean split (decided 2026-09-12)

The product split is now explicit: **Captain Adel = chat only** (anywhere it ships); **FlyGACA =
library + tools + guides**, module apps unchanged. The standalone Captain Adel iOS app currently
carries its own Library (`GACARLibraryView.swift`), Tools (`AviationToolsView.swift`: METAR + FMC
calculators), and a 26-question exam bank (`QuizService.swift`) — these get **ported into FlyGACA**
(not rebuilt from zero, not left duplicated) and then **removed from Captain Adel iOS** once the
FlyGACA replacements ship. See `apps/captain-adel-ios/ROADMAP.md`'s matching "Now" section for the
removal side of this — **build here first, remove there second**, so no existing Captain Adel
tester loses a feature before its replacement exists.

- **[product] Real Library content — stop hand-copying, start syncing.** Audited 2026-09-12:
  `Apps/FlyGACA/Content/regulations.json` is schema-identical to `ay2m/FlyGACA`'s
  `public/data/gacar-index.json` (same `generated/source/sourceUrl/count/categories/documents`
  shape) — it's a **one-off hand-copy of the real index**, produced by no committed script. The
  real full text lives in `public/data/parts/part-*.html` (74 files, ~7.3 MB) and was never synced
  at all — today's flagship Library is outline-only. Fix: extend `scripts/build-ios-content.mjs`
  (or a sibling `scripts/build-ios-library.mjs`, called from `sync-content.sh`) in `ay2m/FlyGACA`
  to copy `gacar-index.json` **and** the full `parts/` directory verbatim into
  `Apps/FlyGACA/Content/regulations/` on every sync — the same "monorepo generates, this repo only
  consumes the snapshot" rule every other content type already follows. Do **not** hand-author or
  hand-refresh `regulations.json` again; a stale index with no generator is exactly the drift this
  decision is closing. (`scripts/lib/flavor-slice.mjs`'s `CORPUS_FILES`/`collectCorpusRefs` is the
  existing precedent for "which corpus HTML ships with which app" used by the Capacitor flavor
  builds — the flagship doesn't need per-pack slicing since it ships the whole 74-part library, but
  that file is the reference for how corpus-file resolution is already solved once in this family;
  don't reinvent it.) Same audit finding applies to `airports.json` — confirm its generator (or add
  one) rather than assume the committed snapshot stays correct by hand.
- **[product] Port Tools from Captain Adel iOS.** `AviationToolsView.swift`'s METAR decoder and its
  four FMC calculators (VFR fuel reserve, crosswind/headwind, density altitude, top-of-descent) are
  real, tested formulas — port the math into `FlyGACAKit` (pure functions, likely alongside/inside
  `FlightDeckToolsView`'s existing tool set, which today covers Cockpit HUD/ATC practice/weather but
  not the FMC calculators specifically). Respect the layering rule: the calculators themselves are
  pure (no IO, testable like `StudyEngines`), but a *live* METAR fetch is network IO and must live
  in `PlatformLive`, called from `FeatureUI` through a protocol — not a direct `URLSession` call
  inside the view, unlike Captain Adel iOS's flat-app `METARService.swift`.
- **[product] Port the exam bank as a real content pack, not a parallel `QuizService`.** Captain
  Adel iOS's 26-question GACAR bank has real bilingual content worth keeping, but it should become
  a `quiz.json`-shaped bank consumed by FlyGACAKit's existing `CoreModels`/`StudyEngines`/
  `QuizView` machinery (the same engine ELPT/AIP already use), not a second bespoke quiz
  implementation living only in `FeatureUI`. Concretely: add the 26 questions as a bank in the
  monorepo's content (either a new small pack, e.g. `gacar-general`, or folded into an existing
  one — a `prepCatalog.ts` decision), then it flows through the flagship's Academics tab for free.

### Later

- **[product] New modules keep landing as standalone apps, automatically.** No new engineering
  needed here — see "Wave 3 modules" above. The flagship's catalog and the standalone-app list are
  two different surfaces fed by the same monorepo pack catalog; adding a pack to `prepCatalog.ts`
  is enough for both to pick it up (flagship: a catalog entry; standalone: a new `project.yml`
  target, whenever that module is un-paused or launches new).
- **[platform] Eventually retire Captain Adel iOS's own hand-typed corpus too.**
  `GACARCorpusDatabase.swift` (Captain Adel iOS) is a *third* hand-copy of the same 74-part corpus,
  just retyped into Swift source instead of JSON. Once the Library sync above exists, Captain
  Adel's offline retrieval engine is the natural next thing to point at the same synced
  `parts/`/`gacar-index.json` snapshot instead of its own copy — tracked in
  `apps/captain-adel-ios/ROADMAP.md`, not blocking anything here.

## How we ship (Definition of Done)

- `cd apple/FlyGACAKit && swift test` green — run it directly; `npm run ios:test` exits 0 even
  when tests fail.
- Only `apple/Apps/*/Content` + `Assets.xcassets` are generated (in the monorepo, via
  `sync-content.sh`) — don't hand-edit those; a content change belongs in the monorepo's corpus /
  `prepCatalog.ts`. **Everything else under `apple/` (FlyGACAKit, `project.yml`, `Apps/Shared`,
  the xcconfigs, `AppleTests`, `apple/Scripts`, the `apple/` docs) is owned here — edit it here.**
- The disclaimer is never reworded, anywhere. Copy it verbatim from `README.md` if a new
  surface needs it.
- `CLAUDE.md` stays true: if a change makes it stale, the same PR updates it.
