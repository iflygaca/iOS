import subprocess
import time
import os

DEVICE = "CD8F853E-5A3D-46F2-B05D-B00B5D5D079A"
BUNDLE = "com.flygaca.captainadel"
APP_PATH = "/tmp/CaptAdelBuild/Build/Products/Debug-iphonesimulator/Captain Adel.app"
OUT = "fastlane/screenshots/raw"

def capture_tab(tab_idx, name):
    # Update tab in ContentView
    subprocess.run(f"perl -pi -e 's/\@State private var selectedTab: Int = \\d+/\@State private var selectedTab: Int = {tab_idx}/' MyApp/ContentView.swift", shell=True)
    # Build
    subprocess.run(f'xcodebuild -project captadel.xcodeproj -scheme MyApp -destination "id={DEVICE}" -derivedDataPath /tmp/CaptAdelBuild build > /dev/null', shell=True)
    # Reinstall and launch
    subprocess.run(f"xcrun simctl terminate {DEVICE} {BUNDLE}", shell=True)
    subprocess.run(f"xcrun simctl install {DEVICE} '{APP_PATH}'", shell=True)
    subprocess.run(f"xcrun simctl launch {DEVICE} {BUNDLE}", shell=True)
    time.sleep(3)
    subprocess.run(f"xcrun simctl io {DEVICE} screenshot {OUT}/{name}", shell=True)
    print(f"Captured {name}")

# Capture 4 tabs
capture_tab(0, "01_copilot_chat.png")
capture_tab(1, "02_gacar_library.png")
capture_tab(2, "03_aviation_tools.png")
capture_tab(3, "04_about_doctrine.png")

# Reset tab to 0
subprocess.run("perl -pi -e 's/\@State private var selectedTab: Int = \\d+/\@State private var selectedTab: Int = 0/' MyApp/ContentView.swift", shell=True)
print("Done!")
