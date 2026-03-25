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
        case "Administración":
            return administracionSubjects
        case "Contaduría":
            return contaduriaSubjects
        case "Informática":
            return informaticaSubjects
        case "Negocios Internacionales":
            return negociosInternacionalesSubjects
        default:
            return administracionSubjects
        }
    }

    private let contaduriaSubjects: [Subject] = [
        // TRASLAPE 1: Lunes y Miércoles de 9 a 11
        Subject(name: "AUDITORÍA INTERNA", clave: "2825", credits: 8, semester: 8, professor: "CERVANTES SIERRA LUZ DEL CARMEN", spots: 60,
                scheduleSlots: [
                    ScheduleSlot(day: .lunes, startHour: 9, endHour: 11),
                    ScheduleSlot(day: .miercoles, startHour: 9, endHour: 11)
                ], classroom: "D-005"),
        
        Subject(name: "COSTOS ESTRATÉGICOS", clave: "0008", credits: 8, semester: 8, professor: "VASQUEZ COSTA JOSE LUIS", spots: 60,
                scheduleSlots: [
                    ScheduleSlot(day: .lunes, startHour: 9, endHour: 11),
                    ScheduleSlot(day: .miercoles, startHour: 9, endHour: 11)
                ], classroom: "D-102"),

        // TRASLAPE 2: Martes y Jueves de 7 a 9
        Subject(name: "CONTRIBUCIONES INDIRECTAS", clave: "2826", credits: 8, semester: 8, professor: "MANZANARES VELAZQUEZ IGNACIO", spots: 60,
                scheduleSlots: [
                    ScheduleSlot(day: .martes, startHour: 7, endHour: 9),
                    ScheduleSlot(day: .jueves, startHour: 7, endHour: 9)
                ], classroom: "B-001"),

        Subject(name: "AUDITORÍA INTERNA", clave: "2825", credits: 8, semester: 8, professor: "ESPINOSA DE LOS MONTEROS JAIME", spots: 60,
                scheduleSlots: [
                    ScheduleSlot(day: .martes, startHour: 7, endHour: 9),
                    ScheduleSlot(day: .jueves, startHour: 7, endHour: 9)
                ], classroom: "A-204"),

        Subject(name: "FINANZAS CORPORATIVAS", clave: "2827", credits: 8, semester: 8, professor: "ZARATE COLORADO SANTIAGO", spots: 60,
                scheduleSlots: [
                    ScheduleSlot(day: .miercoles, startHour: 11, endHour: 13),
                    ScheduleSlot(day: .viernes, startHour: 11, endHour: 13)
                ], classroom: "AULA-B12"),
        
        Subject(name: "AUDITORÍA INTERNA", clave: "2825", credits: 8, semester: 8, professor: "LOPEZ CHAVEZ GABRIELA", spots: 60,
                scheduleSlots: [
                    ScheduleSlot(day: .lunes, startHour: 11, endHour: 13),
                    ScheduleSlot(day: .miercoles, startHour: 11, endHour: 13)
                ], classroom: "D-101"),

        Subject(name: "COSTOS ESTRATÉGICOS", clave: "0008", credits: 8, semester: 8, professor: "HERNANDEZ MENA HIDEKEL ZURIEL", spots: 60,
                scheduleSlots: [
                    ScheduleSlot(day: .lunes, startHour: 7, endHour: 9),
                    ScheduleSlot(day: .miercoles, startHour: 7, endHour: 9)
                ], classroom: "B-004"),

        Subject(name: "CONTRIBUCIONES INDIRECTAS", clave: "2826", credits: 8, semester: 8, professor: "CANDELAS RAMIREZ EDITH", spots: 60,
                scheduleSlots: [
                    ScheduleSlot(day: .lunes, startHour: 11, endHour: 13),
                    ScheduleSlot(day: .miercoles, startHour: 11, endHour: 13)
                ], classroom: "C-203"),

        Subject(name: "AUDITORÍA INTERNA", clave: "2825", credits: 8, semester: 8, professor: "SANTOS MARTINEZ PATRICIO", spots: 60,
                scheduleSlots: [
                    ScheduleSlot(day: .viernes, startHour: 7, endHour: 9),
                    ScheduleSlot(day: .martes, startHour: 7, endHour: 9)
                ], classroom: "A-205"),

        Subject(name: "AUDITORÍA INTERNA", clave: "2825", credits: 8, semester: 8, professor: "HERNANDEZ ROMERO MARIA", spots: 60,
                scheduleSlots: [
                    ScheduleSlot(day: .jueves, startHour: 9, endHour: 11),
                    ScheduleSlot(day: .sabado, startHour: 9, endHour: 11)
                ], classroom: "AULA-04")
    ]

    private let administracionSubjects: [Subject] = [
        // TRASLAPE 1: Lunes y Miércoles de 9 a 11
        Subject(name: "CRÉDITO Y COBRANZAS", clave: "2080", credits: 8, semester: 8, professor: "WOLF DEL VALLE NORMAN", spots: 60,
                scheduleSlots: [
                    ScheduleSlot(day: .lunes, startHour: 9, endHour: 11),
                    ScheduleSlot(day: .miercoles, startHour: 9, endHour: 11)
                ], classroom: "H-011"),

        Subject(name: "ADMINISTRACIÓN ESTRATÉGICA", clave: "2822", credits: 8, semester: 8, professor: "GUTIERREZ ACOSTA OMAR", spots: 60,
                scheduleSlots: [
                    ScheduleSlot(day: .lunes, startHour: 9, endHour: 11),
                    ScheduleSlot(day: .miercoles, startHour: 9, endHour: 11)
                ], classroom: "AULA-B12"),

        // TRASLAPE 2: Miércoles y Viernes de 11 a 13
        Subject(name: "ADMINISTRACIÓN ESTRATÉGICA", clave: "2822", credits: 8, semester: 8, professor: "FRANKLIN FINCOWSKY ENRIQUE", spots: 60,
                scheduleSlots: [
                    ScheduleSlot(day: .miercoles, startHour: 11, endHour: 13),
                    ScheduleSlot(day: .viernes, startHour: 11, endHour: 13)
                ], classroom: "F-103"),

        Subject(name: "ADMINISTRACIÓN ESTRATÉGICA", clave: "2822", credits: 8, semester: 8, professor: "CISNEROS MONTES SALVADOR", spots: 60,
                scheduleSlots: [
                    ScheduleSlot(day: .viernes, startHour: 11, endHour: 13),
                    ScheduleSlot(day: .miercoles, startHour: 11, endHour: 13)
                ], classroom: "A-201"),

        Subject(name: "ADMINISTRACIÓN ESTRATÉGICA", clave: "2822", credits: 8, semester: 8, professor: "CANDELAS RAMIREZ EDITH", spots: 60,
                scheduleSlots: [
                    ScheduleSlot(day: .martes, startHour: 7, endHour: 9),
                    ScheduleSlot(day: .jueves, startHour: 7, endHour: 9)
                ], classroom: "F-102"),

        Subject(name: "PUBLICIDAD", clave: "2085", credits: 8, semester: 8, professor: "PARDO LOPEZ SONIA LUZ", spots: 60,
                scheduleSlots: [
                    ScheduleSlot(day: .miercoles, startHour: 7, endHour: 9),
                    ScheduleSlot(day: .viernes, startHour: 7, endHour: 9)
                ], classroom: "A-203"),

        Subject(name: "ADMINISTRACIÓN ESTRATÉGICA", clave: "2822", credits: 8, semester: 8, professor: "MERINO YOSHIOKA EDUARDO", spots: 60,
                scheduleSlots: [
                    ScheduleSlot(day: .martes, startHour: 9, endHour: 11),
                    ScheduleSlot(day: .viernes, startHour: 9, endHour: 11)
                ], classroom: "D-202"),

        Subject(name: "ADMINISTRACIÓN ESTRATÉGICA", clave: "2822", credits: 8, semester: 8, professor: "RUIZ DIAZ CARLOS", spots: 60,
                scheduleSlots: [
                    ScheduleSlot(day: .miercoles, startHour: 11, endHour: 13),
                    ScheduleSlot(day: .lunes, startHour: 11, endHour: 13)
                ], classroom: "D-002"),

        Subject(name: "ADMINISTRACIÓN ESTRATÉGICA", clave: "2822", credits: 8, semester: 8, professor: "GARCIA FLORES ESTER", spots: 60,
                scheduleSlots: [
                    ScheduleSlot(day: .jueves, startHour: 9, endHour: 11),
                    ScheduleSlot(day: .lunes, startHour: 9, endHour: 11)
                ], classroom: "F-103"),

        Subject(name: "MARKETING II", clave: "2085", credits: 8, semester: 8, professor: "BARCENA SOBRINO MARIA MARCELA", spots: 60,
                scheduleSlots: [
                    ScheduleSlot(day: .lunes, startHour: 9, endHour: 11),
                    ScheduleSlot(day: .miercoles, startHour: 9, endHour: 11)
                ], classroom: "H-013")
    ]
    
    private let informaticaSubjects: [Subject] = [
        // TRASLAPE 1: Lunes y Miércoles de 9 a 11
        Subject(name: "AUDITORÍA INFORMÁTICA", clave: "2824", credits: 8, semester: 8, professor: "MARTINEZ VENTURA JUAN CARLOS", spots: 30,
                scheduleSlots: [
                    ScheduleSlot(day: .lunes, startHour: 9, endHour: 11),
                    ScheduleSlot(day: .miercoles, startHour: 9, endHour: 11)
                ], classroom: "AULA-B11"),

        Subject(name: "SERVICIOS DE TECNOLOGÍA", clave: "2828", credits: 8, semester: 8, professor: "HERNANDEZ REYES JORGE ARTURO", spots: 30,
                scheduleSlots: [
                    ScheduleSlot(day: .lunes, startHour: 9, endHour: 11),
                    ScheduleSlot(day: .miercoles, startHour: 9, endHour: 11)
                ], classroom: "D-203"),

        // TRASLAPE 2: Martes y Jueves de 18 a 20
        Subject(name: "AUDITORÍA INFORMÁTICA", clave: "2824", credits: 8, semester: 8, professor: "PONCE ROSADO MARCO ANTONIO", spots: 30,
                scheduleSlots: [
                    ScheduleSlot(day: .martes, startHour: 18, endHour: 20),
                    ScheduleSlot(day: .jueves, startHour: 18, endHour: 20)
                ], classroom: "D-204"),

        Subject(name: "SERVICIOS DE TECNOLOGÍA", clave: "2828", credits: 8, semester: 8, professor: "PONCE ROSADO MARCO ANTONIO", spots: 30,
                scheduleSlots: [
                    ScheduleSlot(day: .martes, startHour: 18, endHour: 20),
                    ScheduleSlot(day: .jueves, startHour: 18, endHour: 20)
                ], classroom: "D-204"),

        Subject(name: "AUDITORÍA INFORMÁTICA", clave: "2824", credits: 8, semester: 8, professor: "MARTINEZ MONTESINOS DELIA", spots: 30,
                scheduleSlots: [
                    ScheduleSlot(day: .martes, startHour: 9, endHour: 11),
                    ScheduleSlot(day: .jueves, startHour: 9, endHour: 11)
                ], classroom: "D-107"),

        Subject(name: "AUDITORÍA INFORMÁTICA", clave: "2824", credits: 8, semester: 8, professor: "SOTO PEREZ GABRIEL", spots: 30,
                scheduleSlots: [
                    ScheduleSlot(day: .lunes, startHour: 18, endHour: 20),
                    ScheduleSlot(day: .miercoles, startHour: 18, endHour: 20)
                ], classroom: "D-202"),

        Subject(name: "SERVICIOS DE TECNOLOGÍA", clave: "2828", credits: 8, semester: 8, professor: "GARCIA RUIZ JOSE MANUEL", spots: 30,
                scheduleSlots: [
                    ScheduleSlot(day: .martes, startHour: 7, endHour: 9),
                    ScheduleSlot(day: .jueves, startHour: 7, endHour: 9)
                ], classroom: "D-203"),

        Subject(name: "TEMAS SELECTOS INFO", clave: "2830", credits: 8, semester: 8, professor: "MORALES SANCHEZ ELSA", spots: 30,
                scheduleSlots: [
                    ScheduleSlot(day: .lunes, startHour: 11, endHour: 13),
                    ScheduleSlot(day: .miercoles, startHour: 11, endHour: 13)
                ], classroom: "E-101"),

        Subject(name: "TEMAS SELECTOS INFO", clave: "2830", credits: 8, semester: 8, professor: "RAMIREZ CRUZ FELIPE", spots: 30,
                scheduleSlots: [
                    ScheduleSlot(day: .martes, startHour: 16, endHour: 18),
                    ScheduleSlot(day: .jueves, startHour: 16, endHour: 18)
                ], classroom: "E-102"),

        Subject(name: "AUDITORÍA INFORMÁTICA", clave: "2824", credits: 8, semester: 8, professor: "GARCIA SILVA MARCO", spots: 30,
                scheduleSlots: [
                    ScheduleSlot(day: .lunes, startHour: 7, endHour: 9),
                    ScheduleSlot(day: .miercoles, startHour: 7, endHour: 9)
                ], classroom: "AULA-B11")
    ]
    
    private var negociosInternacionalesSubjects : [Subject] = [
        Subject(name: "Inglés", clave: "1827", credits: 8, semester: 8, professor: "Barcena Sobrino María Marcela", spots: 60,
                scheduleSlots: [
                    ScheduleSlot(day: .lunes, startHour: 7, endHour: 9),
                    ScheduleSlot(day: .miercoles, startHour: 7, endHour: 9)
                ], classroom: "B-003"),
        Subject(name: "Inglés", clave: "1827", credits: 8, semester: 8, professor: "Barcena Sobrino María Marcela", spots: 60,
                scheduleSlots: [
                    ScheduleSlot(day: .lunes, startHour: 7, endHour: 9),
                    ScheduleSlot(day: .miercoles, startHour: 7, endHour: 9)
                ], classroom: "C-205"),
        
        Subject(name: "Seminario Negocios Internacionales V", clave: "1828", credits: 8, semester: 8, professor: "Jouaen Perez Giselle Solagne", spots: 60,
                scheduleSlots: [
                    ScheduleSlot(day: .lunes, startHour: 9, endHour: 11),
                    ScheduleSlot(day: .miercoles, startHour: 9, endHour: 11)
                ], classroom: "B-003"),
        
        Subject(name: "Seminario Negocios Internacionales V", clave: "1828", credits: 8, semester: 8, professor: "Gallardo Lopez Antonio", spots: 60,
                scheduleSlots: [
                    ScheduleSlot(day: .lunes, startHour: 9, endHour: 11),
                    ScheduleSlot(day: .miercoles, startHour: 9, endHour: 11)
                ], classroom: "C-205")
    ]

    
}
