import SwiftUI

// MARK: - MainTabView
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
        // Pasamos el binding de la carrera directamente desde el perfil del usuario en el ViewModel
        .sheet(isPresented: $appViewModel.showQuestionnaire) {
            QuestionnaireView(selectedCareer: $appViewModel.userProfile.career)                .interactiveDismissDisabled(true) // Evita que se cierre deslizando
        }
    }
}
