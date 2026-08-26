//
//  SettingsViewModel.swift
//  Friends
//
//  Created by Ziqa on 26/08/26.
//

import Foundation
import OSLog

@Observable
final class SettingsViewModel {
    
    var isLoading: Bool = false
    
    private var isLoggedIn: Bool {
        get { UserDefaults.standard.bool(forKey: Constants.isUserLoggedIn) }
        set { UserDefaults.standard.set(newValue, forKey: Constants.isUserLoggedIn) }
    }
    
    private let authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    /// Sign out user and delete access and refresh tokens from keychain.
    func signOutUser() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            guard let refreshToken: String = try? Keychain.get(Constants.refreshToken) else {
                isLoggedIn = false
                throw NetworkError.sessionExpired
            }
            
            let refresh = RefreshRequest(refreshToken: refreshToken)
            try await authService.logoutUser(request: refresh)
            
            deleteTokensFromKeychain()
            
            isLoggedIn = false
        } catch let networkError as NetworkError {
            AlertManager.shared.showAlert(title: "An error occured", message: networkError.message)
            Logger.network.error("Error signing out: \(networkError.message)")
        } catch {
            if error.isCancellation { return }
            AlertManager.shared.showAlert(title: "An error occured", message: error.localizedDescription)
            Logger.network.error("Error signing out: \(error)")
        }
    }
    
    private func deleteTokensFromKeychain() {
        _ = Keychain.delete(Constants.accessToken)
        _ = Keychain.delete(Constants.refreshToken)
    }
    
}
