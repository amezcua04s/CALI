import SwiftUI

// MARK: - MainTabView
// Root container after onboarding. Shows two tabs: Principal + Perfil.

struct MainTabView: View {
    @EnvironmentObject var appViewModel: AppViewModel

    var body: some View {
        TabView {
            PrincipalView()
                .tabItem {
                    Label("Principal", systemImage: "house.fill")
                }

            PerfilView()
                .tabItem {
                    Label("Perfil", systemImage: "person.crop.circle.fill")
                }
        }
        // Mandatory questionnaire pop-up – user MUST see it but CAN skip answering
        .sheet(isPresented: $appViewModel.showQuestionnaire) {
            QuestionnaireView()
                .interactiveDismissDisabled(true) // Prevents swipe-to-dismiss
        }
    }
}
