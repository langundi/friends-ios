//
//  ChangePasswordViewModel.swift
//  Friends
//
//  Created by Ziqa on 28/08/26.
//

import Foundation
import OSLog

@Observable
final class ChangePasswordViewModel {
    
    var isLoading: Bool = false
    var currentPassword = ""
    var newPassword = ""
    var confirmPassword = ""
    
    var unmetPasswordRules: [PasswordRule] {
        PasswordValidator.unmetRules(for: newPassword)
    }
    
    var passwordsMatch: Bool {
        confirmPassword.isEmpty || newPassword == confirmPassword
    }
    
    var canSubmit: Bool {
        unmetPasswordRules.isEmpty
        && !confirmPassword.isEmpty
        && newPassword == confirmPassword
    }
    
    private let userStore: UserStore
    
    init(userStore: UserStore) {
        self.userStore = userStore
    }
    
    func changePassword(completion: @escaping () -> Void) async {
        guard !currentPassword.isEmpty else {
            AlertManager.shared.showAlert(title: "An error occured", message: "Please enter your current password.")
            return
        }
        
        guard passwordsMatch else {
            AlertManager.shared.showAlert(title: "An error occured", message: "New password and confirm password does not match.")
            return
        }

        isLoading = true
        defer { isLoading = false }
        
        do {
            let request = ChangePasswordRequest(email: userStore.email, currentPassword: currentPassword, newPassword: newPassword)
            try await userStore.changePassword(request: request)
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
    
}
