# Captain Adel iOS - App Store & TestFlight Readiness Guide

This document provides complete instructions for submitting **Captain Adel (كابتن عادل)** to Apple TestFlight and the iOS App Store, along with instructions for operating the automated CI/CD pipeline.

---

## 1. Release Architecture & Metadata

| Field | Configuration | Notes |
| :--- | :--- | :--- |
| **App Name** | Captain Adel | Localized as "كابتن عادل" |
| **Bundle Identifier** | `com.flygaca.captainadel` | Registered under GACA / FlyGACA Apple Team |
| **Primary Category** | Reference (`public.app-category.reference`) | Sub-category: Utilities / Education |
| **Marketing Version** | `1.0.0` | Initial production launch |
| **Build Number** | `1` (Auto-incremented on CI) | Managed via git commit count / Fastlane |
| **Deployment Target** | iOS 17.0+ | Supports iPhone, iPad & Mac Catalyst |
| **Export Compliance** | `ITSAppUsesNonExemptEncryption: NO` | Exempt standard HTTPS/API encryption |
| **App Icon** | 1024x1024 Universal (`AppIcon-1024.png`) | No alpha channel, App Store compliant |

### Privacy Permissions Configured
- **Microphone Usage (`NSMicrophoneUsageDescription`)**:
  > *"Captain Adel uses your microphone for real-time voice interactions and GACAR regulatory comms."*
- **Speech Recognition (`NSSpeechRecognitionUsageDescription`)**:
  > *"Speech recognition transcribes pilot queries directly in cockpit voice mode."*

---

## 2. Fastlane & Local CLI Archiving

### Option A: Local Shell Script (Zero dependencies required)
We provide a standalone executable archiving script:
```bash
./scripts/archive_testflight.sh
```
This script:
1. Cleans and creates `build/MyApp.xcarchive` targeting generic iOS devices.
2. Exports a production-ready `.ipa` using `ExportOptions.plist`.
3. Opens the Xcode Organizer or uploads directly if API keys are set.

### Option B: Fastlane Beta Delivery
Install dependencies and trigger an automated beta release:
```bash
bundle install
bundle exec fastlane beta
```
Optional arguments:
```bash
bundle exec fastlane beta build_number:42 changelog:"FL380 Flight Mode: Offline 74-part vector search"
```

---

## 3. GitHub Actions CI/CD Setup

The repository is equipped with two workflows in `.github/workflows/`:
1. **`ci.yml`**: Continuously builds and validates every pull request and push to `main`.
2. **`testflight.yml`**: Automatically builds, signs, and distributes builds to TestFlight when a tag (e.g. `v1.0.0`) is pushed or manually triggered via GitHub Actions UI.

### Required GitHub Secrets
Navigate to **GitHub Repository -> Settings -> Secrets and variables -> Actions**:

| Secret Name | Description | Source |
| :--- | :--- | :--- |
| `APP_STORE_CONNECT_KEY_ID` | 10-character Key ID (e.g., `2X9R427HG7`) | App Store Connect -> Users and Access -> Integrations -> Keys |
| `APP_STORE_CONNECT_ISSUER_ID` | UUID Issuer ID | App Store Connect -> Users and Access -> Integrations -> Keys |
| `APP_STORE_CONNECT_KEY_CONTENT` | Base64-encoded `.p8` private key file | `cat AuthKey_XXXXXX.p8 \| base64` |
| `APPLE_TEAM_ID` | 10-character Apple Developer Team ID | Apple Developer Account -> Membership |
| `APPLE_ID` | Apple ID email (optional fallback) | e.g. `i@flygaca.com` |

---

## 4. App Store Connect First-Time Setup Checklist

1. **Register App ID**:
   - Go to [Apple Developer Certificates, Identifiers & Profiles](https://developer.apple.com/account/resources/identifiers/list).
   - Click `+` -> Select **App IDs** -> App.
   - Description: `Captain Adel iOS`.
   - Bundle ID: Explicit -> `com.flygaca.captainadel`.
   - Capabilities: Enable **Push Notifications** (optional for future flight alerts).

2. **Create New App in App Store Connect**:
   - Go to [App Store Connect -> Apps](https://appstoreconnect.apple.com/apps).
   - Click `+` -> **New App**.
   - Platforms: **iOS**.
   - Name: `Captain Adel - GACAR Pilot AI`.
   - Primary Language: **English (US)** or **Arabic**.
   - Bundle ID: Select `com.flygaca.captainadel`.
   - SKU: `CAPT-ADEL-IOS-01`.
   - User Access: Full Access.

3. **Configure TestFlight Internal & External Groups**:
   - **Internal Testing**: Add developer and pilot core team emails (no Apple review needed, available immediately).
   - **External Testing**: Create group `GACA Flight Testers` (requires brief Beta App Review from Apple for the first build).

---

## 5. Pre-Submission TestFlight Checklist

- [x] Verified `captadel.xcodeproj` builds cleanly with zero errors.
- [x] Bundle ID set to `com.flygaca.captainadel`.
- [x] Version set to `1.0.0`, Build set to `1`.
- [x] Universal 1024x1024 App Store icon configured without alpha channel.
- [x] Privacy usage descriptions in Info.plist for Microphone & Speech Recognition.
- [x] `ITSAppUsesNonExemptEncryption` set to `NO`.
- [x] Standalone build & archive script `scripts/archive_testflight.sh` verified.
- [x] Fastlane configuration (`Fastfile`, `Appfile`, `Gemfile`) in place.
- [x] GitHub Actions CI/CD workflows (`ci.yml`, `testflight.yml`) active.

