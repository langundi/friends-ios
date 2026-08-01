//
//  SignUpScreen.swift
//  Friends
//
//  Created by Ziqa on 28/07/26.
//

import SwiftUI

struct SignUpScreen: View {
    @Environment(AppRouter.self) var router
    @Environment(AlertManager.self) var alert
    @State private var viewmodel = AuthViewModel()
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        Form {
            Section {
                TextField("Username", text: $username)
                
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                
                TextField("Password", text: $password)
            }
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            
            Section {
                Button {
                    Task {
                        await viewmodel.registerUser(
                            username: username,
                            email: email,
                            password: password
                        )
                    }
                } label: {
                    Text("Sign Up")
                }
                .buttonStyle(PrimaryButtonStyle())
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
            if viewmodel.isLoading {
                LoadingOverlay()
            }
        }
    }
}

#Preview {
    SignUpScreen()
        .withPreviewEnvironments()
}
