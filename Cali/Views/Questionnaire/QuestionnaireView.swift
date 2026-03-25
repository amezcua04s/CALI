import SwiftUI

// MARK: - QuestionnaireView
// Mandatory pop-up (shown once, cannot be swiped away).
// The user MUST see it, but answers are entirely optional.

struct QuestionnaireView: View {
    @EnvironmentObject var appViewModel: AppViewModel

    @State private var currentQuestion = 0
    @State private var selectedInterests: Set<String> = []
    @State private var specialization = ""
    @State private var goals = ""

    // MARK: Data

    private let interests = [
        "Inteligencia Artificial", "Desarrollo Web", "Ciencia de Datos",
        "Ciberseguridad", "Robótica", "Diseño UX/UI",
        "Investigación", "Emprendimiento", "Finanzas",
        "Redes", "Videojuegos", "Bioinformática"
    ]

    private let specializations = [
        "No lo he decidido aún",
        "Desarrollo de Software",
        "Inteligencia Artificial",
        "Sistemas Distribuidos",
        "Seguridad Informática",
        "Bases de Datos",
        "Redes y Telecomunicaciones",
        "Cómputo Gráfico",
        "Biocomputo"
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {

                // ── Header ─────────────────────────────────────
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Orientación Vocacional")
                                .font(.title3).fontWeight(.bold)
                            Text("Pregunta \(currentQuestion + 1) de 3 — respuesta opcional")
                                .font(.caption).foregroundStyle(.secondary)
                        }
                        Spacer()
                        Button {
                            appViewModel.dismissQuestionnaire()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2).foregroundStyle(.secondary)
                        }
                    }
                }
                .padding()
                .background(Color.white)

                ProgressView(value: Double(currentQuestion + 1), total: 3.0)
                    .tint(.blue)

                // ── Question content ────────────────────────────
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        switch currentQuestion {
                        case 0: interestsQuestion
                        case 1: specializationQuestion
                        default: goalsQuestion
                        }
                    }
                    .padding()
                }

                // ── Navigation ──────────────────────────────────
                HStack(spacing: 12) {
                    if currentQuestion > 0 {
                        Button("Atrás") { withAnimation { currentQuestion -= 1 } }
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(14)
                    }

                    Button(currentQuestion == 2 ? "Guardar y continuar" : "Siguiente") {
                        if currentQuestion == 2 { finish() }
                        else { withAnimation { currentQuestion += 1 } }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .cornerRadius(14)
                    .fontWeight(.semibold)
                }
                .padding()
                .background(Color.white)
            }
            .background(Color(.systemGroupedBackground))
        }
    }

    // MARK: - Question 1: Interests

    private var interestsQuestion: some View {
        VStack(alignment: .leading, spacing: 16) {
            questionHeader(
                title: "¿Qué áreas te interesan más?",
                subtitle: "Selecciona todas las que quieras — puedes dejarlo en blanco"
            )

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 130))], spacing: 10) {
                ForEach(interests, id: \.self) { interest in
                    let selected = selectedInterests.contains(interest)
                    Button {
                        if selected { selectedInterests.remove(interest) }
                        else { selectedInterests.insert(interest) }
                    } label: {
                        Text(interest)
                            .font(.subheadline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(selected ? Color.blue : Color.white)
                            .foregroundStyle(selected ? Color.white : Color.primary)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(selected ? Color.blue : Color.gray.opacity(0.3),
                                            lineWidth: 1)
                            )
                    }
                }
            }
        }
    }

    // MARK: - Question 2: Specialization

    private var specializationQuestion: some View {
        VStack(alignment: .leading, spacing: 16) {
            questionHeader(
                title: "¿En qué te gustaría especializarte?",
                subtitle: "Una opción — puedes dejarlo en blanco"
            )

            VStack(spacing: 8) {
                ForEach(specializations, id: \.self) { spec in
                    Button { specialization = spec } label: {
                        HStack {
                            Text(spec).font(.subheadline).foregroundStyle(Color.primary)
                            Spacer()
                            if specialization == spec {
                                Image(systemName: "checkmark.circle.fill").foregroundStyle(.blue)
                            }
                        }
                        .padding()
                        .background(specialization == spec ? Color.blue.opacity(0.08) : Color.white)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    specialization == spec ? Color.blue : Color.gray.opacity(0.2),
                                    lineWidth: 1
                                )
                        )
                    }
                }
            }
        }
    }

    // MARK: - Question 3: Goals

    private var goalsQuestion: some View {
        VStack(alignment: .leading, spacing: 16) {
            questionHeader(
                title: "¿Cuál es tu meta después de titularte?",
                subtitle: "Escribe brevemente — completamente opcional"
            )

            ZStack(alignment: .topLeading) {
                TextEditor(text: $goals)
                    .frame(minHeight: 150)
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )

                if goals.isEmpty {
                    Text("p. ej. Hacer posgrado en IA, trabajar en empresa tech, emprender…")
                        .font(.subheadline)
                        .foregroundStyle(.tertiary)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 18)
                        .allowsHitTesting(false)
                }
            }
        }
    }

    // MARK: - Helpers

    private func questionHeader(title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title).font(.title3).fontWeight(.bold)
            Text(subtitle).font(.subheadline).foregroundStyle(.secondary)
        }
    }

    private func finish() {
        let answers = QuestionnaireAnswers(
            interests: Array(selectedInterests),
            specialization: specialization,
            goals: goals
        )
        appViewModel.saveQuestionnaireAnswers(answers)
    }
}
