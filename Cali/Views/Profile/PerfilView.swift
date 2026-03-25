import SwiftUI

// MARK: - PerfilView
// Shows all user-provided data: name, career card, stats, and questionnaire results.

struct PerfilView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @State private var showEditProfile = false
    @State private var showChecklist   = false
    @State private var showResetAlert  = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {

                    // ── Avatar + name ───────────────────────────
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(colors: [.blue, .purple],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing))
                                .frame(width: 90, height: 90)
                                .shadow(color: .blue.opacity(0.35), radius: 14, x: 0, y: 6)
                            Text(initials)
                                .font(.system(size: 34, weight: .bold))
                                .foregroundStyle(.white)
                        }
                        VStack(spacing: 3) {
                            Text("\(appViewModel.userProfile.name) \(appViewModel.userProfile.lastName)")
                                .font(.title2).fontWeight(.bold)
                            if !appViewModel.userProfile.email.isEmpty {
                                Text(appViewModel.userProfile.email)
                                    .font(.subheadline).foregroundStyle(.secondary)
                            }
                        }
                    }
                    .padding(.top, 8)

                    // ── Career card ─────────────────────────────
                    if let career = appViewModel.userProfile.career {
                        CareerInfoCard(career: career,
                                       semester: appViewModel.userProfile.currentSemester)
                            .padding(.horizontal)
                    }

                    // ── Quick stats ─────────────────────────────
                    HStack(spacing: 12) {
                        ProfileStat(value: "\(appViewModel.userProfile.currentSemester)°",
                                    label: "Semestre", icon: "calendar", color: .blue)
                        ProfileStat(value: "\(Int(appViewModel.completionPercentage))%",
                                    label: "Titulación", icon: "chart.bar.fill", color: .green)
                        ProfileStat(value: "\(appViewModel.selectedSubjects.count)",
                                    label: "Materias", icon: "books.vertical", color: .orange)
                    }
                    .padding(.horizontal)

                    // ── Questionnaire results ───────────────────
                    if let answers = appViewModel.userProfile.questionnaireAnswers,
                       !answers.specialization.isEmpty || !answers.interests.isEmpty {
                        QuestionnaireResultCard(answers: answers)
                            .padding(.horizontal)
                    }

                    // ── Options menu ────────────────────────────
                    VStack(spacing: 0) {
                        ProfileMenuRow(icon: "square.and.pencil", color: .blue,
                                       title: "Editar perfil") {
                            showEditProfile = true
                        }
                        Divider().padding(.leading, 52)
                        ProfileMenuRow(icon: "graduationcap.fill", color: .purple,
                                       title: "Ver checklist de titulación") {
                            showChecklist = true
                        }
                        Divider().padding(.leading, 52)
                        ProfileMenuRow(icon: "arrow.counterclockwise", color: .red,
                                       title: "Reiniciar app") {
                            showResetAlert = true
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)
                    .padding(.horizontal)
                }
                .padding(.bottom, 32)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Mi Perfil")
        }
        .sheet(isPresented: $showEditProfile) { EditProfileView() }
        .sheet(isPresented: $showChecklist)   { ChecklistView() }
        .alert("¿Reiniciar app?",
               isPresented: $showResetAlert) {
            Button("Cancelar", role: .cancel) {}
            Button("Reiniciar", role: .destructive) { appViewModel.resetApp() }
        } message: {
            Text("Se borrarán todos tus datos y comenzará el onboarding de nuevo.")
        }
    }

    private var initials: String {
        let f = appViewModel.userProfile.name.first.map(String.init) ?? ""
        let l = appViewModel.userProfile.lastName.first.map(String.init) ?? ""
        return (f + l).uppercased()
    }
}

// MARK: - Career Info Card

struct CareerInfoCard: View {
    let career: Career
    let semester: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(career.name)
                .font(.title3).fontWeight(.bold)
            Text(career.faculty)
                .font(.subheadline).foregroundStyle(.secondary)
            Divider()
            HStack {
                LabeledValue(label: "Duración",
                             value: "\(career.durationSemesters) sem.", color: .blue)
                Spacer()
                LabeledValue(label: "Créditos",
                             value: "\(career.totalCredits) pts.", color: .purple)
                Spacer()
                LabeledValue(label: "Semestre actual",
                             value: "\(semester)°", color: .green)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
    }
}

struct LabeledValue: View {
    let label: String
    let value: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(.caption).foregroundStyle(.secondary)
            Text(value)
                .font(.subheadline).fontWeight(.semibold)
                .foregroundStyle(color)
        }
    }
}

