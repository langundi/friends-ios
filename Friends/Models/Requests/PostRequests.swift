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
    let id: Int
    let objectKey: String
    
    enum CodingKeys: String, CodingKey {
        case id
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
