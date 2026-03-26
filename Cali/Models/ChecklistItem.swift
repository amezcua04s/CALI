import Foundation

// MARK: - ChecklistItem

struct ChecklistItem: Identifiable, Codable {
    let id: UUID
    var title: String
    var description: String
    var isCompleted: Bool
    var section: ChecklistSection
    var requiredForGraduation: Bool
    var details: String?

    init(
        id: UUID = UUID(),
        title: String,
        description: String,
        isCompleted: Bool = false,
        section: ChecklistSection,
        requiredForGraduation: Bool = true,
        details: String? = nil
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.isCompleted = isCompleted
        self.section = section
        self.requiredForGraduation = requiredForGraduation
        self.details = details
    }

    // MARK: - Section (siempre 2 secciones)

    enum ChecklistSection: String, Codable, CaseIterable {
        case obligatoria = "Requisitos Obligatorios"
        case modalidad   = "Pasos de Titulación"

        var icon: String {
            switch self {
            case .obligatoria: return "list.bullet.clipboard"
            case .modalidad:   return "graduationcap"
            }
        }
    }

    // MARK: - Graduation Option

    enum GraduationOption: String, Codable, CaseIterable {
        case tesis               = "Tesis"
        case examenConocimientos = "Examen de Conocimientos"
        case diplomado           = "Diplomado"
        case promedio            = "Titulación por Promedio"
        case proyecto            = "Proyecto"

        var icon: String {
            switch self {
            case .tesis:               return "doc.text.magnifyingglass"
            case .examenConocimientos: return "pencil.and.list.clipboard"
            case .diplomado:           return "checkmark.seal"
            case .promedio:            return "chart.bar.xaxis.ascending"
            case .proyecto:            return "lightbulb"
            }
        }
    }
}

// MARK: - Item Factories

extension ChecklistItem {

    // MARK: Sección 1 – siempre visible
    // Prácticas Profesionales solo aparece para Negocios Internacionales

    static func obligatorioItems(isNegociosInternacionales: Bool) -> [ChecklistItem] {
        var items: [ChecklistItem] = [
            ChecklistItem(
                title: "Créditos totales",
                description: "Completar el 100 % de los créditos del plan de estudios",
                section: .obligatoria,
                details: "Consulta tu historial académico en el portal de DGAE"
            ),
            ChecklistItem(
                title: "Servicio Social",
                description: "480 horas mínimas en institución registrada ante la UNAM",
                section: .obligatoria,
                details: "Regístrate en el sistema de SS de tu facultad"
            ),
            ChecklistItem(
                title: "Liberación del Idioma",
                description: "Certificación de idioma extranjero (inglés u otro)",
                section: .obligatoria,
                details: "TOEFL, Cambridge, CELE-UNAM u otro reconocido por la institución"
            ),
            ChecklistItem(
                title: "Sin adeudo en Biblioteca",
                description: "No tener libros pendientes de devolución",
                section: .obligatoria
            ),
            ChecklistItem(
                title: "Trámite de Certificado",
                description: "Solicitar certificado de estudios en Control Escolar",
                section: .obligatoria
            ),
            ChecklistItem(
                title: "Pago de derechos",
                description: "Cubrir los derechos del examen profesional",
                section: .obligatoria
            ),
        ]

        if isNegociosInternacionales {
            items.append(ChecklistItem(
                title: "Prácticas Profesionales",
                description: "Completar las horas de prácticas profesionales requeridas",
                section: .obligatoria,
                details: "Consulta los requisitos específicos con tu coordinación"
            ))
        }

        return items
    }

    // MARK: Sección 2 – cambia según la modalidad elegida

