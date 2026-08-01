//
//  ProfileViewModel.swift
//  Friends
//
//  Created by Ziqa on 01/08/26.
//

import Foundation

@Observable
final class ProfileViewModel {
    private let authService = AuthService.shared
    private let alertManager = AlertManager.shared
    private let defaults = UserDefaults.standard
    
    var isLoading: Bool = false
    var isLoggedIn: Bool {
        get { defaults.bool(forKey: Constants.isUserLoggedIn) }
        set { defaults.set(newValue, forKey: Constants.isUserLoggedIn) }
    }
    
    func signOutUser() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            guard let refreshToken: String = try? Keychain.get(Constants.refreshToken) else {
                isLoggedIn = false
                throw NetworkError.sessionExpired
            }
            
            let refresh = RefreshRequest(refreshToken: refreshToken)
            try await authService.logoutUser(refresh: refresh)
            
            _ = Keychain.delete(Constants.accessToken)
            _ = Keychain.delete(Constants.refreshToken)
            
            isLoggedIn = false
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
