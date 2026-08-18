//
//  FriendRequestViewModel.swift
//  Friends
//
//  Created by Ziqa on 02/08/26.
//

import Foundation
import OSLog

@Observable
final class FriendRequestViewModel {
    private let friendService: FriendService
    
    var isLoading: Bool = false
    var friendRequests: [FriendRequestResponse] = []
    
    init(friendService: FriendService) {
        self.friendService = friendService
    }
    
    func getFriendRequests() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response = try await friendService.getFriendRequests()
            friendRequests = response
        } catch let networkError as NetworkError {
            switch networkError {
            case .noDataRecieved:
                Logger.network.warning("Profile Posts: \(networkError.message)")
            default:
                AlertManager.shared.showAlert(title: "An error occured", message: networkError.message)
                Logger.network.error("Error fetching friend requests: \(networkError.message)")
            }
        } catch {
            AlertManager.shared.showAlert(title: "An error occured", message: error.localizedDescription)
            Logger.network.error("Error fetching friend requests: \(error)")
        }
    }
    
    func declineFriendRequest(id: Int) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await friendService.declineFriendRequest(id: id)
            friendRequests.removeAll { $0.id == id }
        } catch let networkError as NetworkError {
            AlertManager.shared.showAlert(title: "An error occured", message: networkError.message)
            Logger.network.error("Error declining friend request: \(networkError.message)")
        } catch {
            AlertManager.shared.showAlert(title: "An error occured", message: error.localizedDescription)
            Logger.network.error("Error declining friend request: \(error)")
        }
    }
}
