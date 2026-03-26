import SwiftUI

// MARK: - ChecklistView

struct ChecklistView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @Environment(\.dismiss) var dismiss

    private var obligatorioItems: [ChecklistItem] {
        appViewModel.checklistItems.filter { $0.section == .obligatoria }
    }
    private var modalidadItems: [ChecklistItem] {
        appViewModel.checklistItems.filter { $0.section == .modalidad }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {

                    // ── Tarjeta de progreso ───────────────────────────────
                    ChecklistProgressCard(
                        percentage: appViewModel.completionPercentage,
                        items: appViewModel.checklistItems
                    )
                    .padding(.horizontal)

                    // ── SECCIÓN 1: Requisitos Obligatorios ────────────────
                    ChecklistSectionBlock(
                        title: "Requisitos Obligatorios",
                        icon: "list.bullet.clipboard",
                        items: obligatorioItems
                    )
                    .padding(.horizontal)

                    // ── SECCIÓN 2: Modalidad de Titulación ────────────────
                    VStack(alignment: .leading, spacing: 14) {

                        // Encabezado
                        HStack {
                            Image(systemName: "graduationcap")
                                .foregroundStyle(.blue)
                            Text("Modalidad de Titulación")
                                .font(.headline)
                            Spacer()
                            if !modalidadItems.isEmpty {
                                Text("\(modalidadItems.filter { $0.isCompleted }.count)/\(modalidadItems.count)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }

                        // Picker horizontal de opciones
                        GraduationOptionPicker()

                        // Configuración dinámica (fecha / revisiones / lugar)
                        if appViewModel.selectedGraduationOption != nil {
                            ModalidadConfigSection()
                        }

                        // Items de la modalidad elegida
                        if !modalidadItems.isEmpty {
                            VStack(spacing: 8) {
                                ForEach(modalidadItems) { item in
                                    ChecklistItemRow(item: item)
                                }
                            }
                        } else if appViewModel.selectedGraduationOption == nil {
                            Text("Selecciona una modalidad para ver tus pasos")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity)
                                .multilineTextAlignment(.center)
                                .padding(.vertical, 18)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Checklist de Titulación")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Listo") { dismiss() }
                        .fontWeight(.semibold)
                }
            }
        }
    }
}

// MARK: - Sección Block (reutilizable)

struct ChecklistSectionBlock: View {
    @EnvironmentObject var appViewModel: AppViewModel
    let title: String
    let icon: String
    let items: [ChecklistItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(.blue)
                Text(title)
                    .font(.headline)
                Spacer()
                Text("\(items.filter { $0.isCompleted }.count)/\(items.count)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            VStack(spacing: 8) {
                ForEach(items) { item in
                    ChecklistItemRow(item: item)
                }
            }
        }
    }
}

// MARK: - Picker horizontal de modalidad

struct GraduationOptionPicker: View {
    @EnvironmentObject var appViewModel: AppViewModel

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(ChecklistItem.GraduationOption.allCases, id: \.self) { opt in
                    let isSelected = appViewModel.selectedGraduationOption == opt

                    Button {
                        withAnimation(.spring(duration: 0.28)) {
                            // Tocar la opción activa la deselecciona
                            appViewModel.selectedGraduationOption = isSelected ? nil : opt
                        }
                    } label: {
                        VStack(spacing: 6) {
                            Image(systemName: opt.icon)
                                .font(.title3)
                            Text(opt.rawValue)
                                .font(.caption)
                                .fontWeight(.medium)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                        }
                        .frame(width: 96)
                        .padding(.vertical, 12)
                        .background(isSelected ? Color.blue : Color.white)
                        .foregroundStyle(isSelected ? Color.white : Color.primary)
                        .cornerRadius(14)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(
                                    isSelected ? Color.blue : Color.gray.opacity(0.2),
                                    lineWidth: 1
                                )
                        )
                        .shadow(color: isSelected ? Color.blue.opacity(0.2) : .clear,
                                radius: 4, x: 0, y: 2)
                    }
                }
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 2)
        }
    }
}

// MARK: - Config dinámica de la modalidad

struct ModalidadConfigSection: View {
    @EnvironmentObject var appViewModel: AppViewModel

