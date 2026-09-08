//
//  FriendRequestStore.swift
//  Friends
//
//  Created by Ziqa on 07/09/26.
//

import Foundation

final class FriendRequestStore {
    
    private(set) var friendRequests: [FriendRequestResponse] = []
    private var lastFetchAt: Date?
    private let staleDuration: TimeInterval = 500
    
    private let friendService: FriendService
    
    init(friendService: FriendService) {
        self.friendService = friendService
    }
    
    /// Load friend requests with stale duration.
    func loadFriendRequestsIfNeeded() async throws {
        if let lastFetchAt, Date().timeIntervalSince(lastFetchAt) < staleDuration {
            return
        }
        try await getFriendRequests()
    }
    
    func invalidateLastFetch() {
        lastFetchAt = nil
    }
    
    /// Fetch friend requests.
    func getFriendRequests() async throws {
        friendRequests = try await friendService.getFriendRequests() ?? []
        lastFetchAt = Date()
    }
    
    /// Decline friend request.
    /// - Parameter id: Friend Request ID.
    func declineFriendRequest(id: Int) async throws {
        try await friendService.declineFriendRequest(id: id)
        friendRequests.removeAll { $0.id == id }
    }
    
    /// Accept friend request.
    /// - Parameter id: Friend Request ID
    func acceptFriendRequest(id: Int, request: AcceptFriendRequestNotification) async throws {
        try await friendService.acceptFriendRequest(id: id, request: request)
        friendRequests.removeAll { $0.id == id }
    }
}
