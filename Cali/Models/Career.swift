import Foundation

// MARK: - Career Model

struct Career: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let faculty: String
    let durationSemesters: Int
    let totalCredits: Int
    let description: String

    init(
        id: UUID = UUID(),
        name: String,
        faculty: String,
        durationSemesters: Int,
        totalCredits: Int,
        description: String
    ) {
        self.id = id
        self.name = name
        self.faculty = faculty
        self.durationSemesters = durationSemesters
        self.totalCredits = totalCredits
        self.description = description
    }
}

// MARK: - UNAM Careers Catalogue

extension Career {
    static let unamCareers: [Career] = [
        Career(name: "Ingeniería en Computación",
               faculty: "Facultad de Ingeniería",
               durationSemesters: 9, totalCredits: 360,
               description: "Diseño y desarrollo de sistemas de software y hardware."),
        Career(name: "Ciencias de la Computación",
               faculty: "Facultad de Ciencias",
               durationSemesters: 8, totalCredits: 315,
               description: "Fundamentos teóricos y aplicados de la computación."),
        Career(name: "Ingeniería en Telecomunicaciones",
               faculty: "Facultad de Ingeniería",
               durationSemesters: 9, totalCredits: 375,
               description: "Sistemas y redes de comunicación."),
        Career(name: "Matemáticas",
               faculty: "Facultad de Ciencias",
               durationSemesters: 8, totalCredits: 300,
               description: "Estudio de estructuras matemáticas y sus aplicaciones."),
        Career(name: "Actuaría",
               faculty: "Facultad de Ciencias",
               durationSemesters: 8, totalCredits: 320,
               description: "Análisis estadístico y financiero de riesgos."),
        Career(name: "Administración",
               faculty: "Facultad de Contaduría y Administración",
               durationSemesters: 8, totalCredits: 330,
               description: "Gestión y dirección de organizaciones."),
        Career(name: "Contaduría",
               faculty: "Facultad de Contaduría y Administración",
               durationSemesters: 8, totalCredits: 330,
               description: "Finanzas, contabilidad y auditoría empresarial."),
        Career(name: "Derecho",
               faculty: "Facultad de Derecho",
               durationSemesters: 8, totalCredits: 300,
               description: "Estudio del sistema jurídico mexicano e internacional."),
        Career(name: "Medicina",
               faculty: "Facultad de Medicina",
               durationSemesters: 12, totalCredits: 480,
               description: "Formación médica integral para el diagnóstico y tratamiento."),
        Career(name: "Odontología",
               faculty: "Facultad de Odontología",
               durationSemesters: 10, totalCredits: 380,
               description: "Salud bucodental y tratamiento odontológico."),
        Career(name: "Psicología",
               faculty: "Facultad de Psicología",
               durationSemesters: 8, totalCredits: 295,
               description: "Comportamiento humano y salud mental."),
        Career(name: "Arquitectura",
               faculty: "Facultad de Arquitectura",
               durationSemesters: 10, totalCredits: 400,
               description: "Diseño y construcción de espacios habitables."),
        Career(name: "Comunicación",
               faculty: "Facultad de Ciencias Políticas y Sociales",
               durationSemesters: 8, totalCredits: 285,
               description: "Medios de comunicación, periodismo y cultura."),
        Career(name: "Economía",
               faculty: "Facultad de Economía",
               durationSemesters: 8, totalCredits: 300,
               description: "Análisis de mercados, política económica y desarrollo."),
        Career(name: "Biología",
               faculty: "Facultad de Ciencias",
               durationSemesters: 8, totalCredits: 310,
               description: "Estudio de los seres vivos y sus interacciones."),
        Career(name: "Química",
               faculty: "Facultad de Química",
               durationSemesters: 9, totalCredits: 365,
               description: "Transformación y propiedades de la materia."),
        Career(name: "Física",
               faculty: "Facultad de Ciencias",
               durationSemesters: 8, totalCredits: 305,
               description: "Estudio de las leyes fundamentales del universo."),
        Career(name: "Ingeniería Civil",
               faculty: "Facultad de Ingeniería",
               durationSemesters: 9, totalCredits: 370,
               description: "Diseño y construcción de infraestructura."),
        Career(name: "Ingeniería Mecánica",
               faculty: "Facultad de Ingeniería",
               durationSemesters: 9, totalCredits: 365,
               description: "Diseño y análisis de sistemas mecánicos."),
        Career(name: "Medicina Veterinaria y Zootecnia",
               faculty: "Facultad de Medicina Veterinaria y Zootecnia",
               durationSemesters: 9, totalCredits: 370,
               description: "Salud y producción de animales.")
    ]
}
