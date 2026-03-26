import SwiftUI
import Combine

// MARK: - ChatMessage

struct ChatMessage: Identifiable {
    let id = UUID()
    let role: Role
    let content: String
    let timestamp = Date()

    enum Role {
        case user
        case assistant
    }
}

// MARK: - AppViewModel

@MainActor
class AppViewModel: ObservableObject {

    // MARK: Persistence keys

    private enum Keys {
        static let userProfile            = "userProfile"
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
        static let hasSeenQuestionnaire   = "hasSeenQuestionnaire"
        static let checklistItems         = "checklistItems"
        static let selectedSubjects       = "selectedSubjects"
        static let graduationOption       = "graduationOption"
        static let revisionCount          = "revisionCount"
        static let fechaInscripcion       = "fechaInscripcion"
        static let diplomadoNombre        = "diplomadoNombre"
    }

    // MARK: Published state

    @Published var userProfile: UserProfile
    @Published var hasCompletedOnboarding: Bool
    @Published var showQuestionnaire: Bool = false
    @Published var checklistItems: [ChecklistItem]
    @Published var selectedSubjects: [Subject]
    @Published var chatMessages: [ChatMessage] = []
    @Published var isAIThinking: Bool = false

    // MARK: Graduation settings (didSet NOT called during init)

    @Published var selectedGraduationOption: ChecklistItem.GraduationOption? {
        didSet { saveGraduationSettings(); regenerateChecklist() }
    }
    @Published var revisionCount: Int = 2 {
        didSet { saveGraduationSettings(); regenerateChecklist() }
    }
    @Published var fechaInscripcion: String = "" {
        didSet { saveGraduationSettings(); regenerateChecklist() }
    }
    @Published var diplomadoNombre: String = "" {
        didSet { saveGraduationSettings(); regenerateChecklist() }
    }

    private let aiService = AICompanionService()

