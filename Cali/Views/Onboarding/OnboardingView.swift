import SwiftUI
import UIKit
import Vision

// MARK: - OnboardingView
// Registro guiado: Bienvenida → Credencial → Datos personales → Semestre

struct OnboardingView: View {
    @EnvironmentObject var appViewModel: AppViewModel

    @State private var step = 0
    @State private var showCareerPicker = false

    // Form state
    @State private var name = ""
    @State private var lastName = ""
    @State private var studentNumber = ""
    @State private var generation = ""
    @State private var email = ""
    @State private var selectedCareer: Career?
    @State private var currentSemester = 1

    // Credential state
    @State private var frontCredentialImage: UIImage?
    @State private var backCredentialImage: UIImage?
    @State private var extractedCredentialData = ExtractedCredentialData()
    @State private var isExtractingCredentialData = false
    @State private var extractionErrorMessage: String?
    @State private var registrationStatusMessage: String?
    @State private var provisionalPassword = ""
    @State private var showRegistrationAlert = false

    private let totalSteps = 4
    private let registrationService = RegistrationService()

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.blue.opacity(0.07), Color.white],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                if step > 0 {
                    ProgressView(value: Double(step), total: Double(totalSteps - 1))
                        .tint(.blue)
                        .padding(.horizontal, 24)
                        .padding(.top, 20)
                }

                TabView(selection: $step) {
                    WelcomeStep().tag(0)
                    CredentialCaptureStep(
                        frontImage: $frontCredentialImage,
                        backImage: $backCredentialImage,
                        isExtracting: isExtractingCredentialData,
                        extractionErrorMessage: extractionErrorMessage,
                        onExtract: extractCredentialData
                    )
                    .tag(1)
                    PersonalDataStep(
                        name: $name,
                        lastName: $lastName,
                        studentNumber: $studentNumber,
                        generation: $generation,
                        email: $email,
                        selectedCareer: $selectedCareer,
                        showCareerPicker: $showCareerPicker,
                        extractedCredentialData: extractedCredentialData
                    )
                    .tag(2)
                    SemesterStep(semester: $currentSemester, career: selectedCareer).tag(3)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.3), value: step)

                HStack(spacing: 12) {
                    if step > 0 {
                        Button("Atrás") { withAnimation { step -= 1 } }
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(14)
                    }

                    Button(primaryButtonTitle) {
                        if step == totalSteps - 1 {
                            finishOnboarding()
                        } else {
                            withAnimation { step += 1 }
                        }
                    }
                    .disabled(!canContinue || isExtractingCredentialData)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background((canContinue && !isExtractingCredentialData) ? Color.blue : Color.gray.opacity(0.3))
                    .foregroundStyle(.white)
                    .cornerRadius(14)
                    .fontWeight(.semibold)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .sheet(isPresented: $showCareerPicker) {
            CareerPickerSheet(selectedCareer: $selectedCareer)
        }
        .alert("Registro completado", isPresented: $showRegistrationAlert) {
            Button("Continuar") {
                appViewModel.completeOnboarding()
            }
        } message: {
            Text(registrationAlertMessage)
        }
    }

    private var primaryButtonTitle: String {
        switch step {
        case 0: return "Regístrate"
        case totalSteps - 1: return "Finalizar registro"
        default: return "Continuar"
        }
    }

    private var registrationAlertMessage: String {
        let base = registrationStatusMessage ?? "Tu registro quedó listo."
        return provisionalPassword.isEmpty ? base : "\(base)\n\nContraseña provisional generada: \(provisionalPassword)"
    }

    // MARK: Validation
    private var canContinue: Bool {
        switch step {
        case 0:
            return true
        case 1:
            return frontCredentialImage != nil && backCredentialImage != nil
        case 2:
            return !name.trimmed.isEmpty &&
                   !lastName.trimmed.isEmpty &&
                   !studentNumber.trimmed.isEmpty &&
                   !generation.trimmed.isEmpty &&
                   selectedCareer != nil &&
                   isValidInstitutionalEmail(email)
        case 3:
            return true
        default:
            return false
        }
    }

    private func extractCredentialData() {
        guard let frontCredentialImage, let backCredentialImage else { return }

        extractionErrorMessage = nil
        isExtractingCredentialData = true

        Task {
            do {
                let extracted = try await registrationService.extractCredentialData(
                    frontImage: frontCredentialImage,
                    backImage: backCredentialImage
                )

                await MainActor.run {
                    extractedCredentialData = extracted
                    if !extracted.name.isEmpty { name = extracted.name }
                    if !extracted.lastName.isEmpty { lastName = extracted.lastName }
                    if !extracted.studentNumber.isEmpty { studentNumber = extracted.studentNumber }
                    if !extracted.generation.isEmpty { generation = extracted.generation }
                    if let career = extracted.career { selectedCareer = career }
                    isExtractingCredentialData = false
                }
            } catch {
                await MainActor.run {
                    extractionErrorMessage = error.localizedDescription
                    isExtractingCredentialData = false
                }
            }
        }
    }

    private func finishOnboarding() {
        appViewModel.userProfile.name = name.trimmed
        appViewModel.userProfile.lastName = lastName.trimmed
        appViewModel.userProfile.studentNumber = studentNumber.trimmed
        appViewModel.userProfile.generation = generation.trimmed
        appViewModel.userProfile.email = email.trimmed.lowercased()
        appViewModel.userProfile.career = selectedCareer
        appViewModel.userProfile.currentSemester = currentSemester

        provisionalPassword = registrationService.generateTemporaryPassword()
        registrationStatusMessage = "Se generó la contraseña provisional para el primer acceso. El punto de integración para el envío por correo ya quedó preparado, pero el envío real requiere conectar un backend o servicio SMTP/API."
        showRegistrationAlert = true
    }

    private func isValidInstitutionalEmail(_ value: String) -> Bool {
        let email = value.trimmed.lowercased()
        let pattern = #"^[A-Z0-9._%+-]+@[A-Z0-9.-]*unam\.mx$"#
        return email.range(of: pattern, options: [.regularExpression, .caseInsensitive]) != nil
    }
}

