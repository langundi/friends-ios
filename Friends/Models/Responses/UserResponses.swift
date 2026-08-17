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
}

struct SearchUsernameResponse: Decodable {
    let id: Int
    let username: String
}
