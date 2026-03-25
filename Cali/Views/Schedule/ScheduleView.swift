import SwiftUI

// MARK: - ScheduleView
// Lets the user build their semester schedule from the available subject catalogue.

struct ScheduleView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @Environment(\.dismiss) var dismiss

    @State private var showCatalog = false
    @State private var viewMode: ViewMode = .list

    enum ViewMode: String, CaseIterable {
        case list    = "Lista"
        case weekly  = "Semanal"
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("Vista", selection: $viewMode) {
                    ForEach(ViewMode.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                }
                .pickerStyle(.segmented)
                .padding()

                Group {
                    if viewMode == .list { listView }
                    else { weeklyView }
                }
            }
            .navigationTitle("Mi Horario")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Listo") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { showCatalog = true } label: {
                        Image(systemName: "plus.circle.fill").font(.title3)
                    }
                }
            }
        }
        .sheet(isPresented: $showCatalog) { SubjectCatalogView() }
    }

    // MARK: - List view

    @ViewBuilder
    private var listView: some View {
        if appViewModel.selectedSubjects.isEmpty {
            emptyState
        } else {
            List {
                ForEach(appViewModel.selectedSubjects) { subject in
                    SubjectRow(subject: subject)
                }
                .onDelete { idx in
                    appViewModel.selectedSubjects.remove(atOffsets: idx)
                    appViewModel.saveSubjects()
                }

                Section {
                    HStack {
                        Text("Total de créditos")
                            .fontWeight(.semibold)
                        Spacer()
                        Text("\(appViewModel.selectedSubjects.reduce(0) { $0 + $1.credits })")
                            .fontWeight(.bold).foregroundStyle(.blue)
                    }
                }
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "calendar.badge.plus")
                .font(.system(size: 56))
                .foregroundStyle(.blue.opacity(0.45))
            Text("Sin materias registradas")
                .font(.title3).fontWeight(.semibold)
            Text("Toca + para explorar el catálogo y armar tu semestre")
                .font(.subheadline).foregroundStyle(.secondary)
                .multilineTextAlignment(.center).padding(.horizontal, 40)
            Button("Explorar catálogo") { showCatalog = true }
                .buttonStyle(.borderedProminent).cornerRadius(12)
            Spacer()
        }
    }

    // MARK: - Weekly grid view

    private var weeklyView: some View {
        let days = Array(ScheduleSlot.WeekDay.allCases.prefix(5))
        let hours = 7...21

        return ScrollView([.horizontal, .vertical]) {
            VStack(spacing: 0) {
                // Day headers
                HStack(spacing: 0) {
                    Color.clear.frame(width: 44, height: 28)
                    ForEach(days, id: \.self) { day in
                        Text(day.shortName)
                            .font(.caption).fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.horizontal, 4)

                // Hourly rows
                ForEach(hours, id: \.self) { hour in
                    HStack(spacing: 0) {
                        Text(String(format: "%02d:00", hour))
                            .font(.caption2).foregroundStyle(.secondary)
                            .frame(width: 44)

                        ForEach(days, id: \.self) { day in
                            let hits = subjectsAt(hour: hour, day: day)
                            ZStack {
                                Rectangle()
                                    .stroke(Color.gray.opacity(0.08), lineWidth: 0.5)
                                    .frame(height: 52)
                                if let first = hits.first {
                                    Text(first.name)
                                        .font(.system(size: 9, weight: .medium))
                                        .lineLimit(2)
                                        .multilineTextAlignment(.center)
                                        .padding(3)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .background(colorFor(first).opacity(0.22))
                                        .foregroundStyle(colorFor(first))
                                        .cornerRadius(4)
                                        .padding(1)
                                }
                            }
                            .frame(minWidth: 60,maxWidth: .infinity)
                        }
                    }
                    .frame(height: 52)
                }
            }
            .padding(.horizontal, 4)
        }
    }

    private func subjectsAt(hour: Int, day: ScheduleSlot.WeekDay) -> [Subject] {
        appViewModel.selectedSubjects.filter { s in
            s.scheduleSlots.contains { $0.day == day && $0.startHour <= hour && $0.endHour > hour }
        }
    }

    private func colorFor(_ subject: Subject) -> Color {
        let palette: [Color] = [.blue, .purple, .orange, .green, .pink, .teal, .indigo]
        let idx = abs(subject.name.hashValue) % palette.count
        return palette[idx]
    }
}

// MARK: - Subject Row (list item)

