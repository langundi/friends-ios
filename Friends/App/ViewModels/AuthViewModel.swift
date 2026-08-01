//
//  AuthViewModel.swift
//  Friends
//
//  Created by Ziqa on 28/07/26.
//

import Foundation

@Observable
final class AuthViewModel {
    private let authService = AuthService.shared
    private let alertManager = AlertManager.shared
    private let defaults = UserDefaults.standard
    
    var isLoading: Bool = false
    var isLoggedIn: Bool {
        get { defaults.bool(forKey: Constants.isUserLoggedIn) }
        set { defaults.set(newValue, forKey: Constants.isUserLoggedIn) }
    }
    
    func registerUser(username: String, email: String, password: String) async {
        isLoading = true
        defer { isLoading = false }
        
        let user = RegisterRequest(username: username, email: email, password: password)
        
        do {
            let response = try await authService.registerUser(user: user)
            print(response)
        } catch let networkError as NetworkError {
            alertManager.showAlert(
                title: "An error occured",
                message: networkError.message
            )
        } catch {
            alertManager.showAlert(
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
            alertManager.showAlert(
                title: "An error occured",
                message: networkError.message
            )
        } catch {
            alertManager.showAlert(
                title: "An error occured",
                message: error.localizedDescription
            )
        }
    }
}
