//
//  AuthRequests.swift
//  Friends
//
//  Created by Ziqa on 28/07/26.
//

import Foundation

nonisolated struct RegisterRequest: Encodable {
    let username: String
    let email: String
    let password: String
}

nonisolated struct LoginRequest: Encodable {
    let email: String
    let password: String
}

nonisolated struct AuthRequest: Encodable {
    let accessToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}

nonisolated struct RefreshRequest: Encodable {
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case refreshToken = "refresh_token"
    }
}
