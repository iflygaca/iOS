import SwiftUI

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                #if os(macOS)
                .frame(minWidth: 400, idealWidth: 440, maxWidth: 540, minHeight: 720, idealHeight: 880)
                #endif
        }
        #if os(macOS)
        .defaultSize(width: 440, height: 880)
        .windowResizability(.contentSize)
        #endif
    }
}
