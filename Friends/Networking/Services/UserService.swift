//
//  UserService.swift
//  Friends
//
//  Created by Ziqa on 11/08/26.
//

import Foundation

final class UserService {
    private let client: APIClient
    
    /// Current user username.
    private(set) var username: String = ""
    
    init(client: APIClient) {
        self.client = client
    }
    
    /// Fetch current user profile.
    /// - Returns: `UserResponse`
    func getMyProfile() async throws -> UserResponse {
        let response: UserResponse
        response = try await client.request(endpoint: UserEndpoint.myProfile)
        username = response.username
        return response
    }
    
    func getFriendProfile(id: Int) async throws -> UserResponse {
        let response: UserResponse
        response = try await client.request(endpoint: UserEndpoint.friendProfile(id: id))
        return response
    }
    
    /// Search user by username.
    /// - Parameter username: A username.
    /// - Returns: `UsernameResponse`
    func searchUsername(username: String) async throws -> UsernameResponse {
        try await client.request(endpoint: UserEndpoint.search(username: username))
    }
    
    /// Checks wether searched username is the currently logged in username to prevent adding self.
    /// - Parameter searchText: A username.
    /// - Returns: Boolean value wether search text equals to the currently logged in username or not.
    func checkSearchIsCurrentUsername(searchText: String) -> Bool {
        if searchText == username {
            return true
        }
        
        return false
    }
}
