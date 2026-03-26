import SwiftUI

struct QuestionnaireView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @Binding var selectedCareer: Career?

    @State private var currentQuestion = 0
    @State private var isShowingResults = false

    // Estados del formulario
    @State private var selectedInterests: Set<String> = []
    @State private var specialization = ""
    @State private var workEnvironment = ""
    @State private var professionalProfile = 5.0
    @State private var goals = ""

    // MARK: - Lógica Dinámica por Carrera
    
    private var careerName: String {
        selectedCareer?.name.lowercased() ?? ""
    }

    private var currentInterests: [String] {
        if careerName.contains("informática") {
            return ["IA & ML", "Ciberseguridad", "Desarrollo Móvil", "Cloud Computing", "Blockchain", "Videojuegos", "Data Science", "UX/UI", "DevOps"]
        } else if careerName.contains("administración") {
            return ["Recursos Humanos", "Marketing Digital", "Consultoría", "Operaciones", "Emprendimiento", "Liderazgo", "Sustentabilidad", "Gestión Pública"]
        } else if careerName.contains("negocios") {
            return ["Logística Global", "Tratados Comerciales", "E-commerce Int.", "Aduanas", "Finanzas Internacionales", "Diplomacia", "Mercados Asiáticos"]
        } else if careerName.contains("contaduría") {
            return ["Auditoría", "Impuestos (Fiscal)", "Finanzas Corporativas", "Costos", "Forense", "Normas Internacionales", "Consultoría Fiscal"]
        }
        return ["Investigación", "Docencia", "Emprendimiento", "Sector Público", "Sector Privado"]
    }

    private var currentSpecializations: [String] {
        if careerName.contains("informática") {
            return ["Ingeniería de Software", "Arquitectura de Datos", "Ethical Hacking", "Product Management Tech"]
        } else if careerName.contains("administración") {
            return ["Dirección Estratégica", "Gestión de Talento", "Supply Chain", "Desarrollo Organizacional"]
        } else if careerName.contains("negocios") {
            return ["Relaciones Internacionales", "Inversión Extranjera", "Global Supply Chain", "Marketing Global"]
        } else if careerName.contains("contaduría") {
            return ["Contabilidad Gubernamental", "Finanzas de Riesgo", "Dictaminación", "Planeación Financiera"]
        }
        return ["Alta Dirección", "Especialidad Técnica", "Investigación Académica"]
    }

    private let environments = ["Remoto (Home Office)", "Híbrido", "Oficina Corporativa", "Campo / Planta", "Nómada Digital"]

    // MATERIAS SUGERIDAS (HARDCODED POR CARRERA)
    private var suggestedSubjects: [String] {
        if careerName.contains("informática") {
            return ["Inteligencia Artificial", "Redes Neuronales Artificiales", "Desarrollo de Apps Móviles"]
        } else if careerName.contains("administración") {
            return ["Dirección Estratégica", "Marketing Digital", "Gestión de Proyectos"]
        } else if careerName.contains("negocios") {
            return ["Logística Internacional", "Tratados Comerciales", "Finanzas Globales"]
        } else if careerName.contains("contaduría") {
            return ["Auditoría Forense", "Impuestos Corporativos", "Finanzas Internacionales"]
        }
        return ["Liderazgo Profesional", "Ética en los Negocios"]
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if !isShowingResults {
                    // --- FLUJO DE PREGUNTAS ---
                    headerView
                    ScrollView {
                        VStack(alignment: .leading, spacing: 30) {
                            switch currentQuestion {
                            case 0: interestsStep
                            case 1: specializationStep
                            case 2: environmentStep
                            case 3: profileStep
                            default: goalsStep
                            }
                        }
                        .padding()
                    }
                    navigationFooter
                } else {
                    // --- PANTALLA DE FEEDBACK / RESULTADOS ---
                    resultsFeedbackView
                }
            }
            .background(Color(.systemGroupedBackground))
        }
    }

    // MARK: - Subviews

    private var headerView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Perfil Profesional")
                        .font(.title3).fontWeight(.bold)
                    Text("Pregunta \(currentQuestion + 1) de 5")
                        .font(.caption).foregroundStyle(.secondary)
                }
                Spacer()
                Button { appViewModel.dismissQuestionnaire() } label: {
                    Image(systemName: "xmark.circle.fill").font(.title2).foregroundStyle(.secondary)
                }
            }
            ProgressView(value: Double(currentQuestion + 1), total: 5.0)
                .tint(.blue)
        }
        .padding()
        .background(Color.white)
    }

    private var navigationFooter: some View {
        HStack(spacing: 12) {
            if currentQuestion > 0 {
                Button("Atrás") { withAnimation { currentQuestion -= 1 } }
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(14)
            }

            Button {
                // Acción del botón
                if currentQuestion == 4 {
                    withAnimation { isShowingResults = true }
                } else {
                    withAnimation { currentQuestion += 1 }
                }
            } label: {
                // Diseño del botón (Todo esto ahora es interactivo)
                Text(currentQuestion == 4 ? "Ver Resultados" : "Siguiente")
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity) // Ocupa todo el ancho
                    .padding(.vertical, 16)    // Define la altura táctil
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(14)
            }
        }
        .padding()
        .background(Color.white)
    }

    private var resultsFeedbackView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "sparkles")
                .font(.system(size: 60))
                .foregroundStyle(.blue)
                .shadow(color: .blue.opacity(0.3), radius: 10)

            VStack(spacing: 8) {
                Text("¡Test Completado!")
                    .font(.title).fontWeight(.bold)
                Text("Basado en tus respuestas, estas materias serán clave para tu perfil en \(selectedCareer?.name ?? "tu carrera"):")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 32)
            }

            VStack(spacing: 12) {
                ForEach(suggestedSubjects, id: \.self) { subject in
                    HStack {
                        Image(systemName: "book.fill").foregroundStyle(.blue)
                        Text(subject).fontWeight(.medium)
                        Spacer()
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.05), radius: 5)
                }
            }
            .padding(.horizontal)

            Spacer()

            Button("Finalizar y Guardar") {
                saveAndFinish()
            }
            .fontWeight(.medium)
            .foregroundStyle(.primary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(14)
        }
    }

    // MARK: - Pasos del Formulario (Se mantienen igual)

    private var interestsStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            questionHeader(title: "¿Qué áreas de \(selectedCareer?.name ?? "tu carrera") te apasionan?", subtitle: "Selecciona todas las que apliquen")
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 140))], spacing: 12) {
                ForEach(currentInterests, id: \.self) { item in
                    SelectableTag(title: item, isSelected: selectedInterests.contains(item)) {
                        if selectedInterests.contains(item) { selectedInterests.remove(item) }
                        else { selectedInterests.insert(item) }
                    }
                }
            }
        }
    }

    private var specializationStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            questionHeader(title: "¿Hacia dónde quieres inclinarte?", subtitle: "Elige el camino que más te atraiga")
            ForEach(currentSpecializations, id: \.self) { spec in
                SelectionCard(title: spec, isSelected: specialization == spec) {
                    specialization = spec
                }
            }
        }
    }

    private var environmentStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            questionHeader(title: "¿Cuál es tu ambiente de trabajo ideal?", subtitle: "Esto nos ayuda a sugerirte empresas")
            ForEach(environments, id: \.self) { env in
                SelectionCard(title: env, isSelected: workEnvironment == env) {
                    workEnvironment = env
                }
            }
        }
    }

    private var profileStep: some View {
        VStack(alignment: .leading, spacing: 24) {
            questionHeader(title: "Define tu enfoque profesional", subtitle: "Mueve el slider para indicar tu preferencia")
            VStack(spacing: 12) {
                HStack {
                    Text("Técnico").font(.caption).fontWeight(.bold)
                    Spacer()
                    Text("Administrativo").font(.caption).fontWeight(.bold)
                }
                .foregroundStyle(.blue)
                Slider(value: $professionalProfile, in: 0...10, step: 1)
                Text(profileDescription).font(.subheadline).italic().frame(maxWidth: .infinity, alignment: .center)
            }
            .padding().background(Color.white).cornerRadius(12)
        }
    }

    private var goalsStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            questionHeader(title: "¿Cuál es tu meta a corto plazo?", subtitle: "Cuéntanos tus planes al graduarte")
            ZStack(alignment: .topLeading) {
                TextEditor(text: $goals).frame(minHeight: 180).padding(12).background(Color.white).cornerRadius(12)
                if goals.isEmpty {
                    Text(goalPlaceholder).font(.subheadline).foregroundStyle(.tertiary).padding(.horizontal, 16).padding(.vertical, 20).allowsHitTesting(false)
                }
            }
        }
    }

    // MARK: - Helpers & Finalización

    private var profileDescription: String {
        if professionalProfile < 4 { return "Prefiero la especialización técnica y operativa." }
        if professionalProfile > 6 { return "Me interesa más la dirección y la estrategia." }
        return "Busco un equilibrio entre lo técnico y lo administrativo."
    }

    private var goalPlaceholder: String {
        if careerName.contains("info") { return "p. ej. Ser Senior Developer en una FAANG..." }
        return "p. ej. Emprender mi propio despacho o consultoría..."
    }

    private func questionHeader(title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title).font(.title2).fontWeight(.bold).foregroundStyle(.primary)
            Text(subtitle).font(.subheadline).foregroundStyle(.secondary)
        }
    }

    private func saveAndFinish() {
        let finalAnswers = QuestionnaireAnswers(
            interests: Array(selectedInterests),
            specialization: specialization,
            workEnvironment: workEnvironment,
            professionalProfile: professionalProfile,
            goals: goals,
            suggestedSubjects: suggestedSubjects // <--- GUARDADO GLOBAL
        )
        appViewModel.saveQuestionnaireAnswers(finalAnswers)
    }
}


// MARK: - Componentes de Soporte

struct SelectableTag: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption).fontWeight(.medium)
                .padding(.vertical, 10).padding(.horizontal, 12)
                .frame(maxWidth: .infinity)
                .background(isSelected ? Color.blue : Color.white)
                .foregroundStyle(isSelected ? .white : .primary)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(isSelected ? .blue : .gray.opacity(0.3)))
        }
    }
}

struct SelectionCard: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title).font(.subheadline).fontWeight(.medium).foregroundStyle(.primary)
                Spacer()
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(isSelected ? .blue : .gray)
            }
            .padding()
            .background(isSelected ? Color.blue.opacity(0.05) : Color.white)
            .cornerRadius(12)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(isSelected ? .blue : .gray.opacity(0.1)))
        }
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding().background(Color.blue).foregroundStyle(.white).cornerRadius(14).fontWeight(.semibold)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding().background(Color.gray.opacity(0.1)).foregroundStyle(.secondary).cornerRadius(14)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
    }
}
