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

// MARK: - Post Dummy

extension PostResponse {
    
    static let singlePost = PostResponse(
        id: 1,
        userID: 1,
        caption: "Lorem ipsum dolor sit amet, in anim eiusmod deserunt non eiusmod",
        imageURL: "https://images.unsplash.com/photo-1784558473693-6b396480e729?q=80&w=1336&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        objectKey: "posts/1/mock-object-key.jpeg",
        createdAt: Date()
    )
    
    static let noCaptionPost = PostResponse(
        id: 1,
        userID: 1,
        caption: "",
        imageURL: "https://images.unsplash.com/photo-1784558473693-6b396480e729?q=80&w=1336&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        objectKey: "posts/1/mock-object-key.jpeg",
        createdAt: Date()
    )
    
}
