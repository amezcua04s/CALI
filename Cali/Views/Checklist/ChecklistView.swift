import SwiftUI

// MARK: - ChecklistView
// Smart checklist for UNAM graduation requirements.

struct ChecklistView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @Environment(\.dismiss) var dismiss

    private var grouped: [ChecklistItem.ChecklistCategory: [ChecklistItem]] {
        Dictionary(grouping: appViewModel.checklistItems, by: { $0.category })
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Progress overview
                    ChecklistProgressCard(
                        percentage: appViewModel.completionPercentage,
                        items: appViewModel.checklistItems
                    )
                    .padding(.horizontal)

                    // Category sections
                    ForEach(ChecklistItem.ChecklistCategory.allCases, id: \.self) { cat in
                        if let items = grouped[cat], !items.isEmpty {
                            ChecklistCategorySection(category: cat, items: items)
                                .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Checklist de Titulación")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Listo") { dismiss() }.fontWeight(.semibold)
                }
            }
        }
    }
}

// MARK: - Progress Overview Card

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
                    Text("\(completedRequired) de \(totalRequired) requisitos obligatorios")
                        .font(.subheadline).foregroundStyle(.secondary)
                }
                Spacer()
                // Circular progress
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.18), lineWidth: 7)
                    Circle()
                        .trim(from: 0, to: percentage / 100)
                        .stroke(Color.blue,
                                style: StrokeStyle(lineWidth: 7, lineCap: .round))
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

// MARK: - Category Section

struct ChecklistCategorySection: View {
    @EnvironmentObject var appViewModel: AppViewModel
    let category: ChecklistItem.ChecklistCategory
    let items: [ChecklistItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: category.icon)
                    .foregroundStyle(.blue)
                Text(category.rawValue).font(.headline)
                Spacer()
                Text("\(items.filter { $0.isCompleted }.count)/\(items.count)")
                    .font(.caption).foregroundStyle(.secondary)
            }

            VStack(spacing: 8) {
                ForEach(items) { item in
                    ChecklistItemRow(item: item)
                }
            }
        }
    }
}

// MARK: - Checklist Item Row

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
                    HStack(spacing: 6) {
                        Text(item.title)
                            .font(.subheadline).fontWeight(.medium)
                            .foregroundStyle(Color.primary)
                            .strikethrough(item.isCompleted, color: .secondary)

                        if !item.requiredForGraduation {
                            Text("Opcional")
                                .font(.caption2)
                                .padding(.horizontal, 6).padding(.vertical, 2)
                                .background(Color.orange.opacity(0.14))
                                .foregroundStyle(.orange)
                                .cornerRadius(6)
                        }
                    }

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
