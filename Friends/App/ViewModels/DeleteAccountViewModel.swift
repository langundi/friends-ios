//
//  DeleteAccountViewModel.swift
//  Friends
//
//  Created by Ziqa on 29/08/26.
//

import Foundation
import OSLog

@Observable
final class DeleteAccountViewModel {
    
    var isLoading: Bool = false
    
    var username: String {
        userStore.username
    }
    
    private var isLoggedIn: Bool {
        get { UserDefaults.standard.bool(forKey: Constants.isUserLoggedIn) }
        set { UserDefaults.standard.set(newValue, forKey: Constants.isUserLoggedIn) }
    }
    
    private let userStore: UserStore
    
    init(userStore: UserStore) {
        self.userStore = userStore
    }
    
    /// Delete user's account.
    func deleteAccount() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await userStore.deleteAccount()
            deleteTokensFromKeychain()
            isLoggedIn = false
        } catch let networkError as NetworkError {
            AlertManager.shared.showAlert(title: "An error occured", message: networkError.message)
            Logger.network.error("Error deleting account: \(networkError)")
        } catch {
            if error.isCancellation { return }
            AlertManager.shared.showAlert(title: "An error occured", message: error.localizedDescription)
            Logger.network.error("Error deleting account: \(error)")
        }
    }
    
    private func deleteTokensFromKeychain() {
        _ = Keychain.delete(Constants.accessToken)
        _ = Keychain.delete(Constants.refreshToken)
    }
    
}