// MARK: - Step 0 – Welcome

struct WelcomeStep: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 36) {
                Spacer(minLength: 32)

                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: [.blue, .purple],
                                            startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 120, height: 120)
                        .shadow(color: .blue.opacity(0.4), radius: 24, x: 0, y: 12)
                    Text("C")
                        .font(.system(size: 62, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                }

                VStack(spacing: 8) {
                    Text("Hola, soy CALI")
                        .font(.largeTitle).fontWeight(.bold)
                    Text("Regístrate con tu credencial UNAM y completa tu perfil en unos minutos")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }

                VStack(spacing: 12) {
                    FeatureRow(icon: "camera.viewfinder", color: .blue,
                               title: "Captura tu credencial",
                               description: "Toma una foto del frente y reverso para extraer tus datos")
                    FeatureRow(icon: "text.viewfinder", color: .green,
                               title: "Autollenado inteligente",
                               description: "Se detectan nombre, apellidos, número de cuenta, carrera y generación")
                    FeatureRow(icon: "envelope.badge", color: .orange,
                               title: "Primer acceso",
                               description: "Valida tu correo institucional y genera una contraseña provisional")
                }
                .padding(.horizontal, 24)

                Spacer(minLength: 24)
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let color: Color
    let title: String
    let description: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
                .frame(width: 46, height: 46)
                .background(color.opacity(0.12))
                .cornerRadius(12)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline).fontWeight(.semibold)
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(14)
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)
    }
}

// MARK: - Step 1 – Credential capture

struct CredentialCaptureStep: View {
    @Binding var frontImage: UIImage?
    @Binding var backImage: UIImage?
    let isExtracting: Bool
    let extractionErrorMessage: String?
    let onExtract: () -> Void

