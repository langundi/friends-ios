//
//  EditProfileScreen.swift
//  Friends
//
//  Created by Ziqa on 26/08/26.
//

import SwiftUI

struct EditProfileScreen: View {
    @State private var viewModel: EditProfileViewModel
    @State private var isEditingProfilePicture: Bool = false
    @State private var isEditingUsername: Bool = false
    @State private var isEditingEmail: Bool = false
    
    init(factory: ViewModelFactory) {
        _viewModel = State(initialValue: factory.makeEditProfileViewModel())
    }
    
    var body: some View {
        Form {
            Section {
                Button {
                    isEditingProfilePicture.toggle()
                } label: {
                    ProfilePictureView(imageURL: viewModel.profilePicture, size: .xlarge)
                        .overlay(alignment: .topTrailing) {
                            Image(systemName: "pencil")
                                .font(.title)
                                .offset(x: 5, y: -5)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        
                }
                .buttonStyle(.plain)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            .listSectionSpacing(8)
            
            if let _ = viewModel.profilePicture {
                Section {
                    Button {
                        
                    } label: {
                        Text("Remove Profile Picture")
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .removeRowInset()
                }
            }
            
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
        .sheet(isPresented: $isEditingProfilePicture) {
            SetProfilePictureSheet(viewModel: viewModel)
        }
        .sheet(isPresented: $isEditingUsername) {
            EditUsernameSheet(viewModel: viewModel, oldUsername: viewModel.username)
        }
        .sheet(isPresented: $isEditingEmail) {
            EditEmailSheet(viewModel: viewModel, oldEmail: viewModel.email)
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

#Preview {
    NavigationStack {
        EditProfileScreen(factory: ViewModelFactory())
    }
    .appPreviewEnvironments()
}
