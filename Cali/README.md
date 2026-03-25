# CALI — Tu Aliado Académico en la UNAM

**C**arrera · **A**liado · **C**álido

Una app iOS 18+ con Apple Intelligence que acompaña al alumno de la UNAM desde el primer día hasta la titulación.

---

## Funcionalidades

| Pantalla | Descripción |
|---|---|
| **Onboarding** | 4 pasos: bienvenida → datos personales → selección de carrera → semestre actual |
| **Principal** | Greeting dinámico, tarjeta de progreso de titulación, 4 acciones rápidas y tip del día |
| **Perfil** | Muestra todos los datos del usuario, estadísticas y resultados del cuestionario |
| **CALI IA** | Chat con Apple Intelligence (FoundationModels); fallback automático si no está disponible |
| **Checklist** | Lista de requisitos de titulación UNAM con progreso circular; se puede marcar/desmarcar |
| **Horario** | Vista lista + cuadrícula semanal; catálogo de materias con filtros por semestre |
| **Cuestionario** | Pop-up obligatorio (no swipeable) que ayuda a orientar la carrera del alumno |

---

## Estructura del proyecto

```
CALI/
├── CALIApp.swift               ← @main, entry point
├── ContentView.swift           ← Router onboarding ↔ tabs
├── Models/
│   ├── UserProfile.swift
│   ├── Career.swift            ← 20 carreras UNAM con duración y créditos
│   ├── ChecklistItem.swift     ← 10 requisitos UNAM + categorías
│   └── Subject.swift           ← Materia + ScheduleSlot + WeekDay
├── ViewModels/
│   └── AppViewModel.swift      ← @MainActor ObservableObject, lógica central
├── Services/
│   ├── AICompanionService.swift ← Apple Intelligence (FoundationModels) + fallback
│   └── DataService.swift       ← Mock API de materias (reemplazable con URLSession)
└── Views/
    ├── Onboarding/OnboardingView.swift
    ├── Main/
    │   ├── MainTabView.swift
    │   └── PrincipalView.swift
    ├── Chat/ChatView.swift
    ├── Profile/PerfilView.swift
    ├── Questionnaire/QuestionnaireView.swift
    ├── Checklist/ChecklistView.swift
    └── Schedule/ScheduleView.swift
```

---

## Setup en Xcode

### 1. Crear el proyecto

1. Abre Xcode → **File › New › Project…**
2. Elige **iOS › App**.
3. Configura:
   - **Product Name:** `CALI`
   - **Bundle ID:** `mx.unam.cali` (o el tuyo)
   - **Interface:** SwiftUI
   - **Language:** Swift
4. Clic en **Next** y elige la carpeta donde guardaste estos archivos.

### 2. Agregar los archivos fuente

1. En el Navigator, selecciona el grupo `CALI`.
2. **File › Add Files to "CALI"…**
3. Selecciona toda la carpeta `CALI/` (que contiene esta estructura), marca **"Create groups"** y confirma.
4. Elimina el `ContentView.swift` y `<AppName>App.swift` que Xcode generó automáticamente, ya que esta carpeta contiene los tuyos.

### 3. Deployment target

- En **Project settings › CALI target › General › Minimum Deployments**, establece **iOS 18.0** (o iOS 26 una vez disponible).

### 4. Habilitar Apple Intelligence

Para que `FoundationModels` funcione:

1. Ve a **Signing & Capabilities › + Capability** y agrega **"Machine Learning"** si aparece.
2. En `Info.plist`, no se requiere configuración adicional; `FoundationModels` es un framework del sistema.
3. Prueba en un dispositivo físico con Apple Intelligence habilitado (iPhone 15 Pro+ o iPhone 16 series, región compatible, iOS 18.1+).
4. En simulador o dispositivo sin Apple Intelligence, el `AICompanionService` cae al modo fallback automáticamente.

### 5. Reemplazar el mock API con una API real

Cuando tengas el endpoint real de materias:

```swift
// En DataService.swift, reemplaza getSubjects(for:) con:
func fetchSubjects(for careerName: String) async throws -> [Subject] {
    let url = URL(string: "https://tu-api.unam.mx/subjects?career=\(careerName)")!
    let (data, _) = try await URLSession.shared.data(from: url)
    return try JSONDecoder().decode([Subject].self, from: data)
}
```

Y actualiza `SubjectCatalogView` para llamar a esta función con `.task { }`.

---

## Notas de diseño

- **Cuestionario obligatorio:** `interactiveDismissDisabled(true)` evita que se cierre con swipe; el botón ✕ llama a `dismissQuestionnaire()` sin guardar respuestas.
- **Persistencia:** `UserDefaults` + `Codable`. Para producción considera Core Data o SwiftData.
- **FoundationModels:** La instrucción de sistema se pasa como `instructions:` al `LanguageModelSession`. El modelo corre completamente on-device, sin costo de API.
- **Colores del horario semanal:** Generados de forma determinista por el hash del nombre de la materia.

---

## Roadmap sugerido

- [ ] Integrar API real de UNAM para materias y horarios
- [ ] SwiftData para persistencia robusta
- [ ] Notificaciones locales para recordar trámites pendientes
- [ ] Widget de progreso de titulación
- [ ] Modo oscuro refinado con color assets personalizados
- [ ] Soporte para múltiples carreras simultáneas (doble titulación)
