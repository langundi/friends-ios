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
    
    private let authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    /// Register a new user.
    /// - Parameters:
    ///   - username: User's username.
    ///   - email: User's email.
    ///   - password: User's password.
    func registerUser(username: String, email: String, password: String) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let user = RegisterRequest(username: username, email: email, password: password)
            let result = try await authService.registerUser(user: user)
            Logger.network.info("Registered new user: id: \(result.id), username: \(username)")
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
        isLoading = true
        defer { isLoading = false }
        
        let user = LoginRequest(email: email, password: password)
        
        do {
            let result = try await authService.loginUser(user: user)
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
}
