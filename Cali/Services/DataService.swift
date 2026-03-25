import Foundation

// MARK: - DataService
// Datos reales FCA UNAM – Periodo 2026-2, 8vo Semestre, Plan 2023 (Negocios: Plan 2018)

class DataService {
    static let shared = DataService()
    private init() {}

    // MARK: - Public API

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

    // MARK: - ADMINISTRACIÓN  (claves 2822 y 2823, cupo 60)

    private let administracionSubjects: [Subject] = [

        // ── CLAVE 2822 · ADMINISTRACIÓN ESTRATÉGICA ──────────────────────────

        Subject(name: "Administración Estratégica", clave: "2822", credits: 10, semester: 8, spots: 60,
                professor: "Candelas Ramirez Edith",
                scheduleSlots: [ScheduleSlot(day: .martes,    startHour: 7,  endHour: 9),
                                ScheduleSlot(day: .jueves,    startHour: 7,  endHour: 9)],
                classroom: "F-102"),

        Subject(name: "Administración Estratégica", clave: "2822", credits: 10, semester: 8, spots: 60,
                professor: "Merino Yoshioka Eduardo Shigueru",
                scheduleSlots: [ScheduleSlot(day: .martes,    startHour: 9,  endHour: 11),
                                ScheduleSlot(day: .viernes,   startHour: 9,  endHour: 11)],
                classroom: "D-202"),

        Subject(name: "Administración Estratégica", clave: "2822", credits: 10, semester: 8, spots: 60,
                professor: "Franklin Fincowsky Enrique Benjamin",
                scheduleSlots: [ScheduleSlot(day: .miercoles, startHour: 11, endHour: 13),
                                ScheduleSlot(day: .viernes,   startHour: 11, endHour: 13)],
                classroom: "F-103"),

        Subject(name: "Administración Estratégica", clave: "2822", credits: 10, semester: 8, spots: 60,
                professor: "Ruiz Diaz Carlos",
                scheduleSlots: [ScheduleSlot(day: .miercoles, startHour: 11, endHour: 13),
                                ScheduleSlot(day: .lunes,     startHour: 11, endHour: 13)],
                classroom: "D-002"),

        Subject(name: "Administración Estratégica", clave: "2822", credits: 10, semester: 8, spots: 60,
                professor: "Garcia Flores Ester",
                scheduleSlots: [ScheduleSlot(day: .jueves,    startHour: 9,  endHour: 11),
                                ScheduleSlot(day: .lunes,     startHour: 9,  endHour: 11)],
                classroom: "F-103"),

        Subject(name: "Administración Estratégica", clave: "2822", credits: 10, semester: 8, spots: 60,
                professor: "Torres Cardenas Alan Aaron",
                scheduleSlots: [ScheduleSlot(day: .martes,    startHour: 13, endHour: 15),
                                ScheduleSlot(day: .jueves,    startHour: 13, endHour: 15)],
                classroom: "D-105"),

        Subject(name: "Administración Estratégica", clave: "2822", credits: 10, semester: 8, spots: 60,
                professor: "Muñoz Lopez Maria Gabriela",
                scheduleSlots: [ScheduleSlot(day: .jueves,    startHour: 7,  endHour: 9),
                                ScheduleSlot(day: .martes,    startHour: 7,  endHour: 9)],
                classroom: "AULA-06"),

        Subject(name: "Administración Estratégica", clave: "2822", credits: 10, semester: 8, spots: 60,
                professor: "Aguilar Iturbe Luz del Carmen",
                scheduleSlots: [ScheduleSlot(day: .lunes,     startHour: 11, endHour: 13),
                                ScheduleSlot(day: .miercoles, startHour: 11, endHour: 13)],
                classroom: "B-207"),

        Subject(name: "Administración Estratégica", clave: "2822", credits: 10, semester: 8, spots: 60,
                professor: "Morales Navarrete Gilberto Jesus",
                scheduleSlots: [ScheduleSlot(day: .jueves,    startHour: 7,  endHour: 9),
                                ScheduleSlot(day: .martes,    startHour: 7,  endHour: 9)],
                classroom: "AULA-B14"),

        Subject(name: "Administración Estratégica", clave: "2822", credits: 10, semester: 8, spots: 60,
                professor: "Gomez Morales Mitzi Jacqueline",
                scheduleSlots: [ScheduleSlot(day: .martes,    startHour: 11, endHour: 13),
                                ScheduleSlot(day: .jueves,    startHour: 11, endHour: 13)],
                classroom: "F-106"),

        Subject(name: "Administración Estratégica", clave: "2822", credits: 10, semester: 8, spots: 60,
                professor: "Lobo Sanchez Carlos",
                scheduleSlots: [ScheduleSlot(day: .lunes,     startHour: 18, endHour: 20),
                                ScheduleSlot(day: .miercoles, startHour: 18, endHour: 20)],
                classroom: "A-003"),

        Subject(name: "Administración Estratégica", clave: "2822", credits: 10, semester: 8, spots: 60,
                professor: "Villalpando Muñoz Fernando Enrique",
                scheduleSlots: [ScheduleSlot(day: .miercoles, startHour: 18, endHour: 20),
                                ScheduleSlot(day: .viernes,   startHour: 18, endHour: 20)],
                classroom: "F-101"),

        Subject(name: "Administración Estratégica", clave: "2822", credits: 10, semester: 8, spots: 60,
                professor: "Leon Lugo Natalia Rubi",
                scheduleSlots: [ScheduleSlot(day: .martes,    startHour: 20, endHour: 22),
                                ScheduleSlot(day: .jueves,    startHour: 20, endHour: 22)],
                classroom: "F-101"),

        Subject(name: "Administración Estratégica", clave: "2822", credits: 10, semester: 8, spots: 60,
                professor: "Velasco Romero Omar Saabel",
                scheduleSlots: [ScheduleSlot(day: .martes,    startHour: 16, endHour: 18),
                                ScheduleSlot(day: .jueves,    startHour: 16, endHour: 18)],
                classroom: "D-204"),

        Subject(name: "Administración Estratégica", clave: "2822", credits: 10, semester: 8, spots: 60,
                professor: "Velazquez Murillo Manuel",
                scheduleSlots: [ScheduleSlot(day: .martes,    startHour: 16, endHour: 18),
                                ScheduleSlot(day: .jueves,    startHour: 16, endHour: 18)],
                classroom: "D-002"),

        Subject(name: "Administración Estratégica", clave: "2822", credits: 10, semester: 8, spots: 60,
                professor: "Aldana Zuani Juan Miguel",
                scheduleSlots: [ScheduleSlot(day: .miercoles, startHour: 20, endHour: 22),
                                ScheduleSlot(day: .lunes,     startHour: 20, endHour: 22)],
                classroom: "A-003"),

        Subject(name: "Administración Estratégica", clave: "2822", credits: 10, semester: 8, spots: 60,
                professor: "Gonzalez Zuñiga Daniel",
                scheduleSlots: [ScheduleSlot(day: .martes,    startHour: 16, endHour: 18),
                                ScheduleSlot(day: .viernes,   startHour: 16, endHour: 18)],
                classroom: "F-107"),

        Subject(name: "Administración Estratégica", clave: "2822", credits: 10, semester: 8, spots: 60,
                professor: "Basilio Galvan Apolinar",
                scheduleSlots: [ScheduleSlot(day: .martes,    startHour: 18, endHour: 20),
                                ScheduleSlot(day: .jueves,    startHour: 18, endHour: 20)],
                classroom: "B-107"),

        Subject(name: "Administración Estratégica", clave: "2822", credits: 10, semester: 8, spots: 60,
                professor: "Macin Cortez Vicente",
                scheduleSlots: [ScheduleSlot(day: .lunes,     startHour: 20, endHour: 22),
                                ScheduleSlot(day: .miercoles, startHour: 20, endHour: 22)],
                classroom: "C-101"),

        // ── CLAVE 2823 · ADMINISTRACIÓN TÁCTICA OPERAC. BIENES ───────────────

        Subject(name: "Administración Táctica Operac. Bienes", clave: "2823", credits: 10, semester: 8, spots: 60,
                professor: "Orduña Trujillo Joaquin",
                scheduleSlots: [ScheduleSlot(day: .martes,    startHour: 11, endHour: 13),
                                ScheduleSlot(day: .jueves,    startHour: 11, endHour: 13)],
                classroom: "AULA-B15"),

        Subject(name: "Administración Táctica Operac. Bienes", clave: "2823", credits: 10, semester: 8, spots: 60,
                professor: "Villegas Tenorio Ivan Josue",
                scheduleSlots: [ScheduleSlot(day: .martes,    startHour: 13, endHour: 15),
                                ScheduleSlot(day: .viernes,   startHour: 13, endHour: 15)],
                classroom: "C-202"),

        Subject(name: "Administración Táctica Operac. Bienes", clave: "2823", credits: 10, semester: 8, spots: 60,
                professor: "Lopez Lopez Maria Laura",
                scheduleSlots: [ScheduleSlot(day: .martes,    startHour: 9,  endHour: 11),
                                ScheduleSlot(day: .jueves,    startHour: 9,  endHour: 11)],
                classroom: "AULA-02"),

        Subject(name: "Administración Táctica Operac. Bienes", clave: "2823", credits: 10, semester: 8, spots: 60,
                professor: "Lopez Lopez Maria Laura",
                scheduleSlots: [ScheduleSlot(day: .viernes,   startHour: 11, endHour: 13),
                                ScheduleSlot(day: .martes,    startHour: 11, endHour: 13)],
                classroom: "B-104"),

        Subject(name: "Administración Táctica Operac. Bienes", clave: "2823", credits: 10, semester: 8, spots: 60,
                professor: "Manzano Peña Luis Enrique",
                scheduleSlots: [ScheduleSlot(day: .viernes,   startHour: 9,  endHour: 11),
                                ScheduleSlot(day: .martes,    startHour: 9,  endHour: 11)],
                classroom: "AULA-02"),

        Subject(name: "Administración Táctica Operac. Bienes", clave: "2823", credits: 10, semester: 8, spots: 60,
                professor: "Ruiz Guzman Jose Joaquin",
                scheduleSlots: [ScheduleSlot(day: .viernes,   startHour: 11, endHour: 13),
                                ScheduleSlot(day: .martes,    startHour: 11, endHour: 13)],
                classroom: "B-201"),

        Subject(name: "Administración Táctica Operac. Bienes", clave: "2823", credits: 10, semester: 8, spots: 60,
                professor: "Villegas Tenorio Ivan Josue",
                scheduleSlots: [ScheduleSlot(day: .lunes,     startHour: 11, endHour: 13),
                                ScheduleSlot(day: .miercoles, startHour: 11, endHour: 13)],
                classroom: "A-103"),

        Subject(name: "Administración Táctica Operac. Bienes", clave: "2823", credits: 10, semester: 8, spots: 60,
                professor: "Carrera Guerrero Flavio Antonio",
                scheduleSlots: [ScheduleSlot(day: .miercoles, startHour: 7,  endHour: 9),
                                ScheduleSlot(day: .lunes,     startHour: 7,  endHour: 9)],
                classroom: "D-205"),

        Subject(name: "Administración Táctica Operac. Bienes", clave: "2823", credits: 10, semester: 8, spots: 60,
                professor: "Gutierrez Acosta Omar Sergio",
                scheduleSlots: [ScheduleSlot(day: .lunes,     startHour: 9,  endHour: 11),
                                ScheduleSlot(day: .miercoles, startHour: 9,  endHour: 11)],
                classroom: "AULA-B12"),

        Subject(name: "Administración Táctica Operac. Bienes", clave: "2823", credits: 10, semester: 8, spots: 60,
                professor: "Cisneros Montes Salvador",
                scheduleSlots: [ScheduleSlot(day: .viernes,   startHour: 11, endHour: 13),
                                ScheduleSlot(day: .miercoles, startHour: 11, endHour: 13)],
                classroom: "A-201"),

        Subject(name: "Administración Táctica Operac. Bienes", clave: "2823", credits: 10, semester: 8, spots: 60,
                professor: "Pereyra Rodriguez Leon Ariel",
                scheduleSlots: [ScheduleSlot(day: .jueves,    startHour: 20, endHour: 22),
                                ScheduleSlot(day: .martes,    startHour: 20, endHour: 22)],
                classroom: "A-004"),

        Subject(name: "Administración Táctica Operac. Bienes", clave: "2823", credits: 10, semester: 8, spots: 60,
                professor: "Orduña Trujillo Joaquin",
                scheduleSlots: [ScheduleSlot(day: .lunes,     startHour: 18, endHour: 20),
                                ScheduleSlot(day: .jueves,    startHour: 18, endHour: 20)],
                classroom: "B-107"),

        Subject(name: "Administración Táctica Operac. Bienes", clave: "2823", credits: 10, semester: 8, spots: 60,
                professor: "Villegas Tenorio Ivan Josue",
                scheduleSlots: [ScheduleSlot(day: .miercoles, startHour: 16, endHour: 18),
                                ScheduleSlot(day: .lunes,     startHour: 16, endHour: 18)],
                classroom: "B-006"),

        Subject(name: "Administración Táctica Operac. Bienes", clave: "2823", credits: 10, semester: 8, spots: 60,
                professor: "Gallardo Lopez Antonio",
                scheduleSlots: [ScheduleSlot(day: .martes,    startHour: 18, endHour: 20),
                                ScheduleSlot(day: .jueves,    startHour: 18, endHour: 20)],
                classroom: "D-102"),

        Subject(name: "Administración Táctica Operac. Bienes", clave: "2823", credits: 10, semester: 8, spots: 60,
                professor: "Pereyra Rodriguez Leon Ariel",
                scheduleSlots: [ScheduleSlot(day: .miercoles, startHour: 20, endHour: 22),
                                ScheduleSlot(day: .lunes,     startHour: 20, endHour: 22)],
                classroom: "A-004"),

        Subject(name: "Administración Táctica Operac. Bienes", clave: "2823", credits: 10, semester: 8, spots: 60,
                professor: "Daniel Delgado Everardo",
                scheduleSlots: [ScheduleSlot(day: .martes,    startHour: 18, endHour: 20),
                                ScheduleSlot(day: .jueves,    startHour: 18, endHour: 20)],
                classroom: "C-101"),

        Subject(name: "Administración Táctica Operac. Bienes", clave: "2823", credits: 10, semester: 8, spots: 60,
                professor: "Garcia Canseco Luis Bulmaro",
                scheduleSlots: [ScheduleSlot(day: .jueves,    startHour: 18, endHour: 20),
                                ScheduleSlot(day: .lunes,     startHour: 18, endHour: 20)],
                classroom: "A-004"),

        Subject(name: "Administración Táctica Operac. Bienes", clave: "2823", credits: 10, semester: 8, spots: 60,
                professor: "Gomez Flores Verdad Pedro",
                scheduleSlots: [ScheduleSlot(day: .jueves,    startHour: 16, endHour: 18),
                                ScheduleSlot(day: .martes,    startHour: 16, endHour: 18)],
                classroom: "AULA-06"),

        Subject(name: "Administración Táctica Operac. Bienes", clave: "2823", credits: 10, semester: 8, spots: 60,
                professor: "Mares Chacon Jesus",
                scheduleSlots: [ScheduleSlot(day: .lunes,     startHour: 18, endHour: 20),
                                ScheduleSlot(day: .miercoles, startHour: 18, endHour: 20)],
                classroom: "D-206"),

        Subject(name: "Administración Táctica Operac. Bienes", clave: "2823", credits: 10, semester: 8, spots: 60,
                professor: "Rojas Marin Armando Carlos",
                scheduleSlots: [ScheduleSlot(day: .lunes,     startHour: 18, endHour: 20),
                                ScheduleSlot(day: .miercoles, startHour: 18, endHour: 20)],
                classroom: "F-107"),
    ]

