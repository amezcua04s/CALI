//
//  LogInView.swift
//  Cali
//
//  Created by Santi on 25/03/26.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @Environment(\.dismiss) var dismiss
    
    var onRegister: (() -> Void)?
    
    @State private var identifier = "" // Puede ser correo o número de cuenta
    @State private var password = ""
    @State private var isPasswordVisible = false
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            ZStack {
                // Fondo consistente con Onboarding
                LinearGradient(colors: [Color.blue.opacity(0.07), Color.white],
                               startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 32) {
                        // Header / Logo
                        VStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(LinearGradient(colors: [.principal, .secundario],
                                                         startPoint: .topLeading,
                                                         endPoint: .bottomTrailing))
                                    .frame(width: 100, height: 100)
                                Text("C")
                                    .font(.system(size: 52, weight: .bold, design: .rounded))
                                    .foregroundStyle(.white)
                            }
                            .shadow(color: .yellow.opacity(0.4), radius: 15, y: 8)
                            
                            VStack(spacing: 8) {
                                Text("Bienvenido de nuevo")
                                    .font(.largeTitle).fontWeight(.bold)
                                Text("Ingresa tus datos para continuar con tu plan de titulación")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 40)
                            }
                        }
                        .padding(.top, 40)

                        // Formulario
                        VStack(spacing: 20) {
                            CALITextField(
                                title: "Correo UNAM o Número de Cuenta",
                                placeholder: "ej. 420123456",
                                text: $identifier,
                                icon: "person.circle",
                                keyboardType: .emailAddress
                            )
                            
                            // Campo de contraseña personalizado
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Contraseña")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                
                                HStack {
                                    Image(systemName: "lock")
                                        .foregroundStyle(.blue)
                                        .frame(width: 20)
                                    
                                    Group {
                                        if isPasswordVisible {
                                            TextField("Tu contraseña", text: $password)
                                        } else {
                                            SecureField("Tu contraseña", text: $password)
                                        }
                                    }
                                    .textInputAutocapitalization(.none)
                                    
                                    Button { isPasswordVisible.toggle() } label: {
                                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                            .foregroundStyle(.gray)
                                    }
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(14)
                                .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
                            }
                            
                            Button {
                                // Acción de recuperar contraseña
                            } label: {
                                Text("¿Olvidaste tu contraseña?")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.blue)
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .padding(.horizontal, 24)

                        if let errorMessage {
                            Text(errorMessage)
                                .font(.caption)
                                .foregroundStyle(.red)
                                .padding(.horizontal)
                        }

                        // Botón de Inicio (Área de clic completa)
                        VStack(spacing: 16) {
                            Button {
                                performLogin()
                            } label: {
                                HStack {
                                    if isLoading {
                                        ProgressView().tint(.white)
                                    } else {
                                        Text("Iniciar Sesión")
                                            .fontWeight(.bold)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(canLogin ? Color.blue : Color.gray.opacity(0.3))
                                .foregroundStyle(.white)
                                .cornerRadius(16)
                            }
                            .disabled(!canLogin || isLoading)

                            Button {
                                onRegister?()
                                dismiss()
                            } label: {
                                Text("¿No tienes cuenta? Regístrate")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 18)
                                    .background(Color.blue.opacity(0.05))
                                    .foregroundStyle(.blue)
                                    .cornerRadius(16)
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cerrar") { dismiss() }
                }
            }
        }
    }

    private var canLogin: Bool {
        !identifier.isEmpty && password.count >= 6
    }

    private func performLogin() {
        isLoading = true
        errorMessage = nil
        
        // Simulación de autenticación
        Task {
            try? await Task.sleep(nanoseconds: 1_500_000_000)
            await MainActor.run {
                isLoading = false

                dismiss()
            }
        }
    }
}

// Preview
#Preview {
    LoginView()
        .environmentObject(AppViewModel())
}
