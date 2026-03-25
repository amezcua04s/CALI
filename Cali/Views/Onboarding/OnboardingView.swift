import SwiftUI

// MARK: - OnboardingView
// Multi-step wizard: Welcome → Datos personales → Carrera → Semestre

struct OnboardingView: View {
    @EnvironmentObject var appViewModel: AppViewModel

    @State private var step = 0
    @State private var showCareerPicker = false

    // Form state
    @State private var name = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var selectedCareer: Career?
    @State private var currentSemester = 1

    private let totalSteps = 4

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.blue.opacity(0.07), Color.white],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Progress bar (hidden on welcome screen)
                if step > 0 {
                    ProgressView(value: Double(step), total: Double(totalSteps - 1))
                        .tint(.blue)
                        .padding(.horizontal, 24)
                        .padding(.top, 20)
                }

                // Step content
                TabView(selection: $step) {
                    WelcomeStep().tag(0)
                    PersonalDataStep(name: $name, lastName: $lastName, email: $email).tag(1)
                    CareerStep(selectedCareer: $selectedCareer, showPicker: $showCareerPicker).tag(2)
                    SemesterStep(semester: $currentSemester, career: selectedCareer).tag(3)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.3), value: step)

                // Navigation buttons
                HStack(spacing: 12) {
                    if step > 0 {
                        Button("Atrás") { withAnimation { step -= 1 } }
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(14)
                    }

                    Button(step == totalSteps - 1 ? "¡Empezar!" : "Continuar") {
                        if step == totalSteps - 1 { finishOnboarding() }
                        else { withAnimation { step += 1 } }
                    }
                    .disabled(!canContinue)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(canContinue ? Color.blue : Color.gray.opacity(0.3))
                    .foregroundStyle(.white)
                    .cornerRadius(14)
                    .fontWeight(.semibold)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .sheet(isPresented: $showCareerPicker) {
            CareerPickerSheet(selectedCareer: $selectedCareer)
        }
    }

    // MARK: Validation
    private var canContinue: Bool {
        switch step {
        case 0:  return true
        case 1:  return !name.trimmingCharacters(in: .whitespaces).isEmpty &&
                        !lastName.trimmingCharacters(in: .whitespaces).isEmpty
        case 2:  return selectedCareer != nil
        case 3:  return true
        default: return false
        }
    }

    private func finishOnboarding() {
        appViewModel.userProfile.name            = name.trimmingCharacters(in: .whitespaces)
        appViewModel.userProfile.lastName        = lastName.trimmingCharacters(in: .whitespaces)
        appViewModel.userProfile.email           = email.trimmingCharacters(in: .whitespaces)
        appViewModel.userProfile.career          = selectedCareer
        appViewModel.userProfile.currentSemester = currentSemester
        appViewModel.completeOnboarding()
    }
}

// MARK: - Step 0 – Welcome

struct WelcomeStep: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 36) {
                Spacer(minLength: 32)

                // Logo
                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: [.blue, .purple],
                                            startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 120, height: 120)
                        .shadow(color: .blue.opacity(0.4), radius: 24, x: 0, y: 12)
                    Text("C")
                        .font(.system(size: 62, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                }

                VStack(spacing: 8) {
                    Text("Hola, soy CALI")
                        .font(.largeTitle).fontWeight(.bold)
                    Text("Tu Carrera, tu Aliado, tu Cálido compañero académico en la UNAM")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }

                VStack(spacing: 12) {
                    FeatureRow(icon: "brain.head.profile", color: .blue,
                               title: "IA Companion",
                               description: "Te orientaré en tu carrera con inteligencia artificial")
                    FeatureRow(icon: "checkmark.circle.fill", color: .green,
                               title: "Checklist de Titulación",
                               description: "Sigue tu avance hacia el título paso a paso")
                    FeatureRow(icon: "calendar.badge.plus", color: .orange,
                               title: "Horario Inteligente",
                               description: "Arma tu semestre con las materias disponibles")
                }
                .padding(.horizontal, 24)

                Spacer(minLength: 24)
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let color: Color
    let title: String
    let description: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
                .frame(width: 46, height: 46)
                .background(color.opacity(0.12))
                .cornerRadius(12)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline).fontWeight(.semibold)
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(14)
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)
    }
}

// MARK: - Step 1 – Personal Data

struct PersonalDataStep: View {
    @Binding var name: String
    @Binding var lastName: String
    @Binding var email: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Cuéntame sobre ti")
                        .font(.largeTitle).fontWeight(.bold)
                    Text("Tu nombre personaliza toda la experiencia")
                        .foregroundStyle(.secondary)
                }

                VStack(spacing: 16) {
                    CALITextField(title: "Nombre(s)", placeholder: "p. ej. Ana Sofía",
                                  text: $name, icon: "person")
                    CALITextField(title: "Apellidos", placeholder: "p. ej. Ramírez Torres",
                                  text: $lastName, icon: "person.fill")
                    CALITextField(title: "Correo UNAM (opcional)",
                                  placeholder: "usuario@comunidad.unam.mx",
                                  text: $email, icon: "envelope",
                                  keyboardType: .emailAddress)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 32)
        }
    }
}

