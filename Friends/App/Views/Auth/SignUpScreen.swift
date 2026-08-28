//
//  SignUpScreen.swift
//  Friends
//
//  Created by Ziqa on 28/07/26.
//

import SwiftUI

struct SignUpScreen: View {
    @Environment(AuthRouter.self) var router
    @State private var viewModel: AuthViewModel
    
    init(factory: ViewModelFactory) {
        _viewModel = State(initialValue: factory.makeAuthViewModel())
    }
    
    var body: some View {
        Form {
            Group {
                Section {
                    TextField("username", text: $viewModel.username)
                        .textContentType(.username)
                } header: {
                    Text("Username")
                } footer: {
                    if !viewModel.isUsernameValid {
                        Text("3-20 chars, lowecase letters/digits")
                            .foregroundStyle(.red)
                    }
                }
                
                Section {
                    TextField("", text: $viewModel.email, prompt: Text(verbatim: "you@example.com"))
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                } header: {
                    Text("Email")
                } footer: {
                    if !viewModel.isEmailValid {
                        Text("Please enter a valid email address format")
                            .foregroundStyle(.red)
                    }
                }
                
                Section {
                    TextField("Password", text: $viewModel.password)
                        .textContentType(.password)
                    
                    TextField("Re-type password", text: $viewModel.confirmPassword)
                        .textContentType(.password)
                } header: {
                    Text("Password")
                } footer: {
                    VStack(alignment: .leading) {
                        if !viewModel.unmetPasswordRules.isEmpty {
                            Text("Password must contain:")
                            
                            ForEach(viewModel.unmetPasswordRules, id: \.description) { rule in
                                Text("- \(rule.description)")
                            }
                        } else if !viewModel.passwordsMatch {
                            Text("Password don't match")
                                .foregroundStyle(.red)
                        }
                    }
                }
            }
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            
            Section {
                Button {
                    Task {
                        await viewModel.registerUser() {
                            AlertManager.shared.showAlert(
                                title: "Success",
                                message: "Registration succesful! You can sign in to your account.",
                                action: .init(title: "OK", action: {
                                    viewModel.clearField()
                                    router.pop()
                                })
                            )
                        }
                    }
                } label: {
                    Text("Sign Up")
                }
                .buttonStyle(PrimaryButtonStyle())
                .disabled(!viewModel.canSubmit)
                .removeRowInset()
            }
            
            Section {
                Button {
                    router.popToRoot()
                } label: {
                    Text("Already have an account?")
                        .frame(maxWidth: .infinity, maxHeight: 45, alignment: .center)
                }
                .listRowBackground(Color.clear)
            }
        }
        .navigationTitle("Create Account")
        .overlay(alignment: .center) {
            if viewModel.isLoading {
                LoadingOverlay()
            }
        }
    }
}

#Preview {
    SignUpScreen(factory: ViewModelFactory())
        .authPreviewEnvironments()
}
