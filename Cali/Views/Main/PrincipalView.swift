import SwiftUI

// MARK: - PrincipalView
// Main screen. Shows greeting, titulación progress, and quick-action cards.

struct PrincipalView: View {
    @EnvironmentObject var appViewModel: AppViewModel

    @State private var showChat      = false
    @State private var showChecklist = false
    @State private var showSchedule  = false

    // MARK: Greeting
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12: return "¡Buenos días"
        case 12..<19: return "¡Buenas tardes"
        default:     return "¡Buenas noches"
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    // ── Header ─────────────────────────────────────
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(greeting), \(appViewModel.userProfile.name)! 👋")
                            .font(.title2).fontWeight(.bold)
                        if let career = appViewModel.userProfile.career {
                            Text("\(career.name) · \(appViewModel.userProfile.currentSemester)° semestre")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.horizontal)

                    // ── Progress card ──────────────────────────────
                    TitulacionProgressCard(percentage: appViewModel.completionPercentage)
                        .padding(.horizontal)
                        .onTapGesture { showChecklist = true }

                    // ── Quick actions ──────────────────────────────
                    VStack(alignment: .leading, spacing: 12) {
                        Text("¿Qué necesitas hoy?")
                            .font(.headline)
                            .padding(.horizontal)

                        LazyVGrid(
                            columns: [GridItem(.flexible()), GridItem(.flexible())],
                            spacing: 14
                        ) {
                            ActionCard(icon: "bubble.left.and.bubble.right.fill",
                                       title: "CALI IA",
                                       subtitle: "Hazme una pregunta",
                                       color: .blue) { showChat = true }

                            ActionCard(icon: "checkmark.seal.fill",
                                       title: "Titulación",
                                       subtitle: "\(Int(appViewModel.completionPercentage))% completado",
                                       color: .green) { showChecklist = true }

                            ActionCard(icon: "calendar.badge.plus",
                                       title: "Mi Horario",
                                       subtitle: "\(appViewModel.selectedSubjects.count) materias registradas",
                                       color: .orange) { showSchedule = true }

                            ActionCard(icon: "books.vertical.fill",
                                       title: "Catálogo",
                                       subtitle: "Explorar materias",
                                       color: .purple) { showSchedule = true }
                        }
                        .padding(.horizontal)
                    }

                    // ── CALI tip ───────────────────────────────────
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Consejo de CALI")
                            .font(.headline)
                            .padding(.horizontal)
                        CALITipCard()
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("CALI")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $showChat)      { ChatView() }
        .sheet(isPresented: $showChecklist) { ChecklistView() }
        .sheet(isPresented: $showSchedule)  { ScheduleView() }
    }
}

// MARK: - Titulación Progress Card

struct TitulacionProgressCard: View {
    let percentage: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Progreso de Titulación")
                        .font(.subheadline).fontWeight(.semibold)
                    Text("Toca para ver tu checklist completo")
                        .font(.caption).foregroundStyle(.secondary)
                }
                Spacer()
                Text("\(Int(percentage))%")
                    .font(.title2).fontWeight(.bold)
                    .foregroundStyle(.blue)
            }
            ProgressView(value: percentage / 100)
                .tint(.blue)
                .scaleEffect(x: 1, y: 1.6, anchor: .center)
        }
        .padding()
        .background(Color.blue.opacity(0.08))
        .cornerRadius(16)
    }
}

// MARK: - Action Card

struct ActionCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 10) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(color)
                    .padding(10)
                    .background(color.opacity(0.12))
                    .cornerRadius(10)

                Spacer(minLength: 4)

                Text(title)
                    .font(.subheadline).fontWeight(.semibold)
                    .foregroundStyle(Color.primary)
                    .lineLimit(1)

                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        }
    }
}

// MARK: - CALI Tip Card

struct CALITipCard: View {
    private let tips: [(String, String, Color)] = [
        ("lightbulb.fill",
         "Revisa tu historial académico regularmente para detectar materias pendientes a tiempo.",
         .yellow),
        ("hands.and.sparkles",
         "El servicio social puede iniciarse cuando alcances el 50% de tus créditos.",
         .green),
        ("globe",
         "Puedes liberar el idioma con TOEFL, Cambridge u otros exámenes reconocidos por la UNAM.",
         .blue),
        ("calendar",
         "Planifica tu horario del semestre con anticipación para evitar traslapes.",
         .orange),
        ("doc.text",
         "Solicita tu constancia de no adeudo a biblioteca antes de iniciar trámites de titulación.",
         .purple)
    ]

    @State private var tipIndex = Int.random(in: 0..<5)

    var tip: (String, String, Color) { tips[tipIndex] }

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: tip.0)
                .font(.title2)
                .foregroundStyle(tip.2)
                .padding(12)
                .background(tip.2.opacity(0.12))
                .cornerRadius(12)

            Text(tip.1)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
        .onTapGesture {
            withAnimation(.easeInOut) {
                tipIndex = (tipIndex + 1) % tips.count
            }
        }
    }
}
