import SwiftUI

// MARK: - CALIApp
// Entry point for the CALI iOS application.
// Target: iOS 18.0+ (iOS 26 / Xcode 26 when available)

@main
struct CALIApp: App {
    @StateObject private var appViewModel = AppViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appViewModel)
        }
    }
}
