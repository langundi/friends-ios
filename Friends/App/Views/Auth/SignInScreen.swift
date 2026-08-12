//
//  SignInScreen.swift
//  Friends
//
//  Created by Ziqa on 28/07/26.
//

import SwiftUI

struct SignInScreen: View {
    @Environment(AuthRouter.self) var router
    @Environment(AuthViewModel.self) var viewModel
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        Form {
            Section {
                Text("Sign in with your account")
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .removeRowInset()
            
            Section {
                TextField("Email", text: $email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                
                SecureField("Password", text: $password)
                    .textContentType(.password)
            }
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            
            Section {
                Button("Forgot password?") {
                    
                }
                .padding(.leading, 12)
            }
            .removeRowInset()
            .listSectionSpacing(12)
            
            Section {
                Button {
                    Task {
                        await viewModel.loginUser(email: email, password: password)
                    }
                } label: {
                    Text("Sign In")
                }
                .buttonStyle(PrimaryButtonStyle())
            }
            .removeRowInset()
            
            Section {
                Button {
                    router.push(to: .signUp)
                } label: {
                    Text("Don't have an account yet?")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .listRowBackground(Color.clear)
        }
        .overlay(alignment: .center) {
            if viewModel.isLoading {
                LoadingOverlay()
            }
        }
    }
}

#Preview {
    ContentView()
        .withPreviewEnvironments()
}
