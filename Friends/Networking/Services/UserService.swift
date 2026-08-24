//
//  UserService.swift
//  Friends
//
//  Created by Ziqa on 11/08/26.
//

import Foundation

final class UserService {
    private let client: APIClient
    
    init(client: APIClient) {
        self.client = client
    }
    
    func getMyProfile() async throws -> UserResponse {
        try await client.request(endpoint: UserEndpoint.getMyProfile)
    }
    
    func getFriendProfile(userID: Int) async throws -> UserResponse {
        try await client.request(endpoint: UserEndpoint.getFriendProfile(id: userID))
    }
    
    func searchUsername(username: String) async throws -> UsernameResponse {
        try await client.request(endpoint: UserEndpoint.searchUsername(username: username))
    }
}
