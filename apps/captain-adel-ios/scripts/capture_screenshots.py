import subprocess
import time
import os

DEVICE_ID = "CD8F853E-5A3D-46F2-B05D-B00B5D5D079A"
BUNDLE_ID = "com.flygaca.captainadel"
OUTPUT_DIR = "fastlane/screenshots/raw"

def run(cmd):
    res = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    return res.stdout.strip()

def switch_tab_and_relaunch(tab_index, filename):
    print(f"Setting default tab to {tab_index}...")
    # Modify ContentView.swift
    subprocess.run(f"perl -pi -e 's/\@State private var selectedTab: Int = \\d+/\@State private var selectedTab: Int = {tab_index}/' MyApp/ContentView.swift", shell=True)
    # Build for simulator
    print("Building for simulator...")
    subprocess.run('xcodebuild -project captadel.xcodeproj -scheme MyApp -destination "id=CD8F853E-5A3D-46F2-B05D-B00B5D5D079A" -derivedDataPath /tmp/CaptAdelBuild build > /dev/null', shell=True)
    
    # Terminate app
    subprocess.run(f"xcrun simctl terminate {DEVICE_ID} {BUNDLE_ID}", shell=True)
    
    # Install updated app
    app_path = "/tmp/CaptAdelBuild/Build/Products/Debug-iphonesimulator/Captain Adel.app"
    subprocess.run(f"xcrun simctl install {DEVICE_ID} '{app_path}'", shell=True)
    
    # Launch app
    subprocess.run(f"xcrun simctl launch {DEVICE_ID} {BUNDLE_ID}", shell=True)
    time.sleep(2)
    
    # Capture screenshot
    out_file = os.path.join(OUTPUT_DIR, filename)
    subprocess.run(f"xcrun simctl io {DEVICE_ID} screenshot {out_file}", shell=True)
    print(f"Captured: {out_file}")

# 1: Library, 2: Tools, 3: About
switch_tab_and_relaunch(1, "02_gacar_library.png")
switch_tab_and_relaunch(2, "03_aviation_tools.png")
switch_tab_and_relaunch(3, "04_about_doctrine.png")

# Reset ContentView back to tab 0
subprocess.run("perl -pi -e 's/\@State private var selectedTab: Int = \\d+/\@State private var selectedTab: Int = 0/' MyApp/ContentView.swift", shell=True)
print("Finished capturing tabs!")
