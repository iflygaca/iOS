# Roadmap — Captain Adel iOS (`com.flygaca.captainadel`)

What's next for the standalone Captain Adel iOS app. **Product split, decided 2026-09-12: Captain
Adel is chat only — everywhere it ships.** This app stays independent from the `FlyGACA` flagship
app (`apps/flygaca-ios`) at the **account/runtime level**: no shared login, no shared entitlement,
no user migration between them, ever. It is **not** independent at the **feature-scope level**:
this app currently also carries a Library, a Tools screen, and an exam-question bank that belong
in FlyGACA by the new split (FlyGACA = library + tools + guides). Those get **ported into FlyGACA
first, then removed from here** — see "Now" below for the exact file-by-file plan. `apps/flygaca-
ios` has its own Captain Adel *chat feature* too (a tab inside its `FlyGACA` app target, backed by
`PlatformLive.CaptainAdelSSEClient` calling `flygaca.com/api/chat`) — a different product with a
different roadmap (`apps/flygaca-ios/ROADMAP.md`'s "flagship" section, which has the matching
porting-in plan). Don't conflate the two when reading either doc.

Read `README.md` for the full feature list and architecture and `TESTFLIGHT_READINESS.md` for the
release mechanics — this file looks forward only.

## What this app already is — and where each piece ends up

Not a thin chat wrapper today: a self-contained offline avionics/reference suite. Marked below
per the 2026-09-12 split — **[stays]** = part of "Captain Adel = chat", **[moves → FlyGACA]** =
belongs in the flagship instead, per its `ROADMAP.md`'s matching "Next" section:

- **[stays]** **74-part GACAR corpus, 100% on-device** (`GACARCorpusDatabase.swift`), searched by
  an Int8 quantized BM25 + cosine-similarity engine (`GACARVectorSearchEngine.swift`) with a hard
  cite-or-refuse threshold (cosine 0.28). This is the chat's *grounding engine*, not a browsing
  library — the chat needs it to answer and cite; it stays. (It's also, bluntly, a third hand-typed
  copy of the same 74-part corpus FlyGACA is now syncing for real — see "Later".)
- **[stays]** **Hybrid cloud/offline AI** (`CaptainAdelAIService.swift`) and the BYO-provider option
  (`AIProviderConfig.swift`, `KeychainHelper.swift`) — this is the chat itself.
- **[stays]** **Hands-free cockpit voice comms** (`CockpitVoiceCommsService.swift`) and the citation
  card / HUD / waveform components under `Views/Components/` — these serve the chat, not
  independent browsing.
- **[moves → FlyGACA]** **`GACARLibraryView.swift`** — a standalone regulatory-library browser.
  Duplicates what FlyGACA's `RegulationsLibraryView` is meant to be; FlyGACA's version becomes the
  real one once it syncs full text (see its `ROADMAP.md`).
- **[moves → FlyGACA]** **`AviationToolsView.swift`** — Saudi METAR/TAF (`METARService.swift`,
  26 aerodromes via NOAA) plus the 4-calculator FMC suite (VFR fuel reserve, crosswind/headwind,
  density altitude, top-of-descent). These are general flight tools, not chat features; they move
  into FlyGACA's `FlightDeckToolsView`.
- **[moves → FlyGACA]** **`QuizService.swift`** — the 26-question bilingual GACAR exam bank. Moves
  in as real pack content consumed by FlyGACAKit's existing quiz engine, not as ported Swift code
  (see FlyGACA's `ROADMAP.md` — "port as a content pack, not a parallel `QuizService`").
- CI (`ci.yml` in this app's own dir; scoped at the merged-repo root as
  `captain-adel-ios-ci.yml`/`captain-adel-ios-testflight.yml`) and a Fastlane + shell-script
  archive path both exist and are documented — unaffected by the above.

## Now

- **[product] Extraction plan: port first, remove second — do not remove first.** Sequence
  matters: `GACARLibraryView`, `AviationToolsView`, and `QuizService` stay live in this app,
  unchanged, **until FlyGACA's replacements actually ship** (real synced Library, ported Tools, the
  exam bank as a content pack — tracked in `apps/flygaca-ios/ROADMAP.md`'s flagship "Next"
  section). Removing them here first would regress every existing Captain Adel TestFlight/App
  Store user for however long the FlyGACA side takes. Once FlyGACA's versions are live and
  verified: delete `GACARLibraryView.swift`, `AviationToolsView.swift`, `METARService.swift`,
  `QuizService.swift`, and their tab-bar entries in `ContentView.swift`/`MyApp.swift`, leaving a
  chat-only tab bar (Chat + About, plus whatever voice/settings sheets the chat itself needs).
  This is a real Xcode-project change (`captadel.xcodeproj` target sources) — make it in a session
  with a Mac, or push it and let `ci.yml`'s `macos-15` build catch anything broken.
- **[platform] Verify the automated test suite is real Swift coverage, not just the Python
  harness.** `scripts/run_automated_tests.py` (29/29 passing per `README.md`) checks FMC math and
  corpus integrity from outside Xcode — valuable, but it is not `XCTest` and doesn't run inside
  the `ci.yml` build the way `flygaca-ios`'s `swift test` gate does. Decide: promote the same
  assertions into an `XCTest` target wired into `captadel.xcodeproj` (`testTargets:` in whatever
  generates it), or explicitly document the Python suite as the permanent test gate and wire it
  into `ci.yml` as a required job. Right now it's neither gated in CI nor mirrored in Swift.
