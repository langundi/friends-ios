//
//  AuthViewModel.swift
//  Friends
//
//  Created by Ziqa on 28/07/26.
//

import Foundation
import OSLog

@Observable
final class AuthViewModel {
    
    var isLoading: Bool = false
    var isLoggedIn: Bool {
        get { UserDefaults.standard.bool(forKey: Constants.isUserLoggedIn) }
        set { UserDefaults.standard.set(newValue, forKey: Constants.isUserLoggedIn) }
    }
    
    // Sign Up
    var email = ""
    var username = ""
    var password = ""
    var confirmPassword = ""
    
    var isUsernameValid: Bool {
        username.isEmpty || UsernameValidator.isValid(username)
    }
    
    var isEmailValid: Bool {
        email.isEmpty || EmailValidator.isValid(email)
    }
    
    var unmetPasswordRules: [PasswordRule] {
        PasswordValidator.unmetRules(for: password)
    }
    
    var passwordsMatch: Bool {
        confirmPassword.isEmpty || password == confirmPassword
    }
    
    var canSubmit: Bool {
        isUsernameValid
        && isEmailValid
        && unmetPasswordRules.isEmpty
        && !confirmPassword.isEmpty
        && password == confirmPassword
    }
    
    private let authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    /// Register a new user.
    /// - Parameters:
    ///   - username: User's username.
    ///   - email: User's email.
    ///   - password: User's password.
    func registerUser(completion: @escaping () -> Void) async {
        guard canSubmit else {
            AlertManager.shared.showAlert(title: "An error occured", message: "Please enter your credentials properly.")
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let user = RegisterRequest(username: username, email: email, password: password)
            let result = try await authService.registerUser(request: user)
            Logger.network.info("Registered new user: id: \(result.id), username: \(result.username)")
            completion()
        } catch let networkError as NetworkError {
            AlertManager.shared.showAlert(title: "An error occured", message: networkError.message)
            Logger.network.error("Error registering user: \(networkError.message)")
        } catch {
            if error.isCancellation { return }
            AlertManager.shared.showAlert(title: "An error occured", message: error.localizedDescription)
            Logger.network.error("Error registering user: \(error)")
        }
    }
    
    /// Sign in user.
    /// - Parameters:
    ///   - email: User's email.
    ///   - password: User's password.
    func loginUser(email: String, password: String) async {
        guard EmailValidator.isValid(email) else {
            AlertManager.shared.showAlert(title: "An error occured", message: "Please enter a valid email format.")
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        let user = LoginRequest(email: email, password: password)
        
        do {
            let result = try await authService.loginUser(request: user)
            print(result)
            isLoggedIn = true
        } catch let networkError as NetworkError {
            AlertManager.shared.showAlert(title: "An error occured", message: networkError.message)
            Logger.network.error("Error sign in user: \(networkError.message)")
        } catch {
            if error.isCancellation { return }
            AlertManager.shared.showAlert(title: "An error occured", message: error.localizedDescription)
            Logger.network.error("Error sign in user: \(error)")
        }
    }
    
    func clearField() {
        username = ""
        email = ""
        password = ""
        confirmPassword = ""
    }
}
