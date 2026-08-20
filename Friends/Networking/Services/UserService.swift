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
    
    func getMyProfile() async throws -> UserResponse {
        let response: UserResponse
        response = try await client.request(endpoint: UserEndpoint.myProfile)
        username = response.username
        return response
    }
    
    func getFriendProfile(id: Int) async throws -> UserResponse {
        try await client.request(endpoint: UserEndpoint.friendProfile(id: id))
    }
    
    func searchUsername(username: String) async throws -> UsernameResponse {
        try await client.request(endpoint: UserEndpoint.search(username: username))
    }
    
    func checkSearchIsCurrentUsername(searchText: String) -> Bool {
        if searchText == username {
            return true
        }
        
        return false
    }
}
