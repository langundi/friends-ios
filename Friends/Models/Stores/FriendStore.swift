//
//  FriendStore.swift
//  Friends
//
//  Created by Ziqa on 20/08/26.
//

import Foundation

@Observable
final class FriendStore {
    
    private(set) var friends: [FriendResponse] = []
    private var lastFetchAt: Date?
    private let staleDuration: TimeInterval = 500
    
    private let friendService: FriendService
    
    init(friendService: FriendService) {
        self.friendService = friendService
    }
    
    func setFriends(_ friends: [FriendResponse]) {
        self.friends = friends
    }
    
    func invalidateLastFetch() {
        lastFetchAt = nil
    }
    
    /// Fetch friends when last fetch time has passed stale duration.
    func loadFriendList() async throws {
        if let lastFetchAt, Date().timeIntervalSince(lastFetchAt) < staleDuration {
            return
        }
        
        try await getFriendList()
    }
    
    /// Fetch user's friends.
    func getFriendList() async throws {
        friends = try await friendService.getFriendList() ?? []
        lastFetchAt = Date()
    }
    
    /// Remove a friend from user's friend list.
    /// - Parameter id: Friendship ID.
    func unfriend(id: Int) async throws {
        try await friendService.unfriend(userID: id)
        friends.removeAll { $0.id == id }
    }
}
