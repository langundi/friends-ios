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
    
    var isOldUsername: Bool {
        newUsername == viewModel.username
    }
    
    init(viewModel: EditProfileViewModel, oldUsername: String) {
        self.viewModel = viewModel
        self.oldUsername = oldUsername
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField(oldUsername, text: $newUsername)
                    .autocorrectionDisabled()
                    .textCase(.lowercase)
                    .textContentType(.username)
                    .textInputAutocapitalization(.never)
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
                            await viewModel.updateUsername(username: newUsername) {
                                dismiss()
                            }
                        }
                    } label: {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.white)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(isOldUsername)
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
