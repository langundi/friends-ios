//
//  SearchViewModel.swift
//  Friends
//
//  Created by Ziqa on 17/08/26.
//

import Foundation
import OSLog

@Observable
final class SearchViewModel {
    let userService: UserService
    
    var isLoading: Bool = false
    var user: SearchUsernameResponse?
    
    init(userService: UserService) {
        self.userService = userService
    }
    
    /// Search for a user by username.
    /// - Parameter username: A username
    func searchUsername(searchText: String) async {
        guard !userService.checkSearchIsCurrentUsername(searchText: searchText) else {
            AlertManager.shared.showAlert(
                title: "Alert",
                message: "You can't add yourself."
            )
            
            clearResult()
            
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response = try await userService.searchUsername(username: searchText)
            user = response
        } catch let networkError as NetworkError {
            Logger.network.error("Error uploading post: \(networkError)")
            
            clearResult()
            
            AlertManager.shared.showAlert(
                title: "An error occured",
                message: networkError.message
            )
        } catch {
            Logger.network.error("Error uploading post: \(error)")
            
            clearResult()
            
            AlertManager.shared.showAlert(
                title: "An error occured",
                message: error.localizedDescription
            )
        }
    }
    
    /// Clear search result.
    func clearResult() {
        user = nil
    }
}
