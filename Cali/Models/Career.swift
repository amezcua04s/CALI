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


extension Career {
    static let unamCareers: [Career] = [
        Career(name: "Administración",
               faculty: "Facultad de Contaduría y Administración",
               durationSemesters: 8, totalCredits: 408,
               description: "Profesionistas con visión estratégica, ética y de compromiso social expertos en promover el logro eficiente de objetivos de organizaciones públicas, privadas y sociales."),
        Career(name: "Contaduría",
               faculty: "Facultad de Contaduría y Administración",
               durationSemesters: 8, totalCredits: 432,
               description: "Busca satisfacer las necesidades de las organizaciones y los individuos relacionadas con la toma de decisiones sobre su patrimonio, expresado en valores financieros, a fin de incrementar el patrimonio, pagar contribuciones, y llevar un registro de dichas operaciones financieras."),
        Career(name: "Informática",
               faculty: "Facultad de Contaduría y Administración",
               durationSemesters: 8, totalCredits: 375,
               description: "Profesionistas capaces de diseñar, desarrollar, implementar y administrar los sistemas de información económica y administrativa con el fin de atender y resolver problemas concretos en las organizaciones."),
        Career(name: "Negocios Internacionales",
               faculty: "Facultad de Contaduría y Administración",
               durationSemesters: 8, totalCredits: 300,
               description: "Profesionistas con una visión interdisciplinaria y global, capaces de diseñar modelos de negocios, generar soluciones creativas a las necesidades de las empresas que participan en el mercado mundial y promover el logro de objetivos en organizaciones públicas, privadas y sociales vinculadas con los negocios internacionales."),
    ]
}
