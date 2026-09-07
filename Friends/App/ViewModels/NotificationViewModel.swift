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
    
    var friendRequests: [FriendRequestResponse] {
        friendRequestStore.friendRequests
    }
    
    private let notificationStore: NotificationStore
    private let friendRequestStore: FriendRequestStore
    
    init(notificationStore: NotificationStore, friendRequestStore: FriendRequestStore) {
        self.notificationStore = notificationStore
        self.friendRequestStore = friendRequestStore
    }
    
    /// Load notifications and friend requests.
    func loadNotificationsAndFriendRequests() async {
        async let notifications: () = getNotifications()
        async let friendRequests: () = getFriendRequests()
        _ = await (notifications, friendRequests)
    }
    
    // MARK: - Notifications
    
    /// Fetch all notifications.
    func getNotifications() async {
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
        await getNotifications()
    }
    
    // MARK: - Friend Request
    
    /// Fetch user's friend requests.
    func getFriendRequests() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await friendRequestStore.loadFriendRequestsIfNeeded()
        } catch let networkError as NetworkError {
            AlertManager.shared.showAlert(title: "An error occured", message: networkError.message)
            Logger.network.error("Error fetching friend requests: \(networkError.message)")
        } catch {
            if error.isCancellation { return }
            AlertManager.shared.showAlert(title: "An error occured", message: error.localizedDescription)
            Logger.network.error("Error fetching friend requests: \(error)")
        }
    }
    
    func refreshFriendRequests() async {
        friendRequestStore.invalidateLastFetch()
        await getFriendRequests()
    }
    
    /// Decline a friend request.
    /// - Parameter id: Friend Request ID.
    func declineFriendRequest(id: Int) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await friendRequestStore.declineFriendRequest(id: id)
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
            try await friendRequestStore.acceptFriendRequest(id: id)
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
