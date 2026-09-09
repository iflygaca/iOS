import subprocess
import time
import os

DEVICE = "CD8F853E-5A3D-46F2-B05D-B00B5D5D079A"
BUNDLE = "com.flygaca.captainadel"
APP_PATH = "/tmp/CaptAdelBuild/Build/Products/Debug-iphonesimulator/Captain Adel.app"
OUT = "fastlane/screenshots/raw"
CONTENT_VIEW = "MyApp/ContentView.swift"

os.makedirs(OUT, exist_ok=True)

tabs = [
    (0, "01_copilot_chat.png"),
    (1, "02_gacar_library.png"),
    (2, "03_aviation_tools.png"),
    (3, "04_about_doctrine.png"),
]

for tab_idx, filename in tabs:
    print(f"Setting tab {tab_idx} for {filename}...")
    subprocess.run(f"perl -pi -e 's/\\@State private var selectedTab: Int = \\d+/\\@State private var selectedTab: Int = {tab_idx}/' {CONTENT_VIEW}", shell=True)
    subprocess.run(f'xcodebuild -project captadel.xcodeproj -scheme MyApp -destination "id={DEVICE}" -derivedDataPath /tmp/CaptAdelBuild build > /dev/null 2>&1', shell=True)
    subprocess.run(f"xcrun simctl terminate {DEVICE} {BUNDLE} > /dev/null 2>&1", shell=True)
    subprocess.run(f"xcrun simctl install {DEVICE} '{APP_PATH}' > /dev/null 2>&1", shell=True)
    subprocess.run(f"xcrun simctl launch {DEVICE} {BUNDLE} > /dev/null 2>&1", shell=True)
    time.sleep(4)
    out_file = f"{OUT}/{filename}"
    subprocess.run(f"xcrun simctl io {DEVICE} screenshot {out_file}", shell=True)
    print(f"Captured {out_file}")

# Reset tab to 0
subprocess.run(f"perl -pi -e 's/\\@State private var selectedTab: Int = \\d+/\\@State private var selectedTab: Int = 0/' {CONTENT_VIEW}", shell=True)
print("Finished capturing all 4 clean tabs!")