    // MARK: - CONTADURÍA  (claves 2825, 2826 y 2827, cupo 60)

    private let contaduriaSubjects: [Subject] = [

        // ── CLAVE 2825 · AUDITORÍA INTERNA ───────────────────────────────────

        Subject(name: "Auditoría Interna", clave: "2825", credits: 10, semester: 8, spots: 60,
                professor: "Cervantes Sierra Luz del Carmen",
                scheduleSlots: [ScheduleSlot(day: .miercoles, startHour: 9,  endHour: 11),
                                ScheduleSlot(day: .lunes,     startHour: 9,  endHour: 11)],
                classroom: "D-005"),

        Subject(name: "Auditoría Interna", clave: "2825", credits: 10, semester: 8, spots: 60,
                professor: "Espinosa de los Monteros Cadena Jaime Enrique",
                scheduleSlots: [ScheduleSlot(day: .martes,    startHour: 7,  endHour: 9),
                                ScheduleSlot(day: .jueves,    startHour: 7,  endHour: 9)],
                classroom: "A-204"),

        Subject(name: "Auditoría Interna", clave: "2825", credits: 10, semester: 8, spots: 60,
                professor: "Hernandez Romero Maria del Rocio",
                scheduleSlots: [ScheduleSlot(day: .jueves,    startHour: 9,  endHour: 11),
                                ScheduleSlot(day: .sabado,    startHour: 9,  endHour: 11)],
                classroom: "AULA-04"),

        Subject(name: "Auditoría Interna", clave: "2825", credits: 10, semester: 8, spots: 60,
                professor: "Santos Martinez Patricio",
                scheduleSlots: [ScheduleSlot(day: .viernes,   startHour: 7,  endHour: 9),
                                ScheduleSlot(day: .martes,    startHour: 7,  endHour: 9)],
                classroom: "A-205"),

        Subject(name: "Auditoría Interna", clave: "2825", credits: 10, semester: 8, spots: 60,
                professor: "Gil Marchan Miguel Angel",
                scheduleSlots: [ScheduleSlot(day: .martes,    startHour: 9,  endHour: 11),
                                ScheduleSlot(day: .viernes,   startHour: 9,  endHour: 11)],
                classroom: "B-002"),

        Subject(name: "Auditoría Interna", clave: "2825", credits: 10, semester: 8, spots: 60,
                professor: "Santillan Cruz Ruth",
                scheduleSlots: [ScheduleSlot(day: .sabado,    startHour: 7,  endHour: 9),
                                ScheduleSlot(day: .miercoles, startHour: 7,  endHour: 9)],
                classroom: "A-202"),

        Subject(name: "Auditoría Interna", clave: "2825", credits: 10, semester: 8, spots: 60,
                professor: "Ruiz Gonzalez Enrique",
                scheduleSlots: [ScheduleSlot(day: .miercoles, startHour: 7,  endHour: 9),
                                ScheduleSlot(day: .lunes,     startHour: 7,  endHour: 9)],
                classroom: "D-107"),

        Subject(name: "Auditoría Interna", clave: "2825", credits: 10, semester: 8, spots: 60,
                professor: "Gonzalez Razo Juan de Dios",
                scheduleSlots: [ScheduleSlot(day: .lunes,     startHour: 7,  endHour: 9),
                                ScheduleSlot(day: .miercoles, startHour: 7,  endHour: 9)],
                classroom: "C-104"),

        Subject(name: "Auditoría Interna", clave: "2825", credits: 10, semester: 8, spots: 60,
                professor: "Campos Iturbe Paxy",
                scheduleSlots: [ScheduleSlot(day: .martes,    startHour: 7,  endHour: 9),
                                ScheduleSlot(day: .jueves,    startHour: 7,  endHour: 9)],
                classroom: "AULA-02"),

        Subject(name: "Auditoría Interna", clave: "2825", credits: 10, semester: 8, spots: 60,
                professor: "Huerta Lopez Luis Alberto",
                scheduleSlots: [ScheduleSlot(day: .viernes,   startHour: 7,  endHour: 9),
                                ScheduleSlot(day: .miercoles, startHour: 7,  endHour: 9)],
                classroom: "A-201"),

        Subject(name: "Auditoría Interna", clave: "2825", credits: 10, semester: 8, spots: 60,
                professor: "Segura Leon Nancy Leticia",
                scheduleSlots: [ScheduleSlot(day: .miercoles, startHour: 16, endHour: 18),
                                ScheduleSlot(day: .lunes,     startHour: 16, endHour: 18)],
                classroom: "B-005"),

        Subject(name: "Auditoría Interna", clave: "2825", credits: 10, semester: 8, spots: 60,
                professor: "Sanchez Curiel Gabriel",
                scheduleSlots: [ScheduleSlot(day: .martes,    startHour: 16, endHour: 18),
                                ScheduleSlot(day: .jueves,    startHour: 16, endHour: 18)],
                classroom: "B-003"),

        Subject(name: "Auditoría Interna", clave: "2825", credits: 10, semester: 8, spots: 60,
                professor: "Aguilar Marchand Itzel Elizbet",
                scheduleSlots: [ScheduleSlot(day: .viernes,   startHour: 16, endHour: 18),
                                ScheduleSlot(day: .martes,    startHour: 16, endHour: 18)],
                classroom: "A-003"),

        Subject(name: "Auditoría Interna", clave: "2825", credits: 10, semester: 8, spots: 60,
                professor: "Espinoza Urzua Bernardo Alid",
                scheduleSlots: [ScheduleSlot(day: .martes,    startHour: 18, endHour: 20),
                                ScheduleSlot(day: .viernes,   startHour: 18, endHour: 20)],
                classroom: "B-006"),

        Subject(name: "Auditoría Interna", clave: "2825", credits: 10, semester: 8, spots: 60,
                professor: "Espinoza Urzua Bernardo Alid",
                scheduleSlots: [ScheduleSlot(day: .miercoles, startHour: 16, endHour: 18),
                                ScheduleSlot(day: .lunes,     startHour: 16, endHour: 18)],
                classroom: "A-003"),

        Subject(name: "Auditoría Interna", clave: "2825", credits: 10, semester: 8, spots: 60,
                professor: "Poblano Reyes Luis Fernando",
                scheduleSlots: [ScheduleSlot(day: .viernes,   startHour: 16, endHour: 18),
                                ScheduleSlot(day: .miercoles, startHour: 16, endHour: 18)],
                classroom: "A-004"),

        Subject(name: "Auditoría Interna", clave: "2825", credits: 10, semester: 8, spots: 60,
                professor: "Eslava Garcia Cesar",
                scheduleSlots: [ScheduleSlot(day: .lunes,     startHour: 18, endHour: 20),
                                ScheduleSlot(day: .jueves,    startHour: 18, endHour: 20)],
                classroom: "A-102"),

        Subject(name: "Auditoría Interna", clave: "2825", credits: 10, semester: 8, spots: 60,
                professor: "Valencia Cantoral Luz Maria",
                scheduleSlots: [ScheduleSlot(day: .martes,    startHour: 16, endHour: 18),
                                ScheduleSlot(day: .jueves,    startHour: 16, endHour: 18)],
                classroom: "D-005"),

        Subject(name: "Auditoría Interna", clave: "2825", credits: 10, semester: 8, spots: 60,
                professor: "Hernandez Romero Maria del Rocio",
                scheduleSlots: [ScheduleSlot(day: .viernes,   startHour: 18, endHour: 20),
                                ScheduleSlot(day: .miercoles, startHour: 18, endHour: 20)],
                classroom: "C-203"),

        Subject(name: "Auditoría Interna", clave: "2825", credits: 10, semester: 8, spots: 60,
                professor: "Aguilar Marchand Itzel Elizbet",
                scheduleSlots: [ScheduleSlot(day: .miercoles, startHour: 18, endHour: 20),
                                ScheduleSlot(day: .viernes,   startHour: 18, endHour: 20)],
                classroom: "AULA-04"),

        Subject(name: "Auditoría Interna", clave: "2825", credits: 10, semester: 8, spots: 60,
                professor: "Quezada Garcia Pedro Eduardo",
                scheduleSlots: [ScheduleSlot(day: .lunes,     startHour: 16, endHour: 18),
                                ScheduleSlot(day: .jueves,    startHour: 16, endHour: 18)],
                classroom: "C-203"),

        Subject(name: "Auditoría Interna", clave: "2825", credits: 10, semester: 8, spots: 60,
                professor: "Rios Blanquet Javier Raul",
                scheduleSlots: [ScheduleSlot(day: .martes,    startHour: 16, endHour: 18),
                                ScheduleSlot(day: .viernes,   startHour: 16, endHour: 18)],
                classroom: "AULA-05"),

        // ── CLAVE 2826 · FINANZAS V ───────────────────────────────────────────

        Subject(name: "Finanzas V", clave: "2826", credits: 10, semester: 8, spots: 60,
                professor: "Carrillo Contreras Carlos",
                scheduleSlots: [ScheduleSlot(day: .miercoles, startHour: 7,  endHour: 9),
                                ScheduleSlot(day: .lunes,     startHour: 7,  endHour: 9)],
                classroom: "B-202"),

        Subject(name: "Finanzas V", clave: "2826", credits: 10, semester: 8, spots: 60,
                professor: "Rodriguez Lopez Patricia",
                scheduleSlots: [ScheduleSlot(day: .martes,    startHour: 11, endHour: 13),
                                ScheduleSlot(day: .jueves,    startHour: 11, endHour: 13)],
                classroom: "AULA-04"),

        Subject(name: "Finanzas V", clave: "2826", credits: 10, semester: 8, spots: 60,
                professor: "Velazquez Gomez Gabriela",
                scheduleSlots: [ScheduleSlot(day: .sabado,    startHour: 7,  endHour: 9),
                                ScheduleSlot(day: .jueves,    startHour: 7,  endHour: 9)],
                classroom: "D-206"),

        Subject(name: "Finanzas V", clave: "2826", credits: 10, semester: 8, spots: 60,
                professor: "Herrera Avendaño Carlos Eduardo",
                scheduleSlots: [ScheduleSlot(day: .viernes,   startHour: 11, endHour: 13),
                                ScheduleSlot(day: .martes,    startHour: 11, endHour: 13)],
                classroom: "D-003"),

        Subject(name: "Finanzas V", clave: "2826", credits: 10, semester: 8, spots: 60,
                professor: "Morquecho Ortiz Francisco Alfonso",
                scheduleSlots: [ScheduleSlot(day: .martes,    startHour: 7,  endHour: 9),
                                ScheduleSlot(day: .viernes,   startHour: 7,  endHour: 9)],
                classroom: "C-201"),

        Subject(name: "Finanzas V", clave: "2826", credits: 10, semester: 8, spots: 60,
                professor: "Guzman Villanueva Luis Antonio",
                scheduleSlots: [ScheduleSlot(day: .miercoles, startHour: 9,  endHour: 11),
                                ScheduleSlot(day: .sabado,    startHour: 9,  endHour: 11)],
                classroom: "AULA-07"),

        Subject(name: "Finanzas V", clave: "2826", credits: 10, semester: 8, spots: 60,
                professor: "Castro Casales Francisco",
                scheduleSlots: [ScheduleSlot(day: .lunes,     startHour: 11, endHour: 13),
                                ScheduleSlot(day: .miercoles, startHour: 11, endHour: 13)],
                classroom: "B-202"),

        Subject(name: "Finanzas V", clave: "2826", credits: 10, semester: 8, spots: 60,
                professor: "Silva Haro Jorge Luis",
                scheduleSlots: [ScheduleSlot(day: .lunes,     startHour: 9,  endHour: 11),
                                ScheduleSlot(day: .miercoles, startHour: 9,  endHour: 11)],
                classroom: "D-206"),

        Subject(name: "Finanzas V", clave: "2826", credits: 10, semester: 8, spots: 60,
                professor: "Delgadillo Cano Victor",
                scheduleSlots: [ScheduleSlot(day: .jueves,    startHour: 9,  endHour: 11),
                                ScheduleSlot(day: .martes,    startHour: 9,  endHour: 11)],
                classroom: "AULA-B12"),

        Subject(name: "Finanzas V", clave: "2826", credits: 10, semester: 8, spots: 60,
                professor: "Morquecho Ortiz Francisco Alfonso",
                scheduleSlots: [ScheduleSlot(day: .viernes,   startHour: 9,  endHour: 11),
                                ScheduleSlot(day: .miercoles, startHour: 9,  endHour: 11)],
                classroom: "AULA-09"),

        Subject(name: "Finanzas V", clave: "2826", credits: 10, semester: 8, spots: 60,
                professor: "Carrasco Batalla Octavio",
                scheduleSlots: [ScheduleSlot(day: .miercoles, startHour: 20, endHour: 22),
                                ScheduleSlot(day: .lunes,     startHour: 20, endHour: 22)],
                classroom: "C-003"),

        Subject(name: "Finanzas V", clave: "2826", credits: 10, semester: 8, spots: 60,
                professor: "Foncerrada Lopez Carlos",
                scheduleSlots: [ScheduleSlot(day: .jueves,    startHour: 18, endHour: 20),
                                ScheduleSlot(day: .martes,    startHour: 18, endHour: 20)],
                classroom: "C-101"),

        Subject(name: "Finanzas V", clave: "2826", credits: 10, semester: 8, spots: 60,
                professor: "Villegas Ortiz Alejandro",
                scheduleSlots: [ScheduleSlot(day: .viernes,   startHour: 20, endHour: 22),
                                ScheduleSlot(day: .martes,    startHour: 20, endHour: 22)],
                classroom: "C-003"),

        Subject(name: "Finanzas V", clave: "2826", credits: 10, semester: 8, spots: 60,
                professor: "Conde Peraza Jose Ulises",
                scheduleSlots: [ScheduleSlot(day: .martes,    startHour: 16, endHour: 18),
                                ScheduleSlot(day: .viernes,   startHour: 16, endHour: 18)],
                classroom: "AULA-02"),

        Subject(name: "Finanzas V", clave: "2826", credits: 10, semester: 8, spots: 60,
                professor: "Rodriguez Baltazar Mario Alberto",
                scheduleSlots: [ScheduleSlot(day: .miercoles, startHour: 18, endHour: 20),
                                ScheduleSlot(day: .lunes,     startHour: 18, endHour: 20)],
                classroom: "B-101"),

        Subject(name: "Finanzas V", clave: "2826", credits: 10, semester: 8, spots: 60,
                professor: "Jimenez Gutierrez Gustavo",
                scheduleSlots: [ScheduleSlot(day: .miercoles, startHour: 18, endHour: 20),
                                ScheduleSlot(day: .viernes,   startHour: 18, endHour: 20)],
                classroom: "C-003"),

        Subject(name: "Finanzas V", clave: "2826", credits: 10, semester: 8, spots: 60,
                professor: "Romero Saldaña Ruth Selene",
                scheduleSlots: [ScheduleSlot(day: .lunes,     startHour: 16, endHour: 18),
                                ScheduleSlot(day: .jueves,    startHour: 16, endHour: 18)],
                classroom: "D-207"),

        Subject(name: "Finanzas V", clave: "2826", credits: 10, semester: 8, spots: 60,
                professor: "Guzman Villanueva Luis Antonio",
                scheduleSlots: [ScheduleSlot(day: .martes,    startHour: 18, endHour: 20),
                                ScheduleSlot(day: .jueves,    startHour: 18, endHour: 20)],
                classroom: "B-206"),

        Subject(name: "Finanzas V", clave: "2826", credits: 10, semester: 8, spots: 60,
                professor: "Esteban Hernandez Juan Manuel",
                scheduleSlots: [ScheduleSlot(day: .miercoles, startHour: 16, endHour: 18),
                                ScheduleSlot(day: .viernes,   startHour: 16, endHour: 18)],
                classroom: "C-203"),

        Subject(name: "Finanzas V", clave: "2826", credits: 10, semester: 8, spots: 60,
                professor: "Jimenez Gutierrez Gustavo",
                scheduleSlots: [ScheduleSlot(day: .miercoles, startHour: 16, endHour: 18),
                                ScheduleSlot(day: .viernes,   startHour: 16, endHour: 18)],
                classroom: "D-003"),

        Subject(name: "Finanzas V", clave: "2826", credits: 10, semester: 8, spots: 60,
                professor: "Alcantara Perez Hector Fernando",
                scheduleSlots: [ScheduleSlot(day: .jueves,    startHour: 18, endHour: 20),
                                ScheduleSlot(day: .lunes,     startHour: 18, endHour: 20)],
                classroom: "B-206"),

        Subject(name: "Finanzas V", clave: "2826", credits: 10, semester: 8, spots: 60,
                professor: "Cardenas Bautista Jose Francisco",
                scheduleSlots: [ScheduleSlot(day: .martes,    startHour: 20, endHour: 22),
                                ScheduleSlot(day: .viernes,   startHour: 20, endHour: 22)],
                classroom: "D-102"),

        // ── CLAVE 2827 · PRESUPUESTOS ─────────────────────────────────────────

        Subject(name: "Presupuestos", clave: "2827", credits: 10, semester: 8, spots: 60,
                professor: "Castillejos Alvarado Juan Antonio",
                scheduleSlots: [ScheduleSlot(day: .miercoles, startHour: 11, endHour: 13),
                                ScheduleSlot(day: .lunes,     startHour: 11, endHour: 13)],
                classroom: "C-002"),

        Subject(name: "Presupuestos", clave: "2827", credits: 10, semester: 8, spots: 60,
                professor: "Zarate Colorado Santiago",
                scheduleSlots: [ScheduleSlot(day: .jueves,    startHour: 9,  endHour: 11),
                                ScheduleSlot(day: .martes,    startHour: 9,  endHour: 11)],
                classroom: "AULA-B11"),

        Subject(name: "Presupuestos", clave: "2827", credits: 10, semester: 8, spots: 60,
                professor: "Galan Villegas Veronica",
                scheduleSlots: [ScheduleSlot(day: .jueves,    startHour: 11, endHour: 13),
                                ScheduleSlot(day: .sabado,    startHour: 11, endHour: 13)],
                classroom: "A-002"),

        Subject(name: "Presupuestos", clave: "2827", credits: 10, semester: 8, spots: 60,
                professor: "España Barona Francisco",
                scheduleSlots: [ScheduleSlot(day: .martes,    startHour: 9,  endHour: 11),
                                ScheduleSlot(day: .viernes,   startHour: 9,  endHour: 11)],
                classroom: "AULA-B15"),

        Subject(name: "Presupuestos", clave: "2827", credits: 10, semester: 8, spots: 60,
                professor: "España Barona Francisco",
                scheduleSlots: [ScheduleSlot(day: .martes,    startHour: 11, endHour: 13),
                                ScheduleSlot(day: .viernes,   startHour: 11, endHour: 13)],
                classroom: "AULA-06"),

        Subject(name: "Presupuestos", clave: "2827", credits: 10, semester: 8, spots: 60,
                professor: "Rico Flores Gabriela",
                scheduleSlots: [ScheduleSlot(day: .miercoles, startHour: 11, endHour: 13),
                                ScheduleSlot(day: .sabado,    startHour: 11, endHour: 13)],
                classroom: "A-001"),

        Subject(name: "Presupuestos", clave: "2827", credits: 10, semester: 8, spots: 60,
                professor: "Sanchez Moya Nallely Edith",
                scheduleSlots: [ScheduleSlot(day: .lunes,     startHour: 9,  endHour: 11),
                                ScheduleSlot(day: .miercoles, startHour: 9,  endHour: 11)],
                classroom: "AULA-B11"),

        Subject(name: "Presupuestos", clave: "2827", credits: 10, semester: 8, spots: 60,
                professor: "Sanchez Moya Nallely Edith",
                scheduleSlots: [ScheduleSlot(day: .lunes,     startHour: 11, endHour: 13),
                                ScheduleSlot(day: .miercoles, startHour: 11, endHour: 13)],
                classroom: "C-203"),

        Subject(name: "Presupuestos", clave: "2827", credits: 10, semester: 8, spots: 60,
                professor: "Manzanares Velazquez Ignacio",
                scheduleSlots: [ScheduleSlot(day: .martes,    startHour: 11, endHour: 13),
                                ScheduleSlot(day: .jueves,    startHour: 11, endHour: 13)],
                classroom: "AULA-09"),

        Subject(name: "Presupuestos", clave: "2827", credits: 10, semester: 8, spots: 60,
                professor: "Zarate Colorado Santiago",
                scheduleSlots: [ScheduleSlot(day: .miercoles, startHour: 11, endHour: 13),
                                ScheduleSlot(day: .viernes,   startHour: 11, endHour: 13)],
                classroom: "AULA-B12"),

        Subject(name: "Presupuestos", clave: "2827", credits: 10, semester: 8, spots: 60,
                professor: "Magaña Santillan Fernando Guillermo",
                scheduleSlots: [ScheduleSlot(day: .miercoles, startHour: 18, endHour: 20),
                                ScheduleSlot(day: .lunes,     startHour: 18, endHour: 20)],
                classroom: "B-206"),

        Subject(name: "Presupuestos", clave: "2827", credits: 10, semester: 8, spots: 60,
                professor: "Hernandez Mena Hidekel Zuriel",
                scheduleSlots: [ScheduleSlot(day: .martes,    startHour: 20, endHour: 22),
                                ScheduleSlot(day: .jueves,    startHour: 20, endHour: 22)],
                classroom: "F-104"),

        Subject(name: "Presupuestos", clave: "2827", credits: 10, semester: 8, spots: 60,
                professor: "Zarate Lopez Edgar Alejandro",
                scheduleSlots: [ScheduleSlot(day: .viernes,   startHour: 18, endHour: 20),
                                ScheduleSlot(day: .martes,    startHour: 18, endHour: 20)],
                classroom: "B-005"),

        Subject(name: "Presupuestos", clave: "2827", credits: 10, semester: 8, spots: 60,
                professor: "Roman Rangel Ignacio",
                scheduleSlots: [ScheduleSlot(day: .martes,    startHour: 20, endHour: 22),
                                ScheduleSlot(day: .viernes,   startHour: 20, endHour: 22)],
                classroom: "B-206"),

        Subject(name: "Presupuestos", clave: "2827", credits: 10, semester: 8, spots: 60,
                professor: "Rosales Granados Jose Aurelio",
                scheduleSlots: [ScheduleSlot(day: .miercoles, startHour: 20, endHour: 22),
                                ScheduleSlot(day: .lunes,     startHour: 20, endHour: 22)],
                classroom: "AULA-09"),

        Subject(name: "Presupuestos", clave: "2827", credits: 10, semester: 8, spots: 60,
                professor: "Rivas Perez Ana Laura",
                scheduleSlots: [ScheduleSlot(day: .miercoles, startHour: 20, endHour: 22),
                                ScheduleSlot(day: .viernes,   startHour: 20, endHour: 22)],
                classroom: "F-104"),

        Subject(name: "Presupuestos", clave: "2827", credits: 10, semester: 8, spots: 60,
                professor: "Moreno Arellano Rafael Erick",
                scheduleSlots: [ScheduleSlot(day: .lunes,     startHour: 20, endHour: 22),
                                ScheduleSlot(day: .jueves,    startHour: 20, endHour: 22)],
                classroom: "B-101"),

        Subject(name: "Presupuestos", clave: "2827", credits: 10, semester: 8, spots: 60,
                professor: "Guzman Villanueva Luis Antonio",
                scheduleSlots: [ScheduleSlot(day: .jueves,    startHour: 20, endHour: 22),
                                ScheduleSlot(day: .martes,    startHour: 20, endHour: 22)],
                classroom: "A-003"),

        Subject(name: "Presupuestos", clave: "2827", credits: 10, semester: 8, spots: 60,
                professor: "Avalos Flores Adalberto",
                scheduleSlots: [ScheduleSlot(day: .miercoles, startHour: 20, endHour: 22),
                                ScheduleSlot(day: .viernes,   startHour: 20, endHour: 22)],
                classroom: "F-105"),

        Subject(name: "Presupuestos", clave: "2827", credits: 10, semester: 8, spots: 60,
                professor: "Zarate Lopez Edgar Alejandro",
                scheduleSlots: [ScheduleSlot(day: .miercoles, startHour: 20, endHour: 22),
                                ScheduleSlot(day: .viernes,   startHour: 20, endHour: 22)],
                classroom: "F-106"),

        Subject(name: "Presupuestos", clave: "2827", credits: 10, semester: 8, spots: 60,
                professor: "Rico Flores Gabriela",
                scheduleSlots: [ScheduleSlot(day: .jueves,    startHour: 20, endHour: 22),
                                ScheduleSlot(day: .lunes,     startHour: 20, endHour: 22)],
                classroom: "C-203"),

        Subject(name: "Presupuestos", clave: "2827", credits: 10, semester: 8, spots: 60,
                professor: "Sanchez Valenzuela Elimey",
                scheduleSlots: [ScheduleSlot(day: .martes,    startHour: 18, endHour: 20),
                                ScheduleSlot(day: .viernes,   startHour: 18, endHour: 20)],
                classroom: "B-101"),
    ]

