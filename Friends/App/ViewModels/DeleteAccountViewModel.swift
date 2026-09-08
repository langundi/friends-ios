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
    private let postStore: PostStore
    
    init(userStore: UserStore, postStore: PostStore) {
        self.userStore = userStore
        self.postStore = postStore
    }
    
    /// Delete user's account and images from object storage.
    func deleteAccount() async {
        isLoading = true
        defer { isLoading = false }
        
        var objectKeys = [String]()
        let posts = postStore.posts
        for post in posts {
            objectKeys.append(post.objectKey)
        }
        
        do {
            try await userStore.deleteAccount()
            
            if !objectKeys.isEmpty {
                let request = DeleteAllImageRequest(objectKeys: objectKeys)
                try await postStore.deleteAllImage(request: request)
            }
            
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
