# Roadmap — Captain Adel iOS (`com.flygaca.captainadel`)

What's next for the standalone Captain Adel iOS app. **This app is fully independent of the
`FlyGACA` flagship app in `apps/flygaca-ios`** — decided 2026-09-12. No shared account, no shared
corpus, no shared entitlement, no planned migration of users between them. `apps/flygaca-ios` also
has its own Captain Adel *chat feature* (a tab inside its `FlyGACA` app target, backed by
`PlatformLive.CaptainAdelSSEClient` calling `flygaca.com/api/chat`) — that is a different product
with a different roadmap (`apps/flygaca-ios/ROADMAP.md`'s "flagship" section). Don't conflate the
two when reading either doc.

Read `README.md` for the full feature list and architecture and `TESTFLIGHT_READINESS.md` for the
release mechanics — this file looks forward only.

## What this app already is

Not a thin chat wrapper: a self-contained offline avionics/reference suite —

- **74-part GACAR corpus, 100% on-device** (`GACARCorpusDatabase.swift`), searched by an Int8
  quantized BM25 + cosine-similarity engine (`GACARVectorSearchEngine.swift`) with a hard
  cite-or-refuse threshold (cosine 0.28) — it refuses rather than answers ungrounded, same
  doctrine as the `captadel.com` service.
- **Hybrid cloud/offline AI** (`CaptainAdelAIService.swift`): the offline doctrine engine is
  always available; `AIProviderConfig.swift` also lets a user point the app at Hugging Face,
  a "Fly GACA Cloud RAG" endpoint, or any OpenAI-compatible API with their own key
  (`KeychainHelper.swift` stores it). This is a **user-configurable BYO-key option**, not a
  product dependency on `flygaca.com` — keep it that way; don't wire a default/mandatory call to
  another family service into this app without a deliberate decision (mirrors the "stays
  independent" call above).
- **Live Saudi METAR/TAF** for 26 aerodromes from NOAA (`METARService.swift`).
- **Hands-free cockpit voice comms**: bilingual (`ar-SA`/`en-US`) speech recognition + synthesized
  voice playback (`CockpitVoiceCommsService.swift`).
- **FMC flight-computer suite**: VFR fuel reserve, crosswind/headwind resolver, density altitude,
  top-of-descent — 4 real calculators, not stubs.
- **26-question GACAR exam bank** with bilingual explanations (`QuizService.swift`).
- CI (`ci.yml` in this app's own dir; scoped at the merged-repo root as
  `captain-adel-ios-ci.yml`/`captain-adel-ios-testflight.yml`) and a Fastlane + shell-script
  archive path both exist and are documented.

## Now

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

- **[product] Re-evaluate independence only if the business case changes.** The 2026-09-12
  decision to keep this app fully separate from `FlyGACA` is a product call, not a technical
  constraint — `AIProviderConfig`'s existing `.flyGACA` cloud-RAG option shows the two *can* talk
  if a future decision wants them to. Don't build toward that unprompted; this line exists so a
  future revisit starts from "here's the one existing integration point" instead of zero.
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
- Any change that touches whether this app talks to another family service (`flygaca.com`,
  `captadel.com`, or otherwise) is a product decision first — flag it, don't wire it silently,
  per the independence decision above.