struct SubjectRow: View {
    let subject: Subject

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(subject.name).font(.headline)
                Spacer()
                Label(subject.modality.rawValue, systemImage: subject.modality.icon)
                    .font(.caption2).foregroundStyle(.secondary)
            }

            HStack {
                Text(subject.professor)
                    .font(.caption).foregroundStyle(.secondary)
                Spacer()
                Text("\(subject.credits) créditos")
                    .font(.caption).fontWeight(.medium)
                    .padding(.horizontal, 8).padding(.vertical, 3)
                    .background(Color.blue.opacity(0.1))
                    .foregroundStyle(.blue).cornerRadius(6)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    ForEach(subject.scheduleSlots) { slot in
                        Text("\(slot.day.shortName) \(slot.timeDisplay)")
                            .font(.caption2)
                            .padding(.horizontal, 7).padding(.vertical, 3)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(6)
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Subject Catalog Sheet

struct SubjectCatalogView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @Environment(\.dismiss) var dismiss

    @State private var searchText = ""
    @State private var selectedSemester: Int? = nil

    private var allSubjects: [Subject] {
        DataService.shared.getSubjects(for: appViewModel.userProfile.career?.name ?? "")
    }

    private var filtered: [Subject] {
        var list = allSubjects
        if let sem = selectedSemester { list = list.filter { $0.semester == sem } }
        if !searchText.isEmpty {
            list = list.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.professor.localizedCaseInsensitiveContains(searchText) ||
                $0.clave.localizedCaseInsensitiveContains(searchText)
            }
        }
        return list
    }

    private func isSelected(_ subject: Subject) -> Bool {
        appViewModel.selectedSubjects.contains { $0.id == subject.id }
    }

    private func toggle(_ subject: Subject) {
        if let idx = appViewModel.selectedSubjects.firstIndex(where: { $0.id == subject.id }) {
            appViewModel.selectedSubjects.remove(at: idx)
        } else {
            appViewModel.selectedSubjects.append(subject)
        }
        appViewModel.saveSubjects()
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Semester filter chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        FilterChip(title: "Todos", isSelected: selectedSemester == nil) {
                            selectedSemester = nil
                        }
                        ForEach(1...9, id: \.self) { sem in
                            FilterChip(title: "Sem. \(sem)",
                                       isSelected: selectedSemester == sem) {
                                selectedSemester = sem
                            }
                        }
                    }
                    .padding(.horizontal).padding(.vertical, 10)
                }
                .background(Color.white)

                List(filtered) { subject in
                    CatalogSubjectRow(subject: subject,
                                      isSelected: isSelected(subject)) {
                        toggle(subject)
                    }
                }
                .searchable(text: $searchText, prompt: "Buscar materia, profesor o clave…")
            }
            .navigationTitle("Catálogo de Materias")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Listo") { dismiss() }.fontWeight(.semibold)
                }
            }
        }
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .padding(.horizontal, 14).padding(.vertical, 7)
                .background(isSelected ? Color.blue : Color.gray.opacity(0.12))
                .foregroundStyle(isSelected ? Color.white : Color.primary)
                .cornerRadius(20)
        }
    }
}

struct CatalogSubjectRow: View {
    let subject: Subject
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text(subject.name)
                            .font(.headline).foregroundStyle(Color.primary)
                        Text("Sem. \(subject.semester)")
                            .font(.caption2)
                            .padding(.horizontal, 5).padding(.vertical, 2)
                            .background(Color.purple.opacity(0.1))
                            .foregroundStyle(.purple).cornerRadius(5)
                    }
                    Text(subject.professor)
                        .font(.subheadline).foregroundStyle(.secondary)
                    HStack(spacing: 8) {
                        ForEach(subject.scheduleSlots) { slot in
                            Text("\(slot.day.shortName) \(slot.timeDisplay)")
                                .font(.caption2).foregroundStyle(.blue)
                        }
                        Text("Clave: \(subject.clave)")
                            .font(.caption2).foregroundStyle(.secondary)
                    }
                    Label(subject.modality.rawValue, systemImage: subject.modality.icon)
                        .font(.caption2).foregroundStyle(.secondary)
                }
                Spacer()
                VStack(spacing: 4) {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "plus.circle")
                        .font(.title2)
                        .foregroundStyle(isSelected ? Color.blue : Color.gray)
                    Text("\(subject.credits) cr.")
                        .font(.caption2).foregroundStyle(.secondary)
                }
            }
        }
    }
}
