//
//  FriendRequests.swift
//  Friends
//
//  Created by Ziqa on 17/08/26.
//

import Foundation

struct FriendRequestRequest: Encodable {
    let senderUsername: String
    let receiverID: Int
    let receiverUsername: String
    
    enum CodingKeys: String, CodingKey {
        case senderUsername = "sender_username"
        case receiverID = "receiver_id"
        case receiverUsername = "receiver_username"
    }
}
