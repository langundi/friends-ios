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
    
    func getFriendRequests() async throws -> [FriendRequestResponse]? {
        try await client.requestOptional(endpoint: FriendRequestEndpoint.getFriendRequests)
    }
    
    func sendFriendRequest(request: SendFriendRequestNotification) async throws -> NewFriendRequestResponse {
        try await client.request(endpoint: FriendRequestEndpoint.sendFriendRequest(request: request))
    }
    
    func acceptFriendRequest(id: Int, request: AcceptFriendRequestNotification) async throws {
        try await client.requestVoid(endpoint: FriendRequestEndpoint.acceptFriendRequest(id: id, request: request))
    }
    
    func declineFriendRequest(id: Int) async throws {
        try await client.requestVoid(endpoint: FriendRequestEndpoint.declineFriendRequest(id: id))
    }
    
    // MARK: - Friends Endpoints
    
    func getFriendshipStatus(searchedUserID: Int) async throws -> FriendshipStatusResponse {
        try await client.request(endpoint: FriendEndpoint.getFriendshipStatus(id: searchedUserID))
    }
    
    func unfriend(userID: Int) async throws {
        try await client.requestVoid(endpoint: FriendEndpoint.unfriend(id: userID))
    }
    
    // MARK: - User Endpoints
    
    func getMyFriendList() async throws -> [FriendResponse]? {
        try await client.requestOptional(endpoint: UserEndpoint.getMyFriendList)
    }
    
    func getFriendList(userID: Int) async throws -> [FriendResponse]? {
        try await client.requestOptional(endpoint: UserEndpoint.getFriendList(id: userID))
    }
    
}
