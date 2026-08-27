//
//  EditProfileViewModel.swift
//  Friends
//
//  Created by Ziqa on 26/08/26.
//

import Foundation
import OSLog

@Observable
final class EditProfileViewModel {
    
    var isLoading: Bool = false
    
    var username: String {
        userStore.username
    }
    
    var email: String {
        userStore.email
    }
    
    private let userStore: UserStore
    
    init(userStore: UserStore) {
        self.userStore = userStore
    }
    
    /// Update current user's username.
    /// - Parameter username: New username.
    /// - Parameter completion: Completion handler.
    func updateUsername(username: String, completion: @escaping () -> Void) async {
        guard username != self.username else {
            AlertManager.shared.showAlert(title: "Alert", message: "Your new username cannot be your old.")
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let request = UpdateUsernameRequest(username: username)
            try await userStore.updateUsername(request: request)
            completion()
        } catch let networkError as NetworkError {
            AlertManager.shared.showAlert(title: "An error occured", message: networkError.message)
            Logger.network.error("Error updating username: \(networkError)")
        } catch {
            if error.isCancellation { return }
            AlertManager.shared.showAlert(title: "An error occured", message: error.localizedDescription)
            Logger.network.error("Error updating username: \(error)")
        }
    }
}

extension EditProfileViewModel {
    
    static var mockVM: EditProfileViewModel {
        let userService = UserService(client: APIClient.shared)
        let userStore = UserStore(userService: userService)
        let vm = EditProfileViewModel(userStore: userStore)
        return vm
    }
    
}
