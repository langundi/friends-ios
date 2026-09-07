//
//  PostRequests.swift
//  Friends
//
//  Created by Ziqa on 11/08/26.
//

import Foundation

struct NewPostRequest: Encodable {
    let caption: String
    let imageUrl: String
    let objectKey: String
    
    enum CodingKeys: String, CodingKey {
        case caption
        case imageUrl = "image_url"
        case objectKey = "object_key"
    }
}

struct UploadImageRequest: Encodable {
    let filename: String
    let contentType: String
    
    enum CodingKeys: String, CodingKey {
        case filename
        case contentType = "content_type"
    }
}

struct DeletePostRequest: Encodable {
    let objectKey: String
    
    enum CodingKeys: String, CodingKey {
        case objectKey = "object_key"
    }
}

struct DeleteAllImageRequest: Encodable {
    let objectKeys: [String]
    
    enum CodingKeys: String, CodingKey {
        case objectKeys = "object_keys"
    }
}

struct MoreTimelineRequest: Encodable {
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
    }
}

struct LikePostRequest: Encodable {
    let senderUsername: String
    let receiverID: Int
    
    enum CodingKeys: String, CodingKey {
        case senderUsername = "sender_username"
        case receiverID = "receiver_id"
    }
}

struct DeleteReplyRequest: Encodable {
    let replyID: Int
    
    enum CodingKeys: String, CodingKey {
        case replyID = "reply_id"
    }
}