    @State private var activeSide: CredentialSide?
    @State private var showSourceDialog = false
    @State private var showImagePicker = false
    @State private var imageSource: UIImagePickerController.SourceType = .camera

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Escanea tu credencial")
                        .font(.largeTitle).fontWeight(.bold)
                    Text("Captura el frente y reverso de tu credencial UNAM. Después extraemos los datos para completar el registro.")
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                CredentialImageCard(
                    title: "Frente de la credencial",
                    subtitle: "Asegúrate de que el texto sea legible",
                    image: frontImage
                ) {
                    activeSide = .front
                    showSourceDialog = true
                }

                CredentialImageCard(
                    title: "Reverso de la credencial",
                    subtitle: "Incluye la parte trasera completa",
                    image: backImage
                ) {
                    activeSide = .back
                    showSourceDialog = true
                }

                Button {
                    onExtract()
                } label: {
                    HStack {
                        if isExtracting {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Image(systemName: "text.viewfinder")
                        }
                        Text(isExtracting ? "Extrayendo datos..." : "Extraer datos de la credencial")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background((frontImage != nil && backImage != nil) ? Color.green : Color.gray.opacity(0.25))
                    .foregroundStyle(.white)
                    .cornerRadius(14)
                }
                .disabled(frontImage == nil || backImage == nil || isExtracting)

                if let extractionErrorMessage, !extractionErrorMessage.isEmpty {
                    Label(extractionErrorMessage, systemImage: "exclamationmark.triangle.fill")
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.red.opacity(0.08))
                        .cornerRadius(14)
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Tip")
                        .font(.headline)
                    Text("Esta versión usa OCR local con Vision para detectar texto desde la imagen. Después puedes conectar un servicio de IA o backend si quieres validaciones más robustas o envío real del correo.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
            }
            .padding(.horizontal, 24)
            .padding(.top, 32)
        }
        .confirmationDialog("Selecciona una fuente", isPresented: $showSourceDialog, titleVisibility: .visible) {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                Button("Tomar foto") {
                    imageSource = .camera
                    showImagePicker = true
                }
            }
            Button("Elegir de la galería") {
                imageSource = .photoLibrary
                showImagePicker = true
            }
            Button("Cancelar", role: .cancel) {}
        }
        .sheet(isPresented: $showImagePicker) {
            CameraImagePicker(sourceType: imageSource) { image in
                guard let activeSide else { return }
                switch activeSide {
                case .front:
                    frontImage = image
                case .back:
                    backImage = image
                }
            }
        }
    }
}

