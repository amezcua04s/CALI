import SwiftUI
import Combine

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

@MainActor
class AppViewModel: ObservableObject {

    private enum Keys {
        static let userProfile           = "userProfile"
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
        static let hasSeenQuestionnaire  = "hasSeenQuestionnaire"
        static let checklistItems        = "checklistItems"
        static let selectedSubjects      = "selectedSubjects"
    }

    @Published var userProfile: UserProfile
    @Published var hasCompletedOnboarding: Bool
    @Published var showQuestionnaire: Bool = false
    @Published var checklistItems: [ChecklistItem]
    @Published var selectedSubjects: [Subject]
    @Published var chatMessages: [ChatMessage] = []
    @Published var isAIThinking: Bool = false

    private let aiService = AICompanionService()

    init() {

        if let data = UserDefaults.standard.data(forKey: Keys.userProfile),
           let profile = try? JSONDecoder().decode(UserProfile.self, from: data) {
            self.userProfile = profile
        } else {
            self.userProfile = UserProfile()
        }

        self.hasCompletedOnboarding = UserDefaults.standard.bool(forKey: Keys.hasCompletedOnboarding)

        if let data = UserDefaults.standard.data(forKey: Keys.checklistItems),
           let items = try? JSONDecoder().decode([ChecklistItem].self, from: data) {
            self.checklistItems = items
        } else {
            self.checklistItems = ChecklistItem.defaultItems
        }

        if let data = UserDefaults.standard.data(forKey: Keys.selectedSubjects),
           let subjects = try? JSONDecoder().decode([Subject].self, from: data) {
            self.selectedSubjects = subjects
        } else {
            self.selectedSubjects = []
        }

        if hasCompletedOnboarding && !UserDefaults.standard.bool(forKey: Keys.hasSeenQuestionnaire) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
                self?.showQuestionnaire = true
            }
        }
    }


    func completeOnboarding() {
        hasCompletedOnboarding = true
        UserDefaults.standard.set(true, forKey: Keys.hasCompletedOnboarding)
        saveProfile()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.showQuestionnaire = true
        }
    }

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

    func dismissQuestionnaire() {
        showQuestionnaire = false
        UserDefaults.standard.set(true, forKey: Keys.hasSeenQuestionnaire)
    }

    func saveQuestionnaireAnswers(_ answers: QuestionnaireAnswers) {
        userProfile.questionnaireAnswers = answers
        saveProfile()
        dismissQuestionnaire()
    }

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

    // MARK: AI Chat

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
        let done = checklistItems.filter { $0.isCompleted }.map { $0.title }.joined(separator: ", ")
        if !done.isEmpty { ctx += "Ya completó: \(done). " }
        ctx += "Responde en español, sé conciso (máx 3 párrafos) y usa emojis ocasionalmente."
        return ctx
    }

    // MARK: Reset (debug / re-onboard)

    func resetApp() {
        [Keys.userProfile, Keys.hasCompletedOnboarding,
         Keys.hasSeenQuestionnaire, Keys.checklistItems, Keys.selectedSubjects]
            .forEach { UserDefaults.standard.removeObject(forKey: $0) }
        userProfile = UserProfile()
        checklistItems = ChecklistItem.defaultItems
        selectedSubjects = []
        chatMessages = []
        hasCompletedOnboarding = false
        showQuestionnaire = false
    }
}
