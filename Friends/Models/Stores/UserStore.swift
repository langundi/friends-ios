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
    
    private let userService: UserService
    
    init(userService: UserService) {
        self.userService = userService
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
        let result = try await userService.getMyProfile()
        username = result.username
        email = result.email
        lastFetchAt = Date()
    }
    
    /// Search for a username.
    /// - Parameter username: Username.
    /// - Returns: UsernameResponse.
    func searchUsername(username: String) async throws -> UsernameResponse {
        try await userService.searchUsername(username: username)
    }
    
    /// Prevents user from adding their self as a friend.
    /// - Parameter searchText: Search query.
    /// - Returns: Is current user's username or not.
    func checkSearchIsCurrentUsername(searchText: String) -> Bool {
        if searchText == username { return true }
        return false
    }
    
    /// Update user's username.
    /// - Parameter request: UpdateUsernameRequest
    func updateUsername(request: UpdateUsernameRequest) async throws {
        try await userService.updateUsername(request: request)
        username = request.username
    }
    
    /// Update user's email.
    /// - Parameter request: UpdateEmailRequest
    func updateEmail(request: UpdateEmailRequest) async throws {
        try await userService.updateEmail(request: request)
        email = request.email
    }

}
