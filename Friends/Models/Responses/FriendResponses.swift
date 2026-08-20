//
//  FriendResponses.swift
//  Friends
//
//  Created by Ziqa on 17/08/26.
//

import Foundation

struct NewFriendRequestResponse: Identifiable, Decodable {
    let id: Int
    let senderID: Int
    let receiverID: Int
    let status: String
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case senderID = "sender_id"
        case receiverID = "receiver_id"
        case status
        case createdAt = "created_at"
    }
}

struct FriendRequestResponse: Identifiable, Decodable {
    let id: Int
    let senderID: Int
    let receiverID: Int
    let status: String
    let createdAt: Date
    let senderUsername: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case senderID = "sender_id"
        case receiverID = "receiver_id"
        case status
        case createdAt = "created_at"
        case senderUsername = "sender_username"
    }
}

struct FriendshipStatusResponse: Decodable {
    let friendshipStatus: FriendshipStatus
    
    enum CodingKeys: String, CodingKey {
        case friendshipStatus = "friendship_status"
    }
}

struct FriendResponse: Identifiable, Decodable {
    let id: Int
    let userID: Int
    let username: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case username
    }
}