    // MARK: Init
        init() {
            // 1. Extraer datos a variables locales primero
            let profile: UserProfile
            if let data = UserDefaults.standard.data(forKey: Keys.userProfile),
               let decoded = try? JSONDecoder().decode(UserProfile.self, from: data) {
                profile = decoded
            } else {
                profile = UserProfile()
            }

            let onboarding = UserDefaults.standard.bool(forKey: Keys.hasCompletedOnboarding)

            let subjects: [Subject]
            if let data = UserDefaults.standard.data(forKey: Keys.selectedSubjects),
               let decoded = try? JSONDecoder().decode([Subject].self, from: data) {
                subjects = decoded
            } else {
                subjects = []
            }

            let savedOption = UserDefaults.standard.string(forKey: Keys.graduationOption)
                .flatMap { ChecklistItem.GraduationOption(rawValue: $0) }

            let savedRC = UserDefaults.standard.integer(forKey: Keys.revisionCount)
            let finalRC = (savedRC == 0) ? 2 : savedRC

            let fecha   = UserDefaults.standard.string(forKey: Keys.fechaInscripcion) ?? ""
            let nombre  = UserDefaults.standard.string(forKey: Keys.diplomadoNombre) ?? ""

            let savedItems: [ChecklistItem]
            if let data = UserDefaults.standard.data(forKey: Keys.checklistItems),
               let items = try? JSONDecoder().decode([ChecklistItem].self, from: data) {
                savedItems = items
            } else {
                savedItems = []
            }

            // 2. Inicializar todas las propiedades (ahora el compilador está feliz)
            self.userProfile = profile
            self.hasCompletedOnboarding = onboarding
            self.selectedSubjects = subjects
            self.selectedGraduationOption = savedOption
            self.revisionCount = finalRC
            self.fechaInscripcion = fecha
            self.diplomadoNombre  = nombre

            // 3. Ahora sí podemos usar lógica para el checklist
            let isNI = profile.career?.name == "Negocios Internacionales"
            
            self.checklistItems = AppViewModel.buildChecklist(
                from: savedItems,
                isNegociosInternacionales: isNI,
                option: savedOption,
                revisionCount: finalRC,
                fechaInscripcion: fecha,
                diplomadoNombre: nombre
            )

            // 4. Programar tareas posteriores
            if onboarding && !UserDefaults.standard.bool(forKey: Keys.hasSeenQuestionnaire) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
                    self?.showQuestionnaire = true
                }
            }
        }
    // MARK: - Checklist Regeneration

    /// Builds a checklist preserving completion state (matched by title).
    private static func buildChecklist(
        from saved: [ChecklistItem],
        isNegociosInternacionales: Bool,
        option: ChecklistItem.GraduationOption?,
        revisionCount: Int,
        fechaInscripcion: String,
        diplomadoNombre: String
    ) -> [ChecklistItem] {
        // Map previous completion state by title
        let completedTitles = Set(saved.filter { $0.isCompleted }.map { $0.title })

        // Section 1
        var result = ChecklistItem.obligatorioItems(isNegociosInternacionales: isNegociosInternacionales)
        for i in result.indices {
            result[i].isCompleted = completedTitles.contains(result[i].title)
        }

        // Section 2
        if let opt = option {
            var modal = ChecklistItem.modalidadItems(
                option: opt,
                revisionCount: revisionCount,
                fechaInscripcion: fechaInscripcion,
                diplomadoNombre: diplomadoNombre
            )
            for i in modal.indices {
                modal[i].isCompleted = completedTitles.contains(modal[i].title)
            }
            result += modal
        }

        return result
    }

    /// Rebuilds checklistItems preserving current completion state.
    func regenerateChecklist() {
        checklistItems = AppViewModel.buildChecklist(
            from: checklistItems,
            isNegociosInternacionales: isNegociosInternacionales,
            option: selectedGraduationOption,
            revisionCount: revisionCount,
            fechaInscripcion: fechaInscripcion,
            diplomadoNombre: diplomadoNombre
        )
        saveChecklist()
    }
    
    

    // MARK: - Computed helpers

    var isNegociosInternacionales: Bool {
        userProfile.career?.name == "Negocios Internacionales"
    }

    // MARK: - Onboarding

    func completeOnboarding() {
        hasCompletedOnboarding = true
        UserDefaults.standard.set(true, forKey: Keys.hasCompletedOnboarding)
        saveProfile()
        // Rebuild checklist now that career is known
        regenerateChecklist()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.showQuestionnaire = true
        }
    }

    // MARK: - Persistence

    func saveProfile() {
        if let data = try? JSONEncoder().encode(userProfile) {
            UserDefaults.standard.set(data, forKey: Keys.userProfile)
        }
    }

    func saveChecklist() {
        if let data = try? JSONEncoder().encode(checklistItems) {
            UserDefaults.standard.set(data, forKey: Keys.checklistItems)
        }
    }

    func saveSubjects() {
        if let data = try? JSONEncoder().encode(selectedSubjects) {
            UserDefaults.standard.set(data, forKey: Keys.selectedSubjects)
        }
    }

    private func saveGraduationSettings() {
        if let opt = selectedGraduationOption {
            UserDefaults.standard.set(opt.rawValue, forKey: Keys.graduationOption)
        } else {
            UserDefaults.standard.removeObject(forKey: Keys.graduationOption)
        }
        UserDefaults.standard.set(revisionCount,    forKey: Keys.revisionCount)
        UserDefaults.standard.set(fechaInscripcion, forKey: Keys.fechaInscripcion)
        UserDefaults.standard.set(diplomadoNombre,  forKey: Keys.diplomadoNombre)
    }

    // MARK: - Questionnaire

    func dismissQuestionnaire() {
        showQuestionnaire = false
        UserDefaults.standard.set(true, forKey: Keys.hasSeenQuestionnaire)
    }

    func saveQuestionnaireAnswers(_ answers: QuestionnaireAnswers) {
        userProfile.questionnaireAnswers = answers
        saveProfile()
        dismissQuestionnaire()
    }

    // MARK: - Checklist helpers

    func toggleChecklistItem(_ item: ChecklistItem) {
        guard let index = checklistItems.firstIndex(where: { $0.id == item.id }) else { return }
        checklistItems[index].isCompleted.toggle()
        saveChecklist()
    }

    var completionPercentage: Double {
        let required = checklistItems.filter { $0.requiredForGraduation }
        guard !required.isEmpty else { return 0 }
        let completed = required.filter { $0.isCompleted }
        return Double(completed.count) / Double(required.count) * 100
    }

    // MARK: - AI Chat

    func sendMessage(_ text: String) async {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        chatMessages.append(ChatMessage(role: .user, content: trimmed))
        isAIThinking = true
        defer { isAIThinking = false }

        do {
            let reply = try await aiService.respond(to: trimmed, context: buildContext())
            chatMessages.append(ChatMessage(role: .assistant, content: reply))
        } catch {
            chatMessages.append(ChatMessage(role: .assistant,
                content: "Lo siento, tuve un problema al responder. ¿Intentamos de nuevo? 😊"))
        }
    }

    private func buildContext() -> String {
        var ctx = "Eres CALI (Carrera, Aliado, Cálido), un asistente académico amable de la UNAM. "
        ctx += "El alumno se llama \(userProfile.name) \(userProfile.lastName). "
        if let career = userProfile.career {
            ctx += "Estudia \(career.name) en \(career.faculty). "
            ctx += "Está en el semestre \(userProfile.currentSemester) de \(career.durationSemesters). "
        }
        if let opt = selectedGraduationOption {
            ctx += "Su modalidad de titulación es: \(opt.rawValue). "
        }
        let done = checklistItems.filter { $0.isCompleted }.map { $0.title }.joined(separator: ", ")
        if !done.isEmpty { ctx += "Ya completó: \(done). " }
        ctx += "Responde en español, sé conciso (máx 3 párrafos) y usa emojis ocasionalmente."
        return ctx
    }

    // MARK: - Reset (debug / re-onboard)

    func resetApp() {
        [Keys.userProfile, Keys.hasCompletedOnboarding,
         Keys.hasSeenQuestionnaire, Keys.checklistItems, Keys.selectedSubjects,
         Keys.graduationOption, Keys.revisionCount, Keys.fechaInscripcion, Keys.diplomadoNombre]
            .forEach { UserDefaults.standard.removeObject(forKey: $0) }
        userProfile = UserProfile()
        selectedGraduationOption = nil   // didSet will call regenerateChecklist
        revisionCount = 2
        fechaInscripcion = ""
        diplomadoNombre  = ""
        selectedSubjects = []
        chatMessages = []
        hasCompletedOnboarding = false
        showQuestionnaire = false
    }
}
