import Foundation

// MARK: - DataService
// Simulates the API call to fetch available subjects (materias).
// Replace `fetchSubjects(for:)` with a real URLSession call when the API is ready.

class DataService {
    static let shared = DataService()
    private init() {}

    // MARK: - Public API (mock)

    func getSubjects(for careerName: String) -> [Subject] {
        switch careerName {
        case "Ingeniería en Computación",
             "Ciencias de la Computación":
            return computacionSubjects
        case "Administración",
             "Contaduría":
            return administracionSubjects
        default:
            return genericSubjects
        }
    }

    // When a real API exists, call this instead:
    // func fetchSubjects(for careerName: String) async throws -> [Subject] { ... }

    // MARK: - Mock datasets

    private var computacionSubjects: [Subject] = [
        Subject(name: "Cálculo Diferencial e Integral",
                clave: "1101", credits: 10, semester: 1,
                professor: "Dr. García Morales",
                scheduleSlots: [
                    ScheduleSlot(day: .lunes,     startHour: 8,  endHour: 10),
                    ScheduleSlot(day: .miercoles, startHour: 8,  endHour: 10),
                    ScheduleSlot(day: .viernes,   startHour: 8,  endHour: 9)
                ], classroom: "P-102"),

        Subject(name: "Álgebra Lineal",
                clave: "1102", credits: 10, semester: 1,
                professor: "Dra. López Hernández",
                scheduleSlots: [
                    ScheduleSlot(day: .martes, startHour: 10, endHour: 12),
                    ScheduleSlot(day: .jueves, startHour: 10, endHour: 12)
                ], classroom: "P-201"),

        Subject(name: "Introducción a Ciencias de la Computación",
                clave: "1103", credits: 8, semester: 1,
                professor: "M.C. Varela Ríos",
                scheduleSlots: [
                    ScheduleSlot(day: .lunes,  startHour: 12, endHour: 14),
                    ScheduleSlot(day: .viernes, startHour: 10, endHour: 12)
                ], classroom: "Lab. A"),

        Subject(name: "Programación Orientada a Objetos",
                clave: "1201", credits: 8, semester: 2,
                professor: "M.C. Rodríguez Pérez",
                scheduleSlots: [
                    ScheduleSlot(day: .lunes,     startHour: 12, endHour: 14),
                    ScheduleSlot(day: .miercoles, startHour: 12, endHour: 14)
                ], classroom: "Lab. A"),

        Subject(name: "Estructuras de Datos y Algoritmos",
                clave: "1202", credits: 10, semester: 2,
                professor: "Dr. Martínez Cruz",
                scheduleSlots: [
                    ScheduleSlot(day: .martes,  startHour: 14, endHour: 16),
                    ScheduleSlot(day: .jueves,  startHour: 14, endHour: 16),
                    ScheduleSlot(day: .viernes, startHour: 12, endHour: 13)
                ], classroom: "E-305"),

        Subject(name: "Matemáticas Discretas",
                clave: "1203", credits: 8, semester: 2,
                professor: "Dra. Soto Alvarado",
                scheduleSlots: [
                    ScheduleSlot(day: .martes,    startHour: 8,  endHour: 10),
                    ScheduleSlot(day: .miercoles, startHour: 10, endHour: 12)
                ], classroom: "P-104"),

        Subject(name: "Sistemas Operativos",
                clave: "1401", credits: 10, semester: 4,
                professor: "Dr. Sánchez Vega",
                scheduleSlots: [
                    ScheduleSlot(day: .lunes,     startHour: 16, endHour: 18),
                    ScheduleSlot(day: .miercoles, startHour: 16, endHour: 18)
                ], classroom: "E-102"),

        Subject(name: "Redes de Computadoras",
                clave: "1501", credits: 10, semester: 5,
                professor: "M.I. Flores Torres",
                scheduleSlots: [
                    ScheduleSlot(day: .martes, startHour: 8,  endHour: 10),
                    ScheduleSlot(day: .jueves, startHour: 8,  endHour: 10)
                ], classroom: "Lab. B"),

        Subject(name: "Inteligencia Artificial",
                clave: "1601", credits: 8, semester: 6,
                professor: "Dr. Ramírez Luna",
                scheduleSlots: [
                    ScheduleSlot(day: .lunes,   startHour: 10, endHour: 12),
                    ScheduleSlot(day: .viernes, startHour: 10, endHour: 12)
                ], classroom: "P-305"),

        Subject(name: "Bases de Datos",
                clave: "1602", credits: 10, semester: 6,
                professor: "Dra. Jiménez Campos",
                scheduleSlots: [
                    ScheduleSlot(day: .martes, startHour: 12, endHour: 14),
                    ScheduleSlot(day: .jueves, startHour: 12, endHour: 14)
                ], classroom: "Lab. C"),

        Subject(name: "Ingeniería de Software",
                clave: "1701", credits: 10, semester: 7,
                professor: "M.C. Vargas Mendoza",
                scheduleSlots: [
                    ScheduleSlot(day: .lunes,     startHour: 18, endHour: 20),
                    ScheduleSlot(day: .miercoles, startHour: 18, endHour: 20)
                ], classroom: "E-201", modality: .hibrido),

        Subject(name: "Seguridad en Sistemas",
                clave: "1702", credits: 8, semester: 7,
                professor: "Dr. Guerrero Ríos",
                scheduleSlots: [
                    ScheduleSlot(day: .martes,  startHour: 16, endHour: 18),
                    ScheduleSlot(day: .viernes, startHour: 14, endHour: 16)
                ], classroom: "Lab. Seg"),

        Subject(name: "Aprendizaje Automático",
                clave: "1801", credits: 8, semester: 8,
                professor: "Dra. Castro Niño",
                scheduleSlots: [
                    ScheduleSlot(day: .lunes,     startHour: 14, endHour: 16),
                    ScheduleSlot(day: .miercoles, startHour: 14, endHour: 16)
                ], classroom: "Lab. IA", modality: .hibrido),

        Subject(name: "Cómputo en la Nube",
                clave: "1802", credits: 6, semester: 8,
                professor: "M.C. Peña Solís",
                scheduleSlots: [
                    ScheduleSlot(day: .jueves, startHour: 16, endHour: 19)
                ], classroom: "Lab. B", modality: .linea)
    ]

