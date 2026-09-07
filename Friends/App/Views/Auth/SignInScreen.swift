//
//  SignInScreen.swift
//  Friends
//
//  Created by Ziqa on 28/07/26.
//

import SwiftUI

struct SignInScreen: View {
    @Environment(AuthRouter.self) var router
    @State private var viewModel: AuthViewModel
    @State private var email: String = ""
    @State private var password: String = ""
    
    init(factory: ViewModelFactory) {
        _viewModel = State(initialValue: factory.makeAuthViewModel())
    }
    
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
                    router.push(to: .forgotPassword)
                }
                .padding(.leading, 12)
            }
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
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
    SignInScreen(factory: ViewModelFactory())
        .authPreviewEnvironments()
        
}
