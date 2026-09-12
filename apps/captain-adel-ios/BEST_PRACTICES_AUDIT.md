# iOS & Xcode Best Practices Audit — Captain Adel iOS

Scope: `captadel.xcodeproj` and `MyApp/` (flat SwiftUI app target), plus the CI/CD workflows and
release scripts under `.github/workflows/` and `scripts/`. Performed from a Linux session with no
Xcode/macOS toolchain available, so every finding below was verified by reading the project file,
source, and workflow YAML directly rather than by building — Xcode-project-level fixes should
still be confirmed with a real build on a Mac (or by CI) before release.

## Fixed in this pass

1. **`IPHONEOS_DEPLOYMENT_TARGET` was 27.0, contradicting the app's own documented minimum.**
   `project.pbxproj` set the deployment target to iOS 27.0 in both Debug and Release, while
   `README.md`, its badges, and `TESTFLIGHT_READINESS.md` all state **iOS 17.0+** as the
   supported minimum — and nothing in the code requires anything newer (the only
   `#available` check in the codebase gates on iOS 17.0). Left as-is, this would have made the
   App Store binary installable only on devices running the very latest OS, silently locking out
   every iOS 17/18-era device the app claims to support. Set to `17.0` in both configurations to
   match the documented and coded minimum.

2. **`ENABLE_APP_SANDBOX` and `REGISTER_APP_GROUPS` were declared with no corresponding
   entitlements or code.** Both are project-level build settings inherited from Xcode's default
   multiplatform app template. `ENABLE_APP_SANDBOX` configures the macOS App Sandbox — a concept
   that doesn't apply to this iOS-only shipping target (iOS apps are sandboxed by the OS
   unconditionally). `REGISTER_APP_GROUPS` declares an App Groups capability, but there is no
   `.entitlements` file, no App Group identifier configured anywhere, and no code
   (`UserDefaults(suiteName:)`, shared containers, etc.) that uses one. Carrying an unused
   capability declaration adds unnecessary provisioning-profile surface for automatic signing to
   negotiate for no benefit. Removed both from Debug and Release.

3. **CI TestFlight workflow hardcoded a fallback keychain password (`flightkeychain123`) in
   source.** `.github/workflows/testflight.yml` used
   `KEYCHAIN_PASSWORD: ${{ secrets.KEYCHAIN_PASSWORD || 'flightkeychain123' }}` — if the
   `KEYCHAIN_PASSWORD` repo secret was never set, every run unlocked the temporary signing
   keychain with a password checked into version control. The keychain only lives for the
   duration of the job on an ephemeral GitHub-hosted runner, so the practical exposure is low, but
   hardcoding any credential — even one protecting short-lived local state — is worth avoiding on
   principle and it's a one-line fix. It now generates a random password
   (`openssl rand -base64 32`) per run when the secret isn't configured, and a new "Remove
   Temporary Signing Keychain" step deletes the keychain at the end of the job (`if: always()`)
   so the imported signing certificate doesn't linger for the rest of the job's lifetime.

## Findings noted but intentionally left alone

These are real observations, but each needs either a product decision, a real Xcode/macOS build to
verify, or is already mitigated well enough that a blind change carries more risk than benefit.

- **`project.pbxproj` still says `"Untitled Project"` and was generated fresh by Xcode 26.3
  (`objectVersion = 90`, `CreatedOnToolsVersion = 26.3`)**, while both CI workflows explicitly try
  to `xcode-select -s /Applications/Xcode_16.app` first (falling back to whatever `Xcode.app`
  resolves to). Xcode 16 cannot open a project file in a format written by Xcode 26.3 — the
  fallback to the runner's default `Xcode.app` is likely what actually makes CI work today. Worth
  either updating the pinned Xcode selector to match whatever version is guaranteed present on the
  `macos-15` runner image, or moving to a runner image whose default Xcode matches the project
  format — a call best made by whoever last verified CI actually goes green today, since I can't
  run either workflow here to confirm which path it currently takes.
