//
//  ReplyResponses.swift
//  Friends
//
//  Created by Ziqa on 25/08/26.
//

import Foundation

struct ReplyResponse: Identifiable, Decodable {
    let id: Int
    let userID: Int
    let postID: Int
    let reply: String
    let createdAt: Date
    let repliedByMe: Bool
    let username: String
    let profilePicture: String?
    
    enum CodingKeys: String, CodingKey {
        case id, reply, username
        case userID = "user_id"
        case postID = "post_id"
        case createdAt = "created_at"
        case repliedByMe = "replied_by_me"
        case profilePicture = "profile_picture"
    }
}
