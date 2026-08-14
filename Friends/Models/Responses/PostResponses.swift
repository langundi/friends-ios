//
//  PostResponses.swift
//  Friends
//
//  Created by Ziqa on 29/07/26.
//

import Foundation

/// The response payload for post creation.
struct PostResponse: Identifiable, Decodable {
    let id: Int
    let userID: Int
    let caption: String
    let imageURL: String
    let objectKey: String
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id, caption
        case userID = "user_id"
        case imageURL = "image_url"
        case objectKey = "object_key"
        case createdAt = "created_at"
    }
}

/// The response payload for uploading image to R2 Cloudflare.
struct UploadImageResponse: Decodable {
    let uploadURL: String
    let publicURL: String
    let objectKey: String
    
    enum CodingKeys: String, CodingKey {
        case uploadURL = "upload_url"
        case publicURL = "public_url"
        case objectKey = "object_key"
    }
}