// MARK: - Step 2 – Career

struct CareerStep: View {
    @Binding var selectedCareer: Career?
    @Binding var showPicker: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 28) {
            VStack(alignment: .leading, spacing: 6) {
                Text("¿Qué estudias?")
                    .font(.largeTitle).fontWeight(.bold)
                Text("Elige tu carrera para personalizar tu checklist y materias")
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 24)
            .padding(.top, 32)

            if let career = selectedCareer {
                CareerCard(career: career) { showPicker = true }
                    .padding(.horizontal, 24)
            } else {
                Button { showPicker = true } label: {
                    HStack {
                        Image(systemName: "books.vertical")
                            .font(.title3)
                        Text("Seleccionar carrera")
                            .fontWeight(.semibold)
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .foregroundStyle(.blue)
                    .padding()
                    .background(Color.blue.opacity(0.08))
                    .cornerRadius(14)
                }
                .padding(.horizontal, 24)
            }

            Spacer()
        }
    }
}

// MARK: - Step 3 – Semester

struct SemesterStep: View {
    @Binding var semester: Int
    let career: Career?

    var maxSemesters: Int { career?.durationSemesters ?? 12 }

    var body: some View {
        VStack(alignment: .leading, spacing: 28) {
            VStack(alignment: .leading, spacing: 6) {
                Text("¿En qué semestre vas?")
                    .font(.largeTitle).fontWeight(.bold)
                Text("Selecciona tu semestre actual")
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 24)
            .padding(.top, 32)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
                ForEach(1...maxSemesters, id: \.self) { sem in
                    Button { semester = sem } label: {
                        Text("\(sem)°")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(semester == sem ? Color.blue : Color.gray.opacity(0.1))
                            .foregroundStyle(semester == sem ? Color.white : Color.primary)
                            .cornerRadius(12)
                    }
                }
            }
            .padding(.horizontal, 24)

            Spacer()
        }
    }
}

// MARK: - Career Card (reused in onboarding + profile)

struct CareerCard: View {
    let career: Career
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                Text(career.name)
                    .font(.title3).fontWeight(.bold)
                    .foregroundStyle(Color.primary)
                Text(career.faculty)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Divider()

                HStack {
                    StatPill(value: "\(career.durationSemesters) sem.", color: .blue)
                    StatPill(value: "\(career.totalCredits) créditos", color: .purple)
                    Spacer()
                    Image(systemName: "chevron.right.circle")
                        .foregroundStyle(.blue.opacity(0.6))
                        .font(.title3)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.07), radius: 10, x: 0, y: 5)
        }
    }
}

struct StatPill: View {
    let value: String
    let color: Color

    var body: some View {
        Text(value)
            .font(.caption).fontWeight(.medium)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(color.opacity(0.12))
            .foregroundStyle(color)
            .cornerRadius(20)
    }
}

// MARK: - Career Picker Sheet

struct CareerPickerSheet: View {
    @Binding var selectedCareer: Career?
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""

    var filtered: [Career] {
        searchText.isEmpty ? Career.unamCareers
            : Career.unamCareers.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.faculty.localizedCaseInsensitiveContains(searchText)
            }
    }

    var body: some View {
        NavigationStack {
            List(filtered) { career in
                CareerListRow(career: career, isSelected: selectedCareer?.id == career.id) {
                    selectedCareer = career
                    dismiss()
                }
            }
            .searchable(text: $searchText, prompt: "Buscar carrera o facultad…")
            .navigationTitle("Carreras UNAM")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
            }
        }
    }
}

struct CareerListRow: View {
    let career: Career
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(career.name)
                        .font(.headline)
                        .foregroundStyle(Color.primary)
                    Text(career.faculty)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    HStack(spacing: 10) {
                        Label("\(career.durationSemesters) semestres", systemImage: "calendar")
                            .font(.caption).foregroundStyle(.blue)
                        Label("\(career.totalCredits) créditos", systemImage: "star")
                            .font(.caption).foregroundStyle(.purple)
                    }
                }
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.blue)
                }
            }
        }
    }
}

// MARK: - Shared TextField component

struct CALITextField: View {
    let title: String
    var placeholder: String = ""
    @Binding var text: String
    let icon: String
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption).fontWeight(.medium)
                .foregroundStyle(.secondary)
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(.blue)
                    .frame(width: 22)
                TextField(placeholder.isEmpty ? title : placeholder, text: $text)
                    .keyboardType(keyboardType)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(keyboardType == .emailAddress ? .never : .words)
            }
            .padding()
            .background(Color.gray.opacity(0.08))
            .cornerRadius(12)
        }
    }
}
