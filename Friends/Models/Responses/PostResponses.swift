//
//  PostResponses.swift
//  Friends
//
//  Created by Ziqa on 29/07/26.
//

import Foundation

struct PostResponse: Identifiable, Decodable {
    let id: Int
    let userID: Int
    let caption: String
    let imageURL: String
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id, caption
        case userID = "user_id"
        case imageURL = "image_url"
        case createdAt = "created_at"
    }
}

struct UploadImageResponse: Decodable {
    let uploadUrl: String
    let publicUrl: String
    let objectKey: String
    
    enum CodingKeys: String, CodingKey {
        case uploadUrl = "upload_url"
        case publicUrl = "public_url"
        case objectKey = "object_key"
    }
}
