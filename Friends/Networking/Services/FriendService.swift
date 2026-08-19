//
//  FriendService.swift
//  Friends
//
//  Created by Ziqa on 17/08/26.
//

import Foundation

final class FriendService {
    private let client: APIClient
    
    init(client: APIClient) {
        self.client = client
    }
    
    // MARK: - Friend Request Endpoints
    
    func getFriendRequests() async throws -> [FriendRequestResponse] {
        try await client.request(endpoint: FriendRequestEndpoint.list)
    }
    
    func sendFriendRequest(receiverId: Int) async throws -> NewFriendRequestResponse {
        try await client.request(endpoint: FriendRequestEndpoint.send(receiverId: receiverId))
    }
    
    func acceptFriendRequest(id: Int) async throws {
        try await client.requestVoid(endpoint: FriendRequestEndpoint.accept(id: id))
    }
    
    func declineFriendRequest(id: Int) async throws {
        try await client.requestVoid(endpoint: FriendRequestEndpoint.decline(id: id))
    }
    
    // MARK: - Friends Endpoints
    
    func getFriendshipStatus(userID: Int) async throws -> FriendshipStatusResponse {
        try await client.request(endpoint: FriendsEndpoint.status(userID: userID))
    }
    
    func getFriendList() async throws -> [UsernameResponse] {
        try await client.request(endpoint: FriendsEndpoint.list)
    }
    
    
}