struct CredentialImageCard: View {
    let title: String
    let subtitle: String
    let image: UIImage?
    let action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Button(image == nil ? "Capturar" : "Reemplazar", action: action)
                    .font(.subheadline.weight(.semibold))
            }

            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.blue.opacity(0.08))
                    .frame(height: 190)

                if let image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: 178)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(8)
                } else {
                    VStack(spacing: 10) {
                        Image(systemName: "camera.fill")
                            .font(.title)
                            .foregroundStyle(.blue)
                        Text("Sin imagen")
                            .font(.subheadline.weight(.semibold))
                        Text("Toca Capturar para agregar la foto")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Step 2 – Personal Data

struct PersonalDataStep: View {
    @Binding var name: String
    @Binding var lastName: String
    @Binding var studentNumber: String
    @Binding var generation: String
    @Binding var email: String
    @Binding var selectedCareer: Career?
    @Binding var showCareerPicker: Bool
    let extractedCredentialData: ExtractedCredentialData

    private var isValidUNAMEmail: Bool {
        let pattern = #"^[A-Z0-9._%+-]+@[A-Z0-9.-]*unam\.mx$"#
        return email.trimmed.range(of: pattern, options: [.regularExpression, .caseInsensitive]) != nil
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Revisa tus datos")
                        .font(.largeTitle).fontWeight(.bold)
                    Text("Los campos se autocompletan con la credencial y tú puedes ajustarlos manualmente.")
                        .foregroundStyle(.secondary)
                }

                if extractedCredentialData.hasAnyValue {
                    Label("Se detectaron datos desde la credencial. Verifica que todo esté correcto.", systemImage: "checkmark.seal.fill")
                        .font(.footnote)
                        .foregroundStyle(.green)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.green.opacity(0.08))
                        .cornerRadius(14)
                }

                VStack(spacing: 16) {
                    CALITextField(title: "Nombre(s)", placeholder: "p. ej. Ana Sofía",
                                  text: $name, icon: "person")
                    CALITextField(title: "Apellidos", placeholder: "p. ej. Ramírez Torres",
                                  text: $lastName, icon: "person.fill")
                    CALITextField(title: "Número de cuenta", placeholder: "p. ej. 420123456",
                                  text: $studentNumber, icon: "number")
                    CALITextField(title: "Generación", placeholder: "p. ej. 2023",
                                  text: $generation, icon: "calendar")
                    CALITextField(title: "Correo institucional UNAM",
                                  placeholder: "usuario@comunidad.unam.mx",
                                  text: $email, icon: "envelope",
                                  keyboardType: .emailAddress)

                    if !email.trimmed.isEmpty {
                        Label(isValidUNAMEmail ? "Correo institucional válido" : "Ingresa un correo con dominio .unam.mx",
                              systemImage: isValidUNAMEmail ? "checkmark.circle.fill" : "xmark.octagon.fill")
                            .font(.footnote)
                            .foregroundStyle(isValidUNAMEmail ? .green : .red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Carrera")
                        .font(.headline)

                    if let career = selectedCareer {
                        CareerCard(career: career) { showCareerPicker = true }
                    } else {
                        Button { showCareerPicker = true } label: {
                            HStack {
                                Image(systemName: "books.vertical")
                                Text("Seleccionar carrera")
                                    .fontWeight(.semibold)
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                            .foregroundStyle(.blue)
                            .padding()
                            .background(Color.blue.opacity(0.08))
                            .cornerRadius(14)
                        }
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 32)
        }
    }
}

// MARK: - Step 3 – Semester

struct SemesterStep: View {
    @Binding var semester: Int
    let career: Career?

    var maxSemesters: Int { career?.durationSemesters ?? 12 }

    var body: some View {
        VStack(alignment: .leading, spacing: 28) {
            VStack(alignment: .leading, spacing: 6) {
                Text("¿En qué semestre vas?")
                    .font(.largeTitle).fontWeight(.bold)
                Text("Selecciona tu semestre actual")
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 24)
            .padding(.top, 32)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
                ForEach(1...maxSemesters, id: \.self) { sem in
                    Button { semester = sem } label: {
                        Text("\(sem)°")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(semester == sem ? Color.blue : Color.gray.opacity(0.1))
                            .foregroundStyle(semester == sem ? Color.white : Color.primary)
                            .cornerRadius(12)
                    }
                }
            }
            .padding(.horizontal, 24)

            Spacer()
        }
    }
}

// MARK: - Career Card (reused in onboarding + profile)

struct CareerCard: View {
    let career: Career
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                Text(career.name)
                    .font(.title3).fontWeight(.bold)
                    .foregroundStyle(Color.primary)
                Text(career.faculty)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Divider()

                HStack {
                    StatPill(value: "\(career.durationSemesters) sem.", color: .blue)
                    StatPill(value: "\(career.totalCredits) créditos", color: .purple)
                    Spacer()
                    Image(systemName: "chevron.right.circle")
                        .foregroundStyle(.blue.opacity(0.6))
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)
        }
    }
}

struct StatPill: View {
    let value: String
    let color: Color

    var body: some View {
        Text(value)
            .font(.caption).fontWeight(.semibold)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(color.opacity(0.12))
            .foregroundStyle(color)
            .cornerRadius(999)
    }
}

// MARK: - Career Picker Sheet

struct CareerPickerSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedCareer: Career?
    @State private var search = ""

    private var filteredCareers: [Career] {
        if search.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return Career.unamCareers
        }
        return Career.unamCareers.filter {
            $0.name.localizedCaseInsensitiveContains(search) ||
            $0.faculty.localizedCaseInsensitiveContains(search)
        }
    }

    var body: some View {
        NavigationStack {
            List(filteredCareers) { career in
                Button {
                    selectedCareer = career
                    dismiss()
                } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(career.name)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.primary)
                        Text(career.faculty)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text(career.description)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }
                    .padding(.vertical, 4)
                }
            }
            .searchable(text: $search, prompt: "Buscar carrera")
            .navigationTitle("Carreras UNAM")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cerrar") { dismiss() }
                }
            }
        }
    }
}