    static func modalidadItems(
        option: GraduationOption,
        revisionCount: Int,
        fechaInscripcion: String,
        diplomadoNombre: String
    ) -> [ChecklistItem] {

        switch option {

        // ── TESIS ────────────────────────────────────────────────────────────
        case .tesis:
            var items: [ChecklistItem] = [
                ChecklistItem(
                    title: "Buscar asesor",
                    description: "Encontrar a un profesor que acepte asesorar tu tesis",
                    section: .modalidad
                ),
                ChecklistItem(
                    title: "Encontrar tema",
                    description: "Definir el tema de investigación de la tesis",
                    section: .modalidad
                ),
                ChecklistItem(
                    title: "Hacer investigación",
                    description: "Recopilar y analizar fuentes para el desarrollo de la tesis",
                    section: .modalidad
                ),
                ChecklistItem(
                    title: "Hacer tesina",
                    description: "Redactar el documento completo de la tesis",
                    section: .modalidad
                ),
            ]
            for i in 1...max(1, revisionCount) {
                items.append(ChecklistItem(
                    title: "Revisión de tesina \(i)",
                    description: "Revisión número \(i) con tu asesor",
                    section: .modalidad
                ))
            }
            items.append(ChecklistItem(
                title: "Presentación final de tesina",
                description: "Examen profesional ante el jurado",
                section: .modalidad
            ))
            return items

        // ── EXAMEN DE CONOCIMIENTOS ──────────────────────────────────────────
        case .examenConocimientos:
            let f = fechaInscripcion.trimmingCharacters(in: .whitespaces).isEmpty
                    ? "la fecha indicada" : fechaInscripcion
            return [
                ChecklistItem(
                    title: "Inscribirse antes de \(f)",
                    description: "Realizar el registro al examen de conocimientos",
                    section: .modalidad
                ),
                ChecklistItem(
                    title: "Hacer pago correspondiente",
                    description: "Cubrir el costo del examen según el arancel vigente",
                    section: .modalidad
                ),
                ChecklistItem(
                    title: "Presentarse el día del examen",
                    description: "Acudir en tiempo y forma con identificación y documentos requeridos",
                    section: .modalidad
                ),
            ]

        // ── DIPLOMADO ────────────────────────────────────────────────────────
        case .diplomado:
            let f = fechaInscripcion.trimmingCharacters(in: .whitespaces).isEmpty
                    ? "la fecha indicada" : fechaInscripcion
            let n = diplomadoNombre.trimmingCharacters(in: .whitespaces).isEmpty
                    ? "el diplomado seleccionado" : diplomadoNombre
            return [
                ChecklistItem(
                    title: "Inscribirse antes de \(f)",
                    description: "Completar el proceso de inscripción al diplomado",
                    section: .modalidad
                ),
                ChecklistItem(
                    title: "Hacer pago correspondiente",
                    description: "Cubrir el costo de \(n)",
                    section: .modalidad
                ),
                ChecklistItem(
                    title: "Entregar documentación para \(n)",
                    description: "Llevar la documentación requerida para el alta del diplomado",
                    section: .modalidad
                ),
            ]

        // ── PROMEDIO ─────────────────────────────────────────────────────────
        case .promedio:
            return [
                ChecklistItem(
                    title: "Presentar solicitud de titulación por promedio",
                    description: "Solicitar la titulación automática por promedio en Control Escolar",
                    section: .modalidad,
                    details: "Se requiere promedio mínimo de 9.0 sin materias reprobadas"
                ),
            ]

        // ── PROYECTO ─────────────────────────────────────────────────────────
        case .proyecto:
            var items: [ChecklistItem] = [
                ChecklistItem(
                    title: "Pensar en idea de proyecto",
                    description: "Definir la idea central y alcance del proyecto",
                    section: .modalidad
                ),
                ChecklistItem(
                    title: "Investigar información necesaria",
                    description: "Recopilar fuentes, datos y marco teórico del proyecto",
                    section: .modalidad
                ),
                ChecklistItem(
                    title: "Buscar asesor",
                    description: "Encontrar a un profesor que acepte asesorar tu proyecto",
                    section: .modalidad
                ),
                ChecklistItem(
                    title: "Desarrollar el proyecto",
                    description: "Elaborar el proyecto completo según el plan definido",
                    section: .modalidad
                ),
            ]
            for i in 1...max(1, revisionCount) {
                items.append(ChecklistItem(
                    title: "Revisión del proyecto \(i)",
                    description: "Revisión número \(i) con tu asesor",
                    section: .modalidad
                ))
            }
            items.append(ChecklistItem(
                title: "Entrega final del proyecto",
                description: "Entregar el proyecto terminado en las instancias correspondientes",
                section: .modalidad
            ))
            items.append(ChecklistItem(
                title: "Examen oral del proyecto",
                description: "Presentar y defender el proyecto ante el jurado",
                section: .modalidad
            ))
            return items
        }
    }
}
