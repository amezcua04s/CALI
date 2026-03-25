import SwiftUI

// MARK: - ChatView
// Full-screen AI companion powered by Apple Intelligence (FoundationModels).

struct ChatView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @Environment(\.dismiss) var dismiss

    @State private var messageText = ""
    @FocusState private var isInputFocused: Bool

    private let suggestedPrompts = [
        "¿Qué necesito para titularme?",
        "¿Cuándo puedo hacer mi servicio social?",
        "¿Cuáles son mis opciones de titulación?",
        "Ayúdame a organizar mis materias"
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {

                // ── Message list ────────────────────────────────
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            if appViewModel.chatMessages.isEmpty {
                                WelcomeChatCard(
                                    name: appViewModel.userProfile.name,
                                    prompts: suggestedPrompts
                                ) { send($0) }
                                .padding()
                                .id("welcome")
                            }

                            ForEach(appViewModel.chatMessages) { msg in
                                MessageBubble(message: msg)
                                    .id(msg.id)
                            }

                            if appViewModel.isAIThinking {
                                TypingIndicator().id("typing")
                            }
                        }
                        .padding(.vertical)
                    }
                    .onChange(of: appViewModel.chatMessages.count) { _, _ in
                        withAnimation {
                            if let last = appViewModel.chatMessages.last {
                                proxy.scrollTo(last.id, anchor: .bottom)
                            }
                        }
                    }
                    .onChange(of: appViewModel.isAIThinking) { _, thinking in
                        if thinking { withAnimation { proxy.scrollTo("typing", anchor: .bottom) } }
                    }
                }

                Divider()

                // ── Input bar ───────────────────────────────────
                HStack(spacing: 10) {
                    TextField("Pregúntame algo…", text: $messageText, axis: .vertical)
                        .lineLimit(1...4)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(20)
                        .focused($isInputFocused)

                    Button { send(messageText) } label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 32))
                            .foregroundStyle(
                                messageText.trimmingCharacters(in: .whitespaces).isEmpty
                                    ? AnyShapeStyle(.gray) : AnyShapeStyle(.blue)
                            )
                    }
                    .disabled(
                        messageText.trimmingCharacters(in: .whitespaces).isEmpty ||
                        appViewModel.isAIThinking
                    )
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(Color.white)
            }
            .navigationTitle("CALI IA")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { appViewModel.chatMessages = [] } label: {
                        Image(systemName: "trash")
                            .foregroundStyle(.secondary)
                    }
                    .disabled(appViewModel.chatMessages.isEmpty)
                }
            }
        }
    }

    private func send(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        messageText = ""
        isInputFocused = false
        Task { await appViewModel.sendMessage(trimmed) }
    }
}

// MARK: - Welcome Card

struct WelcomeChatCard: View {
    let name: String
    let prompts: [String]
    let onSelect: (String) -> Void

    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 10) {
                CALIAvatar(size: 64)
                Text("¡Hola\(name.isEmpty ? "" : ", \(name)")!")
                    .font(.title3).fontWeight(.bold)
                Text("Soy CALI, tu aliado académico. Puedo ayudarte con titulación, materias, servicio social y orientación en tu carrera.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Empieza con…").font(.subheadline).fontWeight(.semibold)
                ForEach(prompts, id: \.self) { prompt in
                    Button { onSelect(prompt) } label: {
                        HStack {
                            Text(prompt).font(.subheadline).foregroundStyle(Color.primary)
                            Spacer()
                            Image(systemName: "arrow.right").font(.caption).foregroundStyle(.blue)
                        }
                        .padding()
                        .background(Color.blue.opacity(0.06))
                        .cornerRadius(12)
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
}

// MARK: - Message Bubble

struct MessageBubble: View {
    let message: ChatMessage
    private var isUser: Bool { message.role == .user }

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if !isUser { CALIAvatar(size: 30) }
            if isUser { Spacer(minLength: 56) }

            Text(message.content)
                .font(.subheadline)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(isUser ? Color.blue : Color.white)
                .foregroundStyle(isUser ? Color.white : Color.primary)
                .cornerRadius(18)
                .shadow(color: isUser ? .clear : .black.opacity(0.05), radius: 4, x: 0, y: 2)

            if !isUser { Spacer(minLength: 56) }
        }
        .padding(.horizontal)
    }
}

// MARK: - Typing Indicator

struct TypingIndicator: View {
    @State private var animating = false

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            CALIAvatar(size: 30)
            HStack(spacing: 5) {
                ForEach(0..<3, id: \.self) { i in
                    Circle()
                        .fill(Color.gray.opacity(0.7))
                        .frame(width: 7, height: 7)
                        .scaleEffect(animating ? 1.1 : 0.5)
                        .animation(
                            .easeInOut(duration: 0.55)
                                .repeatForever()
                                .delay(Double(i) * 0.18),
                            value: animating
                        )
                }
            }
            .padding(.horizontal, 14).padding(.vertical, 13)
            .background(Color.white)
            .cornerRadius(18)
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
            Spacer(minLength: 56)
        }
        .padding(.horizontal)
        .onAppear { animating = true }
    }
}

// MARK: - CALI Avatar (reusable)

struct CALIAvatar: View {
    let size: CGFloat

    var body: some View {
        ZStack {
            Circle()
                .fill(LinearGradient(colors: [.blue, .purple],
                                    startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: size, height: size)
            Text("C")
                .font(.system(size: size * 0.45, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
        }
    }
}
