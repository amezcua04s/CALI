import Foundation

// MARK: - ChecklistItem

struct ChecklistItem: Identifiable, Codable {
    let id: UUID
    var title: String
    var description: String
    var isCompleted: Bool
    var category: ChecklistCategory
    var requiredForGraduation: Bool
    var details: String?

    init(
        id: UUID = UUID(),
        title: String,
        description: String,
        isCompleted: Bool = false,
        category: ChecklistCategory,
        requiredForGraduation: Bool = true,
        details: String? = nil
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.isCompleted = isCompleted
        self.category = category
        self.requiredForGraduation = requiredForGraduation
        self.details = details
    }

    // MARK: - Category

    enum ChecklistCategory: String, Codable, CaseIterable {
        case creditos      = "Créditos"
        case servicio      = "Servicio Social"
        case idioma        = "Idioma"
        case titulacion    = "Titulación"
        case practicas     = "Prácticas"
        case administrativo = "Administrativo"

        var icon: String {
            switch self {
            case .creditos:       return "books.vertical"
            case .servicio:       return "hands.and.sparkles"
            case .idioma:         return "globe"
            case .titulacion:     return "graduationcap"
            case .practicas:      return "briefcase"
            case .administrativo: return "doc.text"
            }
        }
    }
}

// MARK: - Default UNAM Checklist

extension ChecklistItem {
    static let defaultItems: [ChecklistItem] = [
        ChecklistItem(
            title: "Créditos totales",
            description: "Completar el 100% de los créditos del plan de estudios",
            category: .creditos,
            details: "Consulta tu historial académico en el portal de DGAE"
        ),
        ChecklistItem(
            title: "Servicio Social",
            description: "480 horas mínimas en institución registrada ante la UNAM",
            category: .servicio,
            details: "Regístrate en el sistema de SS de tu facultad"
        ),
        ChecklistItem(
            title: "Liberación del Idioma",
            description: "Certificación de idioma extranjero (inglés u otro)",
            category: .idioma,
            details: "TOEFL, Cambridge, CELE-UNAM u otro reconocido por la institución"
        ),
        ChecklistItem(
            title: "Modalidad de Titulación",
            description: "Elegir y completar la opción de titulación (tesis, tesina, EGEL, etc.)",
            category: .titulacion
        ),
        ChecklistItem(
            title: "Impresión y entrega del trabajo",
            description: "Entregar los ejemplares requeridos según tu facultad",
            category: .titulacion
        ),
        ChecklistItem(
            title: "Prácticas Profesionales",
            description: "Completar horas de prácticas según tu plan de estudios",
            category: .practicas,
            requiredForGraduation: false
        ),
        ChecklistItem(
            title: "Sin adeudo en Biblioteca",
            description: "No tener libros pendientes de devolución",
            category: .administrativo
        ),
        ChecklistItem(
            title: "Trámite de Certificado",
            description: "Solicitar certificado de estudios en Control Escolar",
            category: .administrativo
        ),
        ChecklistItem(
            title: "Pago de derechos de examen",
            description: "Cubrir los derechos del examen profesional",
            category: .administrativo
        ),
        ChecklistItem(
            title: "Examen Médico",
            description: "Examen médico en clínica universitaria",
            category: .administrativo,
            requiredForGraduation: false
        )
    ]
}
