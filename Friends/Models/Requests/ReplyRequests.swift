//
//  ReplyRequests.swift
//  Friends
//
//  Created by Ziqa on 25/08/26.
//

import Foundation

struct ReplyRequest: Encodable {
    let reply: String
    let username: String
    let receiverID: Int
    let postOwnerID: Int
    
    enum CodingKeys: String, CodingKey {
        case reply
        case username
        case receiverID = "receiver_id"
        case postOwnerID = "post_owner_id"
    }
}
