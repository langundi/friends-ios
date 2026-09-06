//
//  NotificationResponses.swift
//  Friends
//
//  Created by Ziqa on 06/09/26.
//

import Foundation

struct NotificationResponse: Identifiable, Decodable {
    let id: Int
    let receiverID: Int
    let senderID: Int
    let message: String
    let postID: Int
    var isRead: Bool
    let createdAt: Date
    let profilePicture: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case receiverID = "receiver_id"
        case senderID = "sender_id"
        case message
        case postID = "post_id"
        case isRead = "is_read"
        case createdAt = "created_at"
        case profilePicture = "profile_picture"
    }
}
