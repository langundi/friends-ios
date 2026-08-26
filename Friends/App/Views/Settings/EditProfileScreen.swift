//
//  EditProfileScreen.swift
//  Friends
//
//  Created by Ziqa on 26/08/26.
//

import SwiftUI

struct EditProfileScreen: View {
    @State private var viewModel: EditProfileViewModel
    @State private var isEditingUsername: Bool = false
    @State private var isEditingEmail: Bool = false
    
    init(factory: ViewModelFactory) {
        _viewModel = State(initialValue: factory.makeEditProfileViewModel())
    }
    
    var body: some View {
        Form {
            Section("Username") {
                Button {
                    isEditingUsername.toggle()
                } label: {
                    ProfileRowView(field: "@\(viewModel.username)")
                }
                .buttonStyle(.plain)
            }
            
            Section("Email") {
                Button {
                    isEditingEmail.toggle()
                } label: {
                    ProfileRowView(field: viewModel.email)
                }
                .buttonStyle(.plain)
            }
        }
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isEditingUsername) {
            EditUsernameSheet(value: viewModel.username)
        }
        .sheet(isPresented: $isEditingEmail) {
            EditEmailSheet(value: viewModel.email)
        }
    }
}

struct ProfileRowView: View {
    var field: String
    
    var body: some View {
        HStack(spacing: 16) {
            Text(field)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
        }
        .contentShape(.rect)
    }
}

enum ProfileField: String {
    case username = "Username"
    case email = "Email"
}

#Preview {
    NavigationStack {
        EditProfileScreen(factory: ViewModelFactory())
    }
    .withPreviewEnvironments()
}