// MARK: - Shared TextField component

struct CALITextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let icon: String
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundStyle(.blue)
                    .frame(width: 20)

                TextField(placeholder, text: $text)
                    .keyboardType(keyboardType)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }
            .padding()
            .background(Color.white)
            .cornerRadius(14)
            .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
        }
    }
}

// MARK: - Registration support

private enum CredentialSide {
    case front
    case back
}

struct ExtractedCredentialData {
    var name: String = ""
    var lastName: String = ""
    var studentNumber: String = ""
    var generation: String = ""
    var career: Career?

    var hasAnyValue: Bool {
        !name.isEmpty || !lastName.isEmpty || !studentNumber.isEmpty || !generation.isEmpty || career != nil
    }
}

enum RegistrationServiceError: LocalizedError {
    case invalidImage
    case noTextDetected

    var errorDescription: String? {
        switch self {
        case .invalidImage:
            return "No se pudo procesar alguna de las imágenes seleccionadas."
        case .noTextDetected:
            return "No fue posible detectar texto legible en la credencial. Intenta con una foto más nítida y buena iluminación."
        }
    }
}

struct RegistrationService {
    func extractCredentialData(frontImage: UIImage, backImage: UIImage) async throws -> ExtractedCredentialData {
        async let frontText = recognizeText(in: frontImage)
        async let backText = recognizeText(in: backImage)
        let combinedText = try await (frontText + "\n" + backText)

        guard !combinedText.trimmed.isEmpty else {
            throw RegistrationServiceError.noTextDetected
        }

        return parseCredentialText(combinedText)
    }

    func generateTemporaryPassword(length: Int = 10) -> String {
        let symbols = Array("ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz23456789")
        return String((0..<length).compactMap { _ in symbols.randomElement() })
    }

