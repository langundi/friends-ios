//
//  UserStore.swift
//  Friends
//
//  Created by Ziqa on 20/08/26.
//

import Foundation

/// A representation of user's profile.
@Observable
final class UserStore {
    
    private(set) var username = ""
    private(set) var email = ""
    private var lastFetchAt: Date?
    private let staleDuration: TimeInterval = 500
    
    private let service: UserService
    
    init(userService: UserService) {
        self.service = userService
    }
    
    func setUsername(_ username: String) {
        self.username = username
    }
    
    func invalidateLastFetch() {
        lastFetchAt = nil
    }
    
    /// Fetch profile when last fetch time has passed stale duration.
    func loadProfileIfNeeded() async throws {
        if let lastFetchAt, Date().timeIntervalSince(lastFetchAt) < staleDuration {
            return
        }
        
        try await getMyProfile()
    }
    
    /// Fetch user's profile.
    func getMyProfile() async throws {
        let result = try await service.getMyProfile()
        username = result.username
        email = result.email
        lastFetchAt = Date()
    }
    
    func searchUsername(username: String) async throws -> UsernameResponse {
        try await service.searchUsername(username: username)
    }
    
    /// Prevents user from adding their self as a friend.
    /// - Parameter searchText: Search query.
    /// - Returns: Is current user's username or not.
    func checkSearchIsCurrentUsername(searchText: String) -> Bool {
        if searchText == username { return true }
        return false
    }
}
