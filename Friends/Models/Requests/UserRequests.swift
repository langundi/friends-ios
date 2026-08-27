//
//  UserRequests.swift
//  Friends
//
//  Created by Ziqa on 27/08/26.
//

import Foundation

struct UpdateUsernameRequest: Encodable {
    let username: String
}

struct UpdateEmailRequest: Encodable {
    let email: String
}