// MARK: - Profile Stat

struct ProfileStat: View {
    let value: String
    let label: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon).font(.title3).foregroundStyle(color)
            Text(value).font(.title2).fontWeight(.bold)
            Text(label).font(.caption).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Questionnaire Result Card

struct QuestionnaireResultCard: View {
    let answers: QuestionnaireAnswers

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "sparkles").foregroundStyle(.yellow)
                Text("Orientación Vocacional").font(.headline)
            }

            if !answers.specialization.isEmpty &&
               answers.specialization != "No lo he decidido aún" {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Especialización de interés")
                        .font(.caption).foregroundStyle(.secondary)
                    Text(answers.specialization)
                        .font(.subheadline)
                }
            }

            if !answers.interests.isEmpty {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Áreas de interés")
                        .font(.caption).foregroundStyle(.secondary)
                    WrapTagsView(tags: answers.interests)
                }
            }

            if !answers.goals.isEmpty {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Meta al titularse")
                        .font(.caption).foregroundStyle(.secondary)
                    Text(answers.goals)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.yellow.opacity(0.06))
        .overlay(RoundedRectangle(cornerRadius: 16)
            .stroke(Color.yellow.opacity(0.3), lineWidth: 1))
        .cornerRadius(16)
    }
}

struct WrapTagsView: View {
    let tags: [String]

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))],
                  alignment: .leading, spacing: 6) {
            ForEach(tags, id: \.self) { tag in
                Text(tag)
                    .font(.caption)
                    .padding(.horizontal, 10).padding(.vertical, 5)
                    .background(Color.blue.opacity(0.1))
                    .foregroundStyle(.blue)
                    .cornerRadius(8)
            }
        }
    }
}

// MARK: - Profile Menu Row

struct ProfileMenuRow: View {
    let icon: String
    let color: Color
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .foregroundStyle(color)
                    .frame(width: 30)
                Text(title).foregroundStyle(Color.primary)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal)
            .padding(.vertical, 15)
        }
    }
}

// MARK: - Edit Profile View

struct EditProfileView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @Environment(\.dismiss) var dismiss

    @State private var name     = ""
    @State private var lastName = ""
    @State private var email    = ""
    @State private var semester = 1
    @State private var showCareerPicker = false
    @State private var selectedCareer: Career?

    var body: some View {
        NavigationStack {
            Form {
                Section("Datos personales") {
                    HStack {
                        Image(systemName: "person").foregroundStyle(.blue).frame(width: 24)
                        TextField("Nombre(s)", text: $name)
                    }
                    HStack {
                        Image(systemName: "person.fill").foregroundStyle(.blue).frame(width: 24)
                        TextField("Apellidos", text: $lastName)
                    }
                    HStack {
                        Image(systemName: "envelope").foregroundStyle(.blue).frame(width: 24)
                        TextField("Correo UNAM", text: $email)
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled()
                    }
                }

                Section("Académico") {
                    Button {
                        showCareerPicker = true
                    } label: {
                        HStack {
                            Image(systemName: "books.vertical").foregroundStyle(.blue).frame(width: 24)
                            Text(selectedCareer?.name ?? "Cambiar carrera")
                                .foregroundStyle(selectedCareer != nil ? Color.primary : .secondary)
                            Spacer()
                            Image(systemName: "chevron.right").font(.caption).foregroundStyle(.secondary)
                        }
                    }

                    Stepper("Semestre: \(semester)°", value: $semester, in: 1...12)
                }
            }
            .navigationTitle("Editar Perfil")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") { save() }.fontWeight(.semibold)
                }
            }
        }
        .sheet(isPresented: $showCareerPicker) {
            CareerPickerSheet(selectedCareer: $selectedCareer)
        }
        .onAppear {
            name           = appViewModel.userProfile.name
            lastName       = appViewModel.userProfile.lastName
            email          = appViewModel.userProfile.email
            semester       = appViewModel.userProfile.currentSemester
            selectedCareer = appViewModel.userProfile.career
        }
    }

    private func save() {
        appViewModel.userProfile.name            = name.trimmingCharacters(in: .whitespaces)
        appViewModel.userProfile.lastName        = lastName.trimmingCharacters(in: .whitespaces)
        appViewModel.userProfile.email           = email.trimmingCharacters(in: .whitespaces)
        appViewModel.userProfile.currentSemester = semester
        if let career = selectedCareer {
            appViewModel.userProfile.career = career
        }
        appViewModel.saveProfile()
        dismiss()
    }
}
