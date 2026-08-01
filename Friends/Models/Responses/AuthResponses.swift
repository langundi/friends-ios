//
//  AuthService.swift
//  Friends
//
//  Created by Ziqa on 28/07/26.
//

import Foundation

struct RegisterResponse: Decodable {
    let id: Int
    let username: String
    let email: String
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id, username, email
        case createdAt = "created_at"
    }
}

struct LoginResponse: Decodable {
    let accessToken: String
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}

struct RefreshResponse: nonisolated Decodable {
    let accessToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}
