//
//  AuthViewModel.swift
//  Friends
//
//  Created by Ziqa on 28/07/26.
//

import Foundation

@Observable
final class AuthViewModel {
    private let authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    var isLoading: Bool = false
    var isLoggedIn: Bool {
        get { UserDefaults.standard.bool(forKey: Constants.isUserLoggedIn) }
        set { UserDefaults.standard.set(newValue, forKey: Constants.isUserLoggedIn) }
    }
    
    func registerUser(username: String, email: String, password: String) async {
        isLoading = true
        defer { isLoading = false }
        
        let user = RegisterRequest(username: username, email: email, password: password)
        
        do {
            let response = try await authService.registerUser(user: user)
            print(response)
        } catch let networkError as NetworkError {
            AlertManager.shared.showAlert(
                title: "An error occured",
                message: networkError.message
            )
        } catch {
            AlertManager.shared.showAlert(
                title: "An error occured",
                message: error.localizedDescription
            )
        }
    }
    
    func loginUser(email: String, password: String) async {
        isLoading = true
        defer { isLoading = false }
        
        let user = LoginRequest(email: email, password: password)
        
        do {
            let response = try await authService.loginUser(user: user)
            print(response)
            isLoggedIn = true
        } catch let networkError as NetworkError {
            AlertManager.shared.showAlert(
                title: "An error occured",
                message: networkError.message
            )
        } catch {
            AlertManager.shared.showAlert(
                title: "An error occured",
                message: error.localizedDescription
            )
        }
    }
}
