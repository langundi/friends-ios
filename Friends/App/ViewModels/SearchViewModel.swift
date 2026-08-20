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
    
    var isLoading: Bool = false
    var searchedUser: UsernameResponse?
    var status: FriendshipStatus?
    
    let userService: UserService
    let friendService: FriendService
    
    init(userService: UserService, friendService: FriendService) {
        self.userService = userService
        self.friendService = friendService
    }
    
    /// Search a user by username.
    /// - Parameter username: A username.
    func searchUsername(searchText: String) async {
        guard !userService.checkSearchIsCurrentUsername(searchText: searchText) else {
            AlertManager.shared.showAlert(title: "Alert", message: "You can't add yourself.")
            clearResult()
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let result = try await userService.searchUsername(username: searchText)
            searchedUser = result
        } catch let networkError as NetworkError {
            AlertManager.shared.showAlert(title: "An error occured", message: networkError.message)
            clearResult()
            Logger.network.error("Error searching username: \(networkError)")
        } catch {
            AlertManager.shared.showAlert(title: "An error occured", message: error.localizedDescription)
            clearResult()
            Logger.network.error("Error searching username: \(error)")
        }
    }
    
    /// Fetch friendship status for the searched userID.
    /// - Parameter userID: Searched user's userID.
    func checkFriendshipStatus(userID: Int) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let result = try await friendService.getFriendshipStatus(userID: userID)
            status = result.friendshipStatus
        } catch let networkError as NetworkError {
            AlertManager.shared.showAlert(title: "An error occured", message: networkError.message)
            clearResult()
            Logger.network.error("Error friendship status: \(networkError)")
        } catch {
            AlertManager.shared.showAlert(title: "An error occured", message: error.localizedDescription)
            clearResult()
            Logger.network.error("Error friendship status: \(error)")
        }
    }
    
    /// Send friend request to a user.
    /// - Parameters:
    ///   - receiverID: Target userID.
    ///   - completion: Completion handler.
    func sendFriendRequest(receiverID: Int, completion: @escaping () -> Void) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let result = try await friendService.sendFriendRequest(receiverID: receiverID)
            completion()
            Logger.network.info("Friend request sent to: userID \(result.receiverID) by userID \(result.senderID)")
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