    // MARK: - INFORMÁTICA  (claves 2824 y 2828, cupo 30)

    private let informaticaSubjects: [Subject] = [

        // ── CLAVE 2824 · AUDITORÍA INFORMÁTICA ───────────────────────────────

        Subject(name: "Auditoría Informática", clave: "2824", credits: 10, semester: 8, spots: 30,
                professor: "Martinez Ventura Juan Carlos",
                scheduleSlots: [ScheduleSlot(day: .miercoles, startHour: 9,  endHour: 11),
                                ScheduleSlot(day: .lunes,     startHour: 9,  endHour: 11)],
                classroom: "AULA-B11"),

        Subject(name: "Auditoría Informática", clave: "2824", credits: 10, semester: 8, spots: 30,
                professor: "Martinez Montesinos Delia Rocio",
                scheduleSlots: [ScheduleSlot(day: .martes,    startHour: 9,  endHour: 11),
                                ScheduleSlot(day: .jueves,    startHour: 9,  endHour: 11)],
                classroom: "D-107"),

        Subject(name: "Auditoría Informática", clave: "2824", credits: 10, semester: 8, spots: 30,
                professor: "Ponce Rosado Marco Antonio",
                scheduleSlots: [ScheduleSlot(day: .martes,    startHour: 18, endHour: 20),
                                ScheduleSlot(day: .jueves,    startHour: 18, endHour: 20)],
                classroom: "D-204"),

        // ── CLAVE 2828 · SERVICIOS DE TECNOLOGÍA ─────────────────────────────

        Subject(name: "Servicios de Tecnología", clave: "2828", credits: 10, semester: 8, spots: 30,
                professor: "Mejia Rodriguez Francisco David",
                scheduleSlots: [ScheduleSlot(day: .miercoles, startHour: 7,  endHour: 9),
                                ScheduleSlot(day: .lunes,     startHour: 7,  endHour: 9)],
                classroom: "AULA-B11"),

        Subject(name: "Servicios de Tecnología", clave: "2828", credits: 10, semester: 8, spots: 30,
                professor: "Pineda Sainz Christian David",
                scheduleSlots: [ScheduleSlot(day: .martes,    startHour: 7,  endHour: 9),
                                ScheduleSlot(day: .jueves,    startHour: 7,  endHour: 9)],
                classroom: "D-107"),

        Subject(name: "Servicios de Tecnología", clave: "2828", credits: 10, semester: 8, spots: 30,
                professor: "Torres Garibay Rodrigo",
                scheduleSlots: [ScheduleSlot(day: .lunes,     startHour: 16, endHour: 18),
                                ScheduleSlot(day: .miercoles, startHour: 16, endHour: 18)],
                classroom: "D-204"),
    ]

