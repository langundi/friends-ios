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
    private let deviceService: DeviceService
    
    init(authService: AuthService, deviceService: DeviceService) {
        self.authService = authService
        self.deviceService = deviceService
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
        
        do {
            let loginRequest = LoginRequest(email: email, password: password)
            let result = try await authService.loginUser(request: loginRequest)
            
            setAccessAndRefreshTokensKeychain(accessToken: result.accessToken, refreshToken: result.refreshToken)
            
            try await Task.sleep(for: .seconds(1))
            
            if let deviceToken = UserDefaults.standard.string(forKey: Constants.deviceToken) {
                let deviceRequest = DeviceTokenRequest(deviceToken: deviceToken)
                try await deviceService.registerDeviceToken(request: deviceRequest)
            }
            
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
    
    func registerDevice() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            if let deviceToken = UserDefaults.standard.string(forKey: Constants.deviceToken) {
                let deviceRequest = DeviceTokenRequest(deviceToken: deviceToken)
                try await deviceService.registerDeviceToken(request: deviceRequest)
            }
        } catch let networkError as NetworkError {
            AlertManager.shared.showAlert(title: "An error occured", message: networkError.message)
            Logger.network.error("Error registering device: \(networkError.message)")
        } catch {
            if error.isCancellation { return }
            AlertManager.shared.showAlert(title: "An error occured", message: error.localizedDescription)
            Logger.network.error("Error registering device: \(error)")
        }
    }
    
    func setAccessAndRefreshTokensKeychain(accessToken: String, refreshToken: String) {
        try? Keychain.set(accessToken, Constants.accessToken)
        try? Keychain.set(refreshToken, Constants.refreshToken)
    }
    
    func clearField() {
        username = ""
        email = ""
        password = ""
        confirmPassword = ""
    }
}
