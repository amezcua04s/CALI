import Foundation

// MARK: - UserProfile

struct UserProfile: Codable {
    var name: String
    var lastName: String
    var studentNumber: String
    var generation: String
    var career: Career?
    var currentSemester: Int
    var email: String
    var questionnaireAnswers: QuestionnaireAnswers?

    init(
        name: String = "",
        lastName: String = "",
        studentNumber: String = "",
        generation: String = "",
        career: Career? = nil,
        currentSemester: Int = 1,
        email: String = ""
    ) {
        self.name = name
        self.lastName = lastName
        self.studentNumber = studentNumber
        self.generation = generation
        self.career = career
        self.currentSemester = currentSemester
        self.email = email
    }
}

// MARK: - QuestionnaireAnswers

struct QuestionnaireAnswers: Codable {
    var interests: [String]
    var specialization: String
    var goals: String
}