- **[platform] Close out the `TESTFLIGHT_READINESS.md` checklist end to end.** The pre-submission
  checklist (§5) is checked off through CI/Fastlane setup; confirm the App Store Connect record
  itself exists (§4: app created, bundle ID `com.flygaca.captainadel` selected, SKU
  `CAPT-ADEL-IOS-01`) and that Internal/External TestFlight groups are populated — this is
  portal-only work, nothing in-repo changes.
- **[docs] Point this app's own `CLAUDE.md`-equivalent (currently just `README.md` +
  `TESTFLIGHT_READINESS.md`) at this `ROADMAP.md`** the way `apps/flygaca-ios/CLAUDE.md` points at
  its own — so future sessions land on forward-looking open items instead of re-deriving them from
  the feature list.

## Next

- **[product] Decide the monetization model.** Nothing in this app's docs sets a price, a
  subscription, or a "free forever" policy — unlike `apps/flygaca-ios` (paid-up-front modules) or
  the flagship (free app, metered Captain Adel via subscription). This app ships a materially
  larger offline corpus and more compute (on-device vector search, voice) than either, so "free
  forever" has a real hosting/support cost even with zero cloud inference by default. Options,
  roughly in order of engineering cost: (a) stay free, monetize nothing, treat it as a lead magnet
  for `captadel.com`'s own subscription; (b) one-time paid app (fits Apple's rules cleanly, no
  StoreKit subscription plumbing needed); (c) subscription gating only the optional cloud-provider
  path (offline doctrine mode stays free forever, cloud providers need Pro) — closest in spirit to
  the flagship's Captain Adel metering, but a separate implementation since these are separate
  apps by design.
- **[platform] API-key security review for the BYO-provider path.** `KeychainHelper.swift` stores
  user-supplied provider keys — confirm it's Keychain-backed (not `UserDefaults`) for every
  provider, that keys never appear in logs or `CaptainAdelAIService.swift`'s error paths, and that
  switching providers in `AISettingsSheet.swift` can't leak one provider's key to another
  provider's endpoint. Worth a pass with this repo's own
  `testing-mobile-api-authentication` skill given the multi-provider surface.
- **[product] Corpus freshness policy.** `GACARCorpusDatabase.swift` ships the 74-part corpus
  on-device with no stated update mechanism (unlike `flygaca-ios`'s signed `quiz.json` remote
  refresh). Decide whether GACAR amendments require an app-binary update (simplest, matches
  "paid app, occasional releases") or a signed remote refresh channel of its own — if the latter,
  the `implementing-digital-signatures-with-ed25519` skill and `flygaca-ios`'s
  `CorpusSignatureVerifier.swift` are the direct precedent to copy the pattern from, not
  reinvent.

## Later

- **[platform] Point this app's corpus at the same synced source FlyGACA uses.**
  `GACARCorpusDatabase.swift` is a hand-typed third copy of the 74-part corpus. Once
  `apps/flygaca-ios`'s content-sync extension lands (pulling `public/data/parts/*.html` +
  `gacar-index.json` from `ay2m/FlyGACA` on every `sync-content.sh` run), give this app the same
  synced snapshot instead of maintaining its own by hand — the retrieval *engine*
  (`GACARVectorSearchEngine.swift`) stays exactly as-is, only its data source changes from
  hand-typed Swift to a synced JSON/HTML bundle. This is a content-sourcing fix, not a coupling to
  `FlyGACA` at runtime — account/entitlement independence (see the top of this file) is unaffected.
- **[product] Account-level integration stays a live option, not a plan.** `AIProviderConfig`'s
  existing `.flyGACA` cloud-RAG provider option shows the two apps *can* talk if a future business
  decision wants shared accounts or entitlements — don't build toward that unprompted; this line
  exists so a future revisit starts from "here's the one existing integration point" instead of
  zero.
- **[platform] iPad/Mac Catalyst verification.** `TESTFLIGHT_READINESS.md` states iOS 17+
  "Supports iPhone, iPad & Mac Catalyst" — confirm the voice-comms and METAR views actually adapt
  (they read as iPhone-cockpit-HUD-shaped UI); if Catalyst was declared but never verified on a
  larger canvas, either fix the layouts or narrow the declared device support.

## How we ship (Definition of Done)

- A change to `MyApp/` builds cleanly via `./scripts/archive_testflight.sh` or
  `bundle exec fastlane beta` before merging — this repo has no `swift test` equivalent gate yet
  (see "Now" above), so a clean archive is the current bar.
- The "Cite or Refuse" doctrine (cosine ≥ 0.28 or refuse) is never relaxed to make a demo answer
  look better — a refusal is a correct answer, not a bug.
- The disclaimer (independent platform, not affiliated with GACA, GACA is authoritative) stays
  verbatim everywhere it appears, matching every other Fly GACA surface.
- Any change that touches account, entitlement, or login coupling with another family service
  (`flygaca.com`, `captadel.com`, or otherwise) is a product decision first — flag it, don't wire
  it silently. Content-sourcing changes (pointing at a synced corpus snapshot, per "Later" above)
  are not this — that's a data-pipeline fix, not a coupling decision.
- Don't remove `GACARLibraryView`, `AviationToolsView`, or `QuizService` until their FlyGACA
  replacements are live — see "Now" above. A PR that removes one without the other existing and
  verified is out of sequence, not "ahead of schedule".
