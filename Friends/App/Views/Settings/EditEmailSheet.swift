//
//  EditEmailSheet.swift
//  Friends
//
//  Created by Ziqa on 26/08/26.
//

import SwiftUI

struct EditEmailSheet: View {
    @Environment(\.dismiss) var dismiss
    let viewModel: EditProfileViewModel
    let oldEmail: String
    @State var newEmail: String = ""
    
    init(viewModel: EditProfileViewModel, oldEmail: String) {
        self.viewModel = viewModel
        self.oldEmail = oldEmail
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField(oldEmail, text: $newEmail)
                    .autocorrectionDisabled()
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
            }
            .navigationTitle("Email")
            .navigationBarTitleDisplayMode(.inline)
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
                            await viewModel.updateEmail(email: newEmail) {
                                dismiss()
                            }
                        }
                    } label: {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.white)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
}

#Preview {
    EditEmailSheet(viewModel: EditProfileViewModel.mockVM, oldEmail: "dorami@mail.com")
}