    private var administracionSubjects: [Subject] = [
        Subject(name: "Fundamentos de Administración",
                clave: "A101", credits: 8, semester: 1,
                professor: "Dra. Torres Medina",
                scheduleSlots: [
                    ScheduleSlot(day: .lunes,  startHour: 9,  endHour: 11),
                    ScheduleSlot(day: .jueves, startHour: 9,  endHour: 11)
                ], classroom: "AU-201"),

        Subject(name: "Contabilidad Básica",
                clave: "A102", credits: 8, semester: 1,
                professor: "M.A. Ruiz Gómez",
                scheduleSlots: [
                    ScheduleSlot(day: .martes,  startHour: 11, endHour: 13),
                    ScheduleSlot(day: .viernes, startHour: 9,  endHour: 11)
                ], classroom: "AU-105"),

        Subject(name: "Mercadotecnia",
                clave: "A301", credits: 8, semester: 3,
                professor: "Lic. Villanueva Cruz",
                scheduleSlots: [
                    ScheduleSlot(day: .miercoles, startHour: 13, endHour: 15),
                    ScheduleSlot(day: .viernes,   startHour: 11, endHour: 13)
                ], classroom: "AU-302")
    ]

    private var genericSubjects: [Subject] = [
        Subject(name: "Introducción a la Carrera",
                clave: "GEN01", credits: 6, semester: 1,
                professor: "Por asignar",
                scheduleSlots: [
                    ScheduleSlot(day: .lunes, startHour: 10, endHour: 12)
                ], classroom: "Aula 1"),

        Subject(name: "Metodología de la Investigación",
                clave: "GEN02", credits: 8, semester: 2,
                professor: "Dr. Hernández Suárez",
                scheduleSlots: [
                    ScheduleSlot(day: .martes, startHour: 10, endHour: 12),
                    ScheduleSlot(day: .jueves, startHour: 10, endHour: 12)
                ], classroom: "Aula 2")
    ]
}
