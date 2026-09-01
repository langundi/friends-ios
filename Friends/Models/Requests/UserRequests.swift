//
//  UserRequests.swift
//  Friends
//
//  Created by Ziqa on 27/08/26.
//

import Foundation

struct SetProfilePictureRequest: Encodable {
    let imageURL: String
    let objectKey: String
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "image_url"
        case objectKey = "object_key"
    }
}

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

struct DeleteProfilePictureRequest: Encodable {
    let objectKey: String
    
    enum CodingKeys: String, CodingKey {
        case objectKey = "object_key"
    }
}
