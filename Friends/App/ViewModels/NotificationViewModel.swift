//
//  NotificationViewModel.swift
//  Friends
//
//  Created by Ziqa on 01/08/26.
//

import Foundation
import OSLog

@Observable
final class NotificationViewModel {
    
    var isLoading: Bool = false
    
    var notifications: [NotificationResponse] {
        notificationStore.notifications
    }
    
    var friendRequests: [FriendRequestResponse] = []
    
    private let notificationStore: NotificationStore
    private let friendService: FriendService
    
    init(notificationStore: NotificationStore, friendService: FriendService) {
        self.notificationStore = notificationStore
        self.friendService = friendService
    }
    
    // MARK: - Notifications
    
    /// Fetch all notifications.
    func getAllNotification() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await notificationStore.loadNotificationsIfNeeded()
        } catch let networkError as NetworkError {
            AlertManager.shared.showAlert(title: "An error occured", message: networkError.message)
            Logger.network.error("Error fetching notifications: \(networkError.message)")
        } catch {
            if error.isCancellation { return }
            AlertManager.shared.showAlert(title: "An error occured", message: error.localizedDescription)
            Logger.network.error("Error fetching notifications: \(error)")
        }
    }
    
    /// Refresh notifications.
    func refreshNotifications() async {
        notificationStore.invalidateLastFetch()
        await getAllNotification()
    }
    
    // MARK: - Friend Request
    
    /// Fetch user's friend requests.
    func getFriendRequests() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            friendRequests = try await friendService.getFriendRequests() ?? []
        } catch let networkError as NetworkError {
            AlertManager.shared.showAlert(title: "An error occured", message: networkError.message)
            Logger.network.error("Error fetching friend requests: \(networkError.message)")
        } catch {
            if error.isCancellation { return }
            AlertManager.shared.showAlert(title: "An error occured", message: error.localizedDescription)
            Logger.network.error("Error fetching friend requests: \(error)")
        }
    }
    
    /// Decline a friend request.
    /// - Parameter id: Friend Request ID.
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
            if error.isCancellation { return }
            AlertManager.shared.showAlert(title: "An error occured", message: error.localizedDescription)
            Logger.network.error("Error declining friend request: \(error)")
        }
    }
    
    /// Accept a friend request.
    /// - Parameter id: Friend Request ID.
    func acceptFriendRequest(id: Int) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await friendService.acceptFriendRequest(id: id)
            friendRequests.removeAll { $0.id == id }
        } catch let networkError as NetworkError {
            AlertManager.shared.showAlert(title: "An error occured", message: networkError.message)
            Logger.network.error("Error declining friend request: \(networkError.message)")
        } catch {
            if error.isCancellation { return }
            AlertManager.shared.showAlert(title: "An error occured", message: error.localizedDescription)
            Logger.network.error("Error declining friend request: \(error)")
        }
    }
    
}
