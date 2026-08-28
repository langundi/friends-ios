//
//  ChangePasswordScreen.swift
//  Friends
//
//  Created by Ziqa on 26/08/26.
//

import SwiftUI

struct ChangePasswordScreen: View {
    @Environment(AppRouter.self) var router
    @State private var viewModel: ChangePasswordViewModel
    
    init(factory: ViewModelFactory) {
        _viewModel = State(initialValue: factory.makeChangePasswordViewModel())
    }
    
    var body: some View {
        Form {
            Section("Current Password") {
                TextField("", text: $viewModel.currentPassword)
                    .autocorrectionDisabled()
                    .textContentType(.password)
                    .textInputAutocapitalization(.never)
            }
            .listSectionSpacing(48)
            
            Section("New Password") {
                TextField("", text: $viewModel.newPassword)
                    .autocorrectionDisabled()
                    .textContentType(.newPassword)
                    .textInputAutocapitalization(.never)
            }
            .listSectionSpacing(8)
            
            Section {
                TextField("", text: $viewModel.confirmPassword)
                    .autocorrectionDisabled()
                    .textContentType(.newPassword)
                    .textInputAutocapitalization(.never)
            } header: {
                Text("Confirm New Password")
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
            
            Section {
                Button {
                    Task {
                        await viewModel.changePassword {
                            AlertManager.shared.showAlert(
                                title: "Success",
                                message: "Password changed.",
                                action: .init(title: "OK", action: {
                                    router.pop()
                                })
                            )
                        }
                    }
                } label: {
                    Text("Change Password")
                        .fontWeight(.medium)
                }
                .buttonStyle(PrimaryButtonStyle())
                .disabled(!viewModel.canSubmit)
            }
            .removeRowInset()
        }
        .navigationTitle("Change Password")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ChangePasswordScreen(factory: ViewModelFactory())
    }
    .appPreviewEnvironments()
}
