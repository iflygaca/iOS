#!/usr/bin/env bash
# ==============================================================================
# Captain Adel iOS - TestFlight & App Store Archiving Automation
# ==============================================================================
set -euo pipefail

CYAN='\033[0;36m'
GREEN='\033[0;32m'
AMBER='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${PROJECT_DIR}"

echo -e "${CYAN}======================================================${NC}"
echo -e "${CYAN}  ✈️  CAPTAIN ADEL iOS - TESTFLIGHT ARCHIVE PIPELINE  ${NC}"
echo -e "${CYAN}======================================================${NC}"

# 1. Developer Directory & Toolchain Check
if [ -d "/Applications/Xcode-beta.app" ]; then
    export DEVELOPER_DIR="/Applications/Xcode-beta.app/Contents/Developer"
elif [ -d "/Applications/Xcode.app" ]; then
    export DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer"
fi
echo -e "Using Xcode: ${GREEN}$(xcode-select -p)${NC}"

SCHEME="MyApp"
PROJECT="captadel.xcodeproj"
BUILD_DIR="${PROJECT_DIR}/build"
ARCHIVE_PATH="${BUILD_DIR}/MyApp.xcarchive"
EXPORT_PATH="${BUILD_DIR}/Export"

# 2. Prepare Directories
rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}" "${EXPORT_PATH}"

# 3. Clean and Archive
echo -e "\n${AMBER}[1/3] Archiving scheme '${SCHEME}' for generic iOS device...${NC}"
xcodebuild clean archive \
    -project "${PROJECT}" \
    -scheme "${SCHEME}" \
    -configuration Release \
    -destination "generic/platform=iOS" \
    -archivePath "${ARCHIVE_PATH}" \
    CODE_SIGNING_ALLOWED=YES \
    -allowProvisioningUpdates \
    | xcbeautify 2>/dev/null || xcodebuild clean archive \
    -project "${PROJECT}" \
    -scheme "${SCHEME}" \
    -configuration Release \
    -destination "generic/platform=iOS" \
    -archivePath "${ARCHIVE_PATH}" \
    CODE_SIGNING_ALLOWED=YES \
    -allowProvisioningUpdates

echo -e "${GREEN}✓ Archive created successfully at: ${ARCHIVE_PATH}${NC}"

# 4. Export IPA
echo -e "\n${AMBER}[2/3] Exporting .ipa for App Store Connect distribution...${NC}"
if [ -f "${PROJECT_DIR}/ExportOptions.plist" ]; then
    xcodebuild -exportArchive \
        -archivePath "${ARCHIVE_PATH}" \
        -exportPath "${EXPORT_PATH}" \
        -exportOptionsPlist "${PROJECT_DIR}/ExportOptions.plist" \
        -allowProvisioningUpdates
    echo -e "${GREEN}✓ Export completed. Output IPA located at: ${EXPORT_PATH}${NC}"
else
    echo -e "${AMBER}ExportOptions.plist not found, skipping IPA export. Archive is ready for Xcode Organizer.${NC}"
fi

# 5. Optional Upload to App Store Connect / TestFlight
echo -e "\n${AMBER}[3/3] Upload validation status...${NC}"
if [ -n "${APP_STORE_CONNECT_KEY_ID:-}" ] && [ -n "${APP_STORE_CONNECT_ISSUER_ID:-}" ]; then
    echo -e "${CYAN}App Store Connect API credentials detected. Initiating TestFlight upload...${NC}"
    IPA_FILE=$(find "${EXPORT_PATH}" -name "*.ipa" | head -n 1)
    if [ -n "${IPA_FILE}" ]; then
        xcrun altool --upload-app \
            --type ios \
            --file "${IPA_FILE}" \
            --apiKey "${APP_STORE_CONNECT_KEY_ID}" \
            --apiIssuer "${APP_STORE_CONNECT_ISSUER_ID}"
        echo -e "${GREEN}✓ Upload to TestFlight submitted successfully!${NC}"
    fi
else
    echo -e "${CYAN}No CI upload credentials in environment. To upload via Xcode GUI:${NC}"
    echo -e "  1. Open Xcode Organizer: ${GREEN}open \"${ARCHIVE_PATH}\"${NC}"
    echo -e "  2. Click 'Distribute App' -> 'TestFlight & App Store'${NC}"
fi

echo -e "\n${GREEN}======================================================${NC}"
echo -e "${GREEN}  ✓ CAPTAIN ADEL BUILD IS READY FOR TESTFLIGHT        ${NC}"
echo -e "${GREEN}======================================================${NC}"