- **`MACOSX_DEPLOYMENT_TARGET`, `WATCHOS_DEPLOYMENT_TARGET`, `APPLETVOS_DEPLOYMENT_TARGET`,
  `XROS_DEPLOYMENT_TARGET`, and `DRIVERKIT_DEPLOYMENT_TARGET` are all still 27.0**, and
  `SUPPORTED_PLATFORMS` includes `macosx` and `xros` even though `TARGETED_DEVICE_FAMILY = "1,2,7"`
  and every product surface (README, App Store category, UI) describes an iPhone/iPad cockpit app.
  This looks like more default-template cruft rather than a deliberate multiplatform/visionOS
  strategy. Trimming `SUPPORTED_PLATFORMS` and the unused deployment-target keys down to what's
  actually shipped would be a reasonable follow-up, but it's a product-scope call (does Captain
  Adel intend to ship on visionOS or Mac later?), not a pure bug fix, so left for a human decision.
- **`scripts/archive_testflight.sh` (the local/manual archiving path) uploads via
  `xcrun altool --upload-app`.** Apple has been steering developers away from `altool` for App
  Store uploads for a while now in favor of Transporter or the App Store Connect API directly.
  This script is documented as the manual/local convenience option — the actual CI/CD pipeline
  (`testflight.yml` → `fastlane beta` → `upload_to_testflight`) already uses Fastlane's current
  `upload_to_testflight` action, not `altool`, so production releases aren't affected. Worth
  modernizing the local script the next time someone touches it, ideally verified against a real
  Apple ID on a Mac rather than guessed at here.
- **No test target exists anywhere in the project** (`find . -iname "*Tests*"` returns nothing).
  `CaptainAdelAIService`, `GACARVectorSearchEngine`, and `METARService` all have unit-testable pure
  logic (TF-IDF retrieval, METAR decoding, connection-health parsing) that would benefit from a
  test target. Since this project has no Swift package to run `swift test` against (unlike
  `apps/flygaca-ios/apple/FlyGACAKit` in the merged `iflygaca/ios` repo), adding one means
  creating a new Xcode test target in `project.pbxproj` by hand — a meaningfully sized, unverifiable
  change to make blind in a Linux session. Flagging as the single highest-value follow-up for
  someone on a Mac.

## Already solid — no change needed

Worth calling out so future contributors don't second-guess these:

- No force-unwraps (`try!`, `as!`) anywhere in `MyApp/`.
- `KeychainHelper` uses `kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly` — the correct
  accessibility level for locally-scoped API credentials (never syncs to iCloud Keychain, never
  accessible before first unlock).
- `CockpitVoiceCommsService` and `CaptainAdelAIService` are properly `@MainActor`-isolated, use
  `[weak self]` consistently in closures and delegate callbacks, and hop back to the main actor
  via `Task { @MainActor in ... }` from non-isolated contexts (e.g. the `AVAudioEngine` tap
  callback, `AVSpeechSynthesizerDelegate`).
- Build settings already opt into modern Swift concurrency defaults
  (`SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor`, `SWIFT_APPROACHABLE_CONCURRENCY = YES`,
  `SWIFT_UPCOMING_FEATURE_MEMBER_IMPORT_VISIBILITY = YES`) and Xcode 16-era hygiene
  (`LOCALIZATION_PREFERS_STRING_CATALOGS`, `ENABLE_USER_SCRIPT_SANDBOXING`,
  `CLANG_WARN_UNGUARDED_AVAILABILITY = YES_AGGRESSIVE`).
- `GACARVectorSearchEngine`'s on-device TF-IDF search runs synchronously on the main actor, which
  looks concerning at first glance for a search over 74 regulatory parts — but the corpus is small
  enough (and the engine's own telemetry, which is user-facing, measures and displays the actual
  latency) that this is a deliberate, measured design rather than a hidden perf bug. Left alone.
- Send-button UI (`ChatView`) already disables input while `aiService.isThinking`, so the lack of
  an internal re-entrancy guard inside `CaptainAdelAIService.sendMessage` isn't an active bug.
- Info.plist usage-description strings (`NSMicrophoneUsageDescription`,
  `NSSpeechRecognitionUsageDescription`) are present and match the two permissions the app
  actually requests; no location, background modes, or other undeclared entitlements found.
