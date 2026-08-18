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
    let friendService: FriendService
    
    var isLoading: Bool = false
    var searchedUser: SearchUsernameResponse?
    var status: FriendshipStatus?
    
    init(userService: UserService, friendService: FriendService) {
        self.userService = userService
        self.friendService = friendService
    }
    
    /// Search for a user by username.
    /// - Parameter username: A username
    func searchUsername(searchText: String) async {
        guard !userService.checkSearchIsCurrentUsername(searchText: searchText) else {
            AlertManager.shared.showAlert(title: "Alert", message: "You can't add yourself.")
            clearResult()
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response = try await userService.searchUsername(username: searchText)
            searchedUser = response
        } catch let networkError as NetworkError {
            AlertManager.shared.showAlert(title: "An error occured", message: networkError.message)
            Logger.network.error("Error searching username: \(networkError)")
            clearResult()
        } catch {
            AlertManager.shared.showAlert(title: "An error occured", message: error.localizedDescription)
            Logger.network.error("Error searching username: \(error)")
            clearResult()
        }
    }
    
    /// Fetch friendship status for the searched userID.
    /// - Parameter userID: Searched user's userID.
    func checkFriendshipStatus(userID: Int) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response = try await friendService.getFriendshipStatus(userID: userID)
            status = response.friendshipStatus
        } catch let networkError as NetworkError {
            AlertManager.shared.showAlert(title: "An error occured", message: networkError.message)
            Logger.network.error("Error friendship check: \(networkError)")
            clearResult()
        } catch {
            AlertManager.shared.showAlert(title: "An error occured", message: error.localizedDescription)
            Logger.network.error("Error friendship check: \(error)")
            clearResult()
        }
    }
    
    func sendFriendRequest(receiverId: Int, completion: @escaping () -> Void) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response = try await friendService.sendFriendRequest(receiverId: receiverId)
            completion()
            Logger.network.info("Friend request sent to: userID \(response.receiverID) by userID \(response.senderID)")
        } catch let networkError as NetworkError {
            AlertManager.shared.showAlert(title: "An error occured", message: networkError.message)
            Logger.network.error("Error sending friend request: \(networkError)")
        } catch {
            AlertManager.shared.showAlert(title: "An error occured", message: error.localizedDescription)
            Logger.network.error("Error sending friend request: \(error)")
        }
    }
    
    /// Clear search result.
    func clearResult() {
        searchedUser = nil
        status = nil
    }
}
