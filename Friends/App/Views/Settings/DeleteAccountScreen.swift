//
//  DeleteAccountScreen.swift
//  Friends
//
//  Created by Ziqa on 29/08/26.
//

import SwiftUI

struct DeleteAccountScreen: View {
    @State private var viewModel: DeleteAccountViewModel
    @State private var username: String = ""
    
    private var isUsernameMatch: Bool {
        username == viewModel.username
    }
    
    init(factory: ViewModelFactory) {
        _viewModel = State(initialValue: factory.makeDeleteAccountViewModel())
    }
    
    var body: some View {
        Form {
            Section {
                TextField(viewModel.username, text: $username)
                    .textCase(.lowercase)
                    .textContentType(.username)
                    .textInputAutocapitalization(.never)
            } header: {
                Text("Please type your username")
            } footer: {
                Text("Deleting your account will also delete all your posts, replies, and removes you from your friends's friend list.")
            }
            
            Section {
                Button {
                    AlertManager.shared.showAlert(
                        title: "Delete Account",
                        message: "Are you sure you want to delete your account?",
                        primaryAction: .init(title: "Yes", action: {
                            Task {
                                await viewModel.deleteAccount()
                            }
                    }), secondaryAction: .init(title: "Cancel"))
                } label: {
                    Text("Delete Account")
                }
                .buttonStyle(DeleteButtonStyle())
                .disabled(!isUsernameMatch)
                .removeRowInset()
            }
        }
        .navigationTitle("Delete Account")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    DeleteAccountScreen(factory: ViewModelFactory())
}
