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
    
    func getFriendRequests() async throws -> [FriendRequestResponse] {
        try await client.request(endpoint: FriendEndpoint.friendRequests)
    }
    
    func getFriendshipStatus(userID: Int) async throws -> FriendshipStatusResponse {
        try await client.request(endpoint: FriendEndpoint.getFriendshipStatus(userId: userID))
    }
    
    func sendFriendRequest(receiverId: Int) async throws -> NewFriendRequestResponse {
        try await client.request(endpoint: FriendEndpoint.sendRequest(receiverId: receiverId))
    }
    
    func declineFriendRequest(id: Int) async throws {
        try await client.requestVoid(endpoint: FriendEndpoint.declineRequest(id: id))
    }
}
