import subprocess
import time
import os

DEVICE = "CD8F853E-5A3D-46F2-B05D-B00B5D5D079A"
BUNDLE = "com.flygaca.captainadel"
APP_PATH = "/tmp/CaptAdelBuild/Build/Products/Debug-iphonesimulator/Captain Adel.app"
OUT = "fastlane/screenshots/raw"
MYAPP_SWIFT = "MyApp/MyApp.swift"

def set_root_view(view_name):
    content = f"""import SwiftUI

@main
struct CaptainAdelApp: App {{
    @StateObject private var aiService = CaptainAdelAIService()
    @State private var lang: AppLanguage = .english

    var body: some Scene {{
        WindowGroup {{
            {view_name}
                .preferredColorScheme(.dark)
        }}
    }}
}}
"""
    with open(MYAPP_SWIFT, "w") as f:
        f.write(content)

def build_install_launch_snap(name):
    # build
    print(f"Building for {name}...")
    subprocess.run(f'xcodebuild -project captadel.xcodeproj -scheme MyApp -destination "id={DEVICE}" -derivedDataPath /tmp/CaptAdelBuild build > /dev/null', shell=True)
    # reinstall
    subprocess.run(f"xcrun simctl terminate {DEVICE} {BUNDLE}", shell=True)
    subprocess.run(f"xcrun simctl install {DEVICE} '{APP_PATH}'", shell=True)
    subprocess.run(f"xcrun simctl launch {DEVICE} {BUNDLE}", shell=True)
    time.sleep(3)
    out_path = f"{OUT}/{name}"
    subprocess.run(f"xcrun simctl io {DEVICE} screenshot {out_path}", shell=True)
    print(f"Saved {out_path}")

# 1. ChatView
set_root_view("ChatView(aiService: aiService, currentLanguage: $lang)")
build_install_launch_snap("01_copilot_chat.png")

# 2. GACARLibraryView
set_root_view("GACARLibraryView(aiService: aiService, currentLanguage: $lang)")
build_install_launch_snap("02_gacar_library.png")

# 3. AviationToolsView
set_root_view("AviationToolsView(currentLanguage: $lang)")
build_install_launch_snap("03_aviation_tools.png")

# 4. AboutView
set_root_view("AboutView(currentLanguage: $lang)")
build_install_launch_snap("04_about_doctrine.png")

# Restore original MyApp.swift
orig = """import SwiftUI

@main
struct CaptainAdelApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
"""
with open(MYAPP_SWIFT, "w") as f:
    f.write(orig)

print("All screens captured and MyApp.swift restored!")
