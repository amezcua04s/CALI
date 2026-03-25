import Foundation

// MARK: - Subject (Materia)

struct Subject: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let clave: String
    let credits: Int
    let semester: Int
    let spots : Int
    let professor: String
    let scheduleSlots: [ScheduleSlot]
    let classroom: String
    let modality: SubjectModality

    init(
        id: UUID = UUID(),
        name: String,
        clave: String,
        credits: Int,
        semester: Int,
        spots: Int,
        professor: String,
        scheduleSlots: [ScheduleSlot],
        classroom: String,
        modality: SubjectModality = .presencial
    ) {
        self.id = id
        self.name = name
        self.clave = clave
        self.credits = credits
        self.semester = semester
        self.spots = spots
        self.professor = professor
        self.scheduleSlots = scheduleSlots
        self.classroom = classroom
        self.modality = modality
    }

    enum SubjectModality: String, Codable {
        case presencial = "Presencial"
        case linea      = "En Línea"
        case hibrido    = "Híbrido"

        var icon: String {
            switch self {
            case .presencial: return "building.columns"
            case .linea:      return "wifi"
            case .hibrido:    return "arrow.triangle.2.circlepath"
            }
        }
    }
}

// MARK: - ScheduleSlot

struct ScheduleSlot: Codable, Hashable, Identifiable {
    let id: UUID
    let day: WeekDay
    let startHour: Int
    let startMinute: Int
    let endHour: Int
    let endMinute: Int

    init(
        id: UUID = UUID(),
        day: WeekDay,
        startHour: Int,
        startMinute: Int = 0,
        endHour: Int,
        endMinute: Int = 0
    ) {
        self.id = id
        self.day = day
        self.startHour = startHour
        self.startMinute = startMinute
        self.endHour = endHour
        self.endMinute = endMinute
    }

    var timeDisplay: String {
        String(format: "%02d:%02d–%02d:%02d", startHour, startMinute, endHour, endMinute)
    }

    // MARK: - WeekDay

    enum WeekDay: String, Codable, CaseIterable {
        case lunes     = "Lunes"
        case martes    = "Martes"
        case miercoles = "Miércoles"
        case jueves    = "Jueves"
        case viernes   = "Viernes"
        case sabado    = "Sábado"

        var shortName: String {
            switch self {
            case .lunes:     return "L"
            case .martes:    return "M"
            case .miercoles: return "Mi"
            case .jueves:    return "J"
            case .viernes:   return "V"
            case .sabado:    return "S"
            }
        }
    }
}
