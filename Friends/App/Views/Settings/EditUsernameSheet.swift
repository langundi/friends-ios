//
//  EditUsernameSheet.swift
//  Friends
//
//  Created by Ziqa on 26/08/26.
//

import SwiftUI

struct EditUsernameSheet: View {
    @Environment(\.dismiss) var dismiss
    let viewModel: EditProfileViewModel
    let oldUsername: String
    @State private var newUsername: String = ""
    
    init(viewModel: EditProfileViewModel, oldUsername: String) {
        self.viewModel = viewModel
        self.oldUsername = oldUsername
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField(oldUsername, text: $newUsername)
                        .autocorrectionDisabled()
                        .textCase(.lowercase)
                        .textContentType(.username)
                        .textInputAutocapitalization(.never)
                } footer: {
                    VStack {
                        Text("Username can contain \".\" or \"_\" and must be lowercased.")
                    }
                }
            }
            .navigationTitle("Username")
            .navigationBarTitleDisplayMode(.inline)
            .overlay(alignment: .center) {
                if viewModel.isLoading {
                    LoadingOverlay()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task {
                            await viewModel.changeUsername(username: newUsername) {
                                dismiss()
                            }
                        }
                    } label: {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.white)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(newUsername.isEmpty)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        EditUsernameSheet(viewModel: EditProfileViewModel.mockVM, oldUsername: "dorami")
    }
}
