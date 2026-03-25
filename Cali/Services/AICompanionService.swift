import Foundation

// MARK: - AICompanionService
// Uses Apple Intelligence (FoundationModels) — requires iOS 18.1+ with Apple Intelligence enabled.
// Falls back to rule-based responses on unsupported devices.

#if canImport(FoundationModels)
import FoundationModels
#endif

class AICompanionService {

    // MARK: - Private session wrapper

    #if canImport(FoundationModels)
    private var session: LanguageModelSession?

    private let systemInstructions = """
        Eres CALI (Carrera, Aliado, Cálido), un asistente académico inteligente y empático \
        de la UNAM. Tu misión es acompañar al alumno en su trayectoria universitaria. \
        Ayudas con: titulación y requisitos de graduación, orientación sobre materias y plan \
        de estudios, vida universitaria, servicio social, prácticas profesionales y cualquier \
        duda académica. Responde siempre en español, sé conciso (máximo 3 párrafos), cálido, \
        y usa emojis ocasionalmente para hacer la conversación amigable.
        """
    #endif

    init() {
        setupSession()
    }

    private func setupSession() {
        #if canImport(FoundationModels)
        let model = SystemLanguageModel.default
        guard case .available = model.availability else {
            session = nil
            return
        }
        session = LanguageModelSession(instructions: systemInstructions)
        #endif
    }

    // MARK: - Public interface

    func respond(to userMessage: String, context: String) async throws -> String {
        #if canImport(FoundationModels)
        if let session {
            // Prepend context snapshot as a brief system note
            let prompt = "[\(context)]\n\nAlumno: \(userMessage)"
            let response = try await session.respond(to: prompt)
            return response.content
        }
        #endif
        // Fallback when Apple Intelligence is unavailable
        return fallbackResponse(for: userMessage)
    }

    // MARK: - Rule-based fallback

    private func fallbackResponse(for message: String) -> String {
        let msg = message.lowercased()

        if msg.contains("titular") || msg.contains("titulaci") {
            return """
            Para titularte en la UNAM necesitas: 🎓
            • Completar el 100 % de tus créditos del plan de estudios.
            • Cumplir 480 horas de servicio social en institución registrada.
            • Liberar un idioma extranjero (inglés, francés, etc.).
            • Elegir y concluir una modalidad de titulación (tesis, EGEL, examen de conocimientos, etc.).

            ¿Quieres que profundice en alguno de estos puntos?
            """
        } else if msg.contains("servicio social") {
            return """
            El servicio social en la UNAM requiere mínimo 480 horas en una institución \
            registrada. 📋 Puedes iniciarlo cuando hayas cubierto al menos el 50 % de tus \
            créditos. Debes registrarte en el sistema de SS de tu facultad y elegir un proyecto \
            aprobado por la UNAM. ¿Tu facultad tiene alguna plataforma específica que quieras consultar?
            """
        } else if msg.contains("idioma") || msg.contains("inglés") || msg.contains("ingles") {
            return """
            Para liberar el idioma puedes presentar: 🌍
            • TOEFL ITP (mínimo 450 pts) o iBT.
            • Exámenes del CELE-UNAM.
            • Cambridge (B2 First o superior).
            • El examen interno de tu facultad (si aplica).

            ¿Ya cuentas con algún certificado?
            """
        } else if msg.contains("materia") || msg.contains("horario") || msg.contains("semestre") {
            return """
            En la sección Mi Horario puedes agregar tus materias y ver tu calendario semanal. 📚 \
            Recuerda revisar el catálogo de oferta disponible al inicio de cada semestre en el portal \
            de tu facultad. ¿Necesitas ayuda para planificar tu carga académica?
            """
        } else if msg.contains("cr") && msg.contains("dito") {
            return """
            Los créditos representan el peso académico de cada materia. 📊 Para titularte debes \
            cubrir el total de créditos de tu plan de estudios. Puedes consultar tu avance en el \
            portal de la DGAE o en el sistema SIIA de tu facultad. ¿Sabes cuántos te faltan?
            """
        } else {
            return """
            ¡Hola! Soy CALI, tu aliado académico en la UNAM. 👋 Puedo orientarte sobre \
            titulación, materias, servicio social, idioma, prácticas y cualquier tema universitario. \
            ¿Con qué te puedo ayudar hoy?

            ⚠️ *Nota:* Apple Intelligence no está disponible en este dispositivo, \
            así que mis respuestas son predeterminadas. En un dispositivo compatible, \
            mis respuestas serán mucho más personalizadas.
            """
        }
    }
}
