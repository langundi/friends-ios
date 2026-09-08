//
//  FriendRequestRequests.swift
//  Friends
//
//  Created by Ziqa on 08/09/26.
//

import Foundation

struct SendFriendRequestNotification: Encodable {
    let senderUsername: String
    let receiverID: Int
    
    enum CodingKeys: String, CodingKey {
        case senderUsername = "sender_username"
        case receiverID = "receiver_id"
    }
}

struct AcceptFriendRequestNotification: Encodable {
    let senderUsername: String
    let senderID: Int
    
    enum CodingKeys: String, CodingKey {
        case senderUsername = "sender_username"
        case senderID = "sender_id"
    }
}