    private func recognizeText(in image: UIImage) async throws -> String {
        guard let cgImage = image.cgImage else {
            throw RegistrationServiceError.invalidImage
        }

        return try await withCheckedThrowingContinuation { continuation in
            let request = VNRecognizeTextRequest { request, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }

                let observations = request.results as? [VNRecognizedTextObservation] ?? []
                let text = observations
                    .compactMap { $0.topCandidates(1).first?.string }
                    .joined(separator: "\n")

                continuation.resume(returning: text)
            }

            request.recognitionLanguages = ["es-MX", "es-ES", "en-US"]
            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = true

            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])

            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    try handler.perform([request])
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private func parseCredentialText(_ text: String) -> ExtractedCredentialData {
        let lines = text
            .components(separatedBy: .newlines)
            .map { $0.trimmed }
            .filter { !$0.isEmpty }

        let normalizedLines = lines.map { $0.normalizedForMatching }
        let normalizedText = text.normalizedForMatching

        var extracted = ExtractedCredentialData()
        extracted.studentNumber = firstMatch(in: normalizedText, pattern: #"\b\d{8,10}\b"#) ?? ""
        extracted.generation = extractGeneration(from: normalizedText)
        extracted.career = detectCareer(from: normalizedText)

        if let nameFromLabel = value(afterAnyLabel: ["nombre", "nombres"], in: lines) {
            extracted.name = cleanupExtractedValue(nameFromLabel)
        }

        if let lastNameFromLabel = value(afterAnyLabel: ["apellidos", "apellido paterno", "apellido materno"], in: lines) {
            extracted.lastName = cleanupExtractedValue(lastNameFromLabel)
        }

        if extracted.name.isEmpty || extracted.lastName.isEmpty {
            if let fullName = detectLikelyFullName(from: lines, normalizedLines: normalizedLines, detectedCareer: extracted.career) {
                let parts = fullName.split(separator: " ").map(String.init)
                if parts.count >= 3 {
                    extracted.name = extracted.name.isEmpty ? parts.dropLast(2).joined(separator: " ") : extracted.name
                    extracted.lastName = extracted.lastName.isEmpty ? parts.suffix(2).joined(separator: " ") : extracted.lastName
                } else if parts.count == 2 {
                    extracted.name = extracted.name.isEmpty ? parts.first ?? "" : extracted.name
                    extracted.lastName = extracted.lastName.isEmpty ? parts.last ?? "" : extracted.lastName
                }
            }
        }

        return extracted
    }

    private func detectCareer(from normalizedText: String) -> Career? {
        Career.unamCareers.first { career in
            let normalizedCareer = career.name.normalizedForMatching
            return normalizedText.contains(normalizedCareer)
        }
    }

    private func extractGeneration(from text: String) -> String {
        firstMatch(in: text, pattern: #"generacion\s*[:\-]?\s*(\d{4}(?:[-/]\d{4})?)"#, group: 1)
        ?? firstMatch(in: text, pattern: #"\b(20\d{2}(?:[-/]20\d{2})?)\b"#)
        ?? ""
    }

    private func detectLikelyFullName(from lines: [String], normalizedLines: [String], detectedCareer: Career?) -> String? {
        for (index, line) in lines.enumerated() {
            let normalized = normalizedLines[index]
            let words = line.split(separator: " ")
            guard words.count >= 3 else { continue }
            guard normalized.range(of: #"^[a-z\s]+$"#, options: .regularExpression) != nil else { continue }
            guard !normalized.contains("universidad") && !normalized.contains("credencial") else { continue }
            guard !normalized.contains("cuenta") && !normalized.contains("generacion") else { continue }
            if let detectedCareer,
               normalized.contains(detectedCareer.name.normalizedForMatching) {
                continue
            }
            return cleanupExtractedValue(line)
        }
        return nil
    }

    private func value(afterAnyLabel labels: [String], in lines: [String]) -> String? {
        let normalizedLines = lines.map { $0.normalizedForMatching }
        for (index, normalizedLine) in normalizedLines.enumerated() {
            if labels.contains(where: { normalizedLine.contains($0) }) {
                if index + 1 < lines.count {
                    return lines[index + 1]
                }
                if let range = normalizedLine.range(of: #":\s*(.+)$"#, options: .regularExpression) {
                    return String(normalizedLine[range]).replacingOccurrences(of: ":", with: "").trimmed
                }
            }
        }
        return nil
    }

    private func cleanupExtractedValue(_ value: String) -> String {
        value
            .replacingOccurrences(of: #"\s+"#, with: " ", options: .regularExpression)
            .trimmed
            .capitalizedSpanish
    }

    private func firstMatch(in text: String, pattern: String, group: Int = 0) -> String? {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]) else {
            return nil
        }

        let nsText = text as NSString
        let range = NSRange(location: 0, length: nsText.length)
        guard let match = regex.firstMatch(in: text, options: [], range: range),
              match.numberOfRanges > group else {
            return nil
        }

        let matchRange = match.range(at: group)
        guard matchRange.location != NSNotFound else { return nil }
        return nsText.substring(with: matchRange)
    }
}

struct CameraImagePicker: UIViewControllerRepresentable {
    let sourceType: UIImagePickerController.SourceType
    let onImagePicked: (UIImage) -> Void

    @Environment(\.dismiss) private var dismiss

    func makeCoordinator() -> Coordinator {
        Coordinator(onImagePicked: onImagePicked, dismiss: dismiss)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        picker.allowsEditing = false
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let onImagePicked: (UIImage) -> Void
        let dismiss: DismissAction

        init(onImagePicked: @escaping (UIImage) -> Void, dismiss: DismissAction) {
            self.onImagePicked = onImagePicked
            self.dismiss = dismiss
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss()
        }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                onImagePicked(image)
            }
            dismiss()
        }
    }
}

private extension String {
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedForMatching: String {
        folding(options: .diacriticInsensitive, locale: .current)
            .lowercased()
    }

    var capitalizedSpanish: String {
        localizedCapitalized
    }
}