    var body: some View {
        if let opt = appViewModel.selectedGraduationOption {
            VStack(alignment: .leading, spacing: 12) {
                switch opt {
                    
                case .tesis:
                    RevisionStepper(
                        label: "Número de revisiones de tesina",
                        value: $appViewModel.revisionCount
                    )
                    
                case .examenConocimientos:
                    DateInputField(
                        label: "Fecha límite de inscripción",
                        placeholder: "ej. 15 de abril de 2026",
                        text: $appViewModel.fechaInscripcion
                    )
                    
                case .diplomado:
                    // Agrupamos para mantener el espaciado interno
                    VStack(alignment: .leading, spacing: 12) {
                        DateInputField(
                            label: "Fecha límite de inscripción",
                            placeholder: "ej. 10 de mayo de 2026",
                            text: $appViewModel.fechaInscripcion
                        )
                        PlaceInputField(text: $appViewModel.diplomadoLugar)
                    }
                    
                case .promedio:
                    Label(
                        "Asegúrate de tener promedio ≥ 9.5 y ser alumno regular.",
                        systemImage: "info.circle"
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true) // Evita que el texto se corte
                    
                case .proyecto:
                    RevisionStepper(
                        label: "Número de revisiones del proyecto",
                        value: $appViewModel.revisionCount
                    )
                }
                
                // El Spacer hace que el contenido se pegue arriba y la caja mantenga su tamaño
                Spacer(minLength: 0)
            }
            .padding(14)
            .frame(maxWidth: .infinity)
            // Ajusta este valor (130) según qué tan alto sea tu componente DateInputField + PlaceInputField
            .frame(height: 140, alignment: .topLeading)
            .background(Color.blue.opacity(0.05))
            .cornerRadius(14)
        }    }
}

// MARK: - Sub-componentes de config

private struct RevisionStepper: View {
    let label: String
    @Binding var value: Int

    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
            HStack(spacing: 14) {
                Button {
                    if value > 1 { value -= 1 }
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.title2)
                        .foregroundStyle(value > 1 ? Color.blue : Color.gray.opacity(0.4))
                }
                .disabled(value <= 1)

                Text("\(value)")
                    .font(.headline)
                    .frame(width: 28)

                Button {
                    if value < 10 { value += 1 }
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundStyle(value < 10 ? Color.blue : Color.gray.opacity(0.4))
                }
                .disabled(value >= 10)
            }
        }
    }
}

private struct DateInputField: View {
    let label: String
    let placeholder: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
            TextField(placeholder, text: $text)
                .textFieldStyle(.roundedBorder)
                .submitLabel(.done)
        }
    }
}

private struct PlaceInputField: View {
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Lugar de entrega de papeles")
                .font(.caption)
                .foregroundStyle(.secondary)
            TextField("ej. Sala de Titulación, Edificio A", text: $text)
                .textFieldStyle(.roundedBorder)
                .submitLabel(.done)
        }
    }
}

// MARK: - Progress Card

struct ChecklistProgressCard: View {
    let percentage: Double
    let items: [ChecklistItem]

    private var completedRequired: Int { items.filter { $0.isCompleted && $0.requiredForGraduation }.count }
    private var totalRequired: Int     { items.filter { $0.requiredForGraduation }.count }

    var body: some View {
        VStack(spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Tu progreso").font(.headline)
                    Text("\(completedRequired) de \(totalRequired) pasos completados")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()

                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.18), lineWidth: 7)
                    Circle()
                        .trim(from: 0, to: percentage / 100)
                        .stroke(Color.blue, style: StrokeStyle(lineWidth: 7, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .animation(.spring(duration: 0.6), value: percentage)
                    Text("\(Int(percentage))%")
                        .font(.headline).fontWeight(.bold)
                }
                .frame(width: 66, height: 66)
            }

            if percentage == 100 {
                Label("¡Listo para titularte! 🎓", systemImage: "checkmark.seal.fill")
                    .font(.subheadline).fontWeight(.semibold)
                    .foregroundStyle(.green)
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 3)
    }
}

// MARK: - Item Row

struct ChecklistItemRow: View {
    @EnvironmentObject var appViewModel: AppViewModel
    let item: ChecklistItem

    var body: some View {
        Button { appViewModel.toggleChecklistItem(item) } label: {
            HStack(alignment: .top, spacing: 14) {
                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(item.isCompleted ? Color.green : Color.gray)
                    .padding(.top, 1)

                VStack(alignment: .leading, spacing: 3) {
                    Text(item.title)
                        .font(.subheadline).fontWeight(.medium)
                        .foregroundStyle(Color.primary)
                        .strikethrough(item.isCompleted, color: .secondary)
                        .multilineTextAlignment(.leading)

                    Text(item.description)
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    if let details = item.details {
                        Text(details)
                            .font(.caption2)
                            .foregroundStyle(.blue)
                    }
                }
                Spacer()
            }
            .padding()
            .background(item.isCompleted ? Color.green.opacity(0.05) : Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        item.isCompleted ? Color.green.opacity(0.3) : Color.gray.opacity(0.15),
                        lineWidth: 1
                    )
            )
        }
    }
}