    // MARK: - NEGOCIOS INTERNACIONALES  (claves 1827 y 1828, Plan 2018, cupo 60)

    private let negociosInternacionalesSubjects: [Subject] = [

        // ── CLAVE 1827 · INGLÉS (OCTAVO SEMESTRE) ────────────────────────────

        Subject(name: "Inglés (Octavo Semestre)", clave: "1827", credits: 8, semester: 8, spots: 60,
                professor: "Garcia Martinez Cristina",
                scheduleSlots: [ScheduleSlot(day: .lunes,     startHour: 7,  startMinute: 0,  endHour: 9,  endMinute: 30),
                                ScheduleSlot(day: .miercoles, startHour: 7,  startMinute: 0,  endHour: 9,  endMinute: 30)],
                classroom: "B-003"),

        Subject(name: "Inglés (Octavo Semestre)", clave: "1827", credits: 8, semester: 8, spots: 60,
                professor: "Torres Sosa Javier",
                scheduleSlots: [ScheduleSlot(day: .lunes,     startHour: 16, startMinute: 0,  endHour: 18, endMinute: 30),
                                ScheduleSlot(day: .miercoles, startHour: 16, startMinute: 0,  endHour: 18, endMinute: 30)],
                classroom: "C-205"),

        // ── CLAVE 1828 · SEMINARIO DE NEGOCIOS INTERNACIONALES IV ─────────────

        Subject(name: "Seminario de Negocios Internacionales IV", clave: "1828", credits: 8, semester: 8, spots: 60,
                professor: "Jouanen Perez Gisele Solange",
                scheduleSlots: [ScheduleSlot(day: .lunes,     startHour: 9,  startMinute: 30, endHour: 11, endMinute: 0),
                                ScheduleSlot(day: .miercoles, startHour: 9,  startMinute: 30, endHour: 11, endMinute: 0)],
                classroom: "B-003"),

        Subject(name: "Seminario de Negocios Internacionales IV", clave: "1828", credits: 8, semester: 8, spots: 60,
                professor: "Gallardo Lopez Antonio",
                scheduleSlots: [ScheduleSlot(day: .lunes,     startHour: 18, startMinute: 30, endHour: 20, endMinute: 0),
                                ScheduleSlot(day: .miercoles, startHour: 18, startMinute: 30, endHour: 20, endMinute: 0)],
                classroom: "C-205"),
    ]
}
