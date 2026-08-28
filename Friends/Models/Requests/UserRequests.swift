//
//  UserRequests.swift
//  Friends
//
//  Created by Ziqa on 27/08/26.
//

import Foundation

struct ChangeUsernameRequest: Encodable {
    let username: String
}

struct ChangeEmailRequest: Encodable {
    let email: String
}

struct ChangePasswordRequest: Encodable {
    let email: String
    let currentPassword: String
    let newPassword: String
    
    enum CodingKeys: String, CodingKey {
        case email
        case currentPassword = "current_password"
        case newPassword = "new_password"
    }
}
