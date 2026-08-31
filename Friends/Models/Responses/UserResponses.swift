//
//  UserResponse.swift
//  Friends
//
//  Created by Ziqa on 11/08/26.
//

import Foundation

struct UserResponse: Decodable {
    let id: Int
    let email: String
    let username: String
    let profilePicture: String?
    let objectKey: String?
    
    enum CodingKeys: String, CodingKey {
        case id, email, username
        case profilePicture = "profile_picture"
        case objectKey = "object_key"
    }
}

struct UsernameResponse: Identifiable, Decodable {
    let id: Int
    let username: String
}

struct SetProfilePictureResponse: Decodable {
    let profilePicture: String
    let objectKey: String
    
    enum CodingKeys: String, CodingKey {
        case profilePicture = "profile_picture"
        case objectKey = "object_key"
    }
}
