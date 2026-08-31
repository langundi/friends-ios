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
    
    enum CodingKeys: String, CodingKey {
        case id, email, username
        case profilePicture = "profile_picture"
    }
}

struct UsernameResponse: Identifiable, Decodable {
    let id: Int
    let username: String
}
