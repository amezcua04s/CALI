import SwiftUI

// MARK: - ContentView
// Root view: decides whether to show Onboarding or the main TabBar.

struct ContentView: View {
    @EnvironmentObject var appViewModel: AppViewModel

    var body: some View {
        Group {
            if appViewModel.hasCompletedOnboarding {
                MainTabView()
                    .transition(.opacity.combined(with: .scale(scale: 0.97)))
            } else {
                OnboardingView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.35), value: appViewModel.hasCompletedOnboarding)
    }
}
