//
//  UserEndpoint.swift
//  Friends
//
//  Created by Ziqa on 11/08/26.
//

import Foundation

enum UserEndpoint: Endpoint {
    case getMyProfile
    case getFriendProfile(id: Int)
    case getMyPosts
    case getFriendPosts(id: Int)
    case searchUsername(username: String)
    case changeUsername(request: ChangeUsernameRequest)
    case changeEmail(request: ChangeEmailRequest)
    case changePassword(request: ChangePasswordRequest)
    case deleteAccount
    
    var method: HTTPMethod {
        switch self {
        case .getMyProfile:
            return .get
        case .getFriendProfile:
            return .get
        case .getMyPosts:
            return .get
        case .getFriendPosts:
            return .get
        case .searchUsername:
            return .get
        case .changeUsername:
            return .patch
        case .changeEmail:
            return .patch
        case .changePassword:
            return .patch
        case .deleteAccount:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .getMyProfile:
            return "/user"
        case .getFriendProfile(let id):
            return "/user/\(id)"
        case .getMyPosts:
            return "/user/post/me"
        case .getFriendPosts(let id):
            return"/user/post/\(id)"
        case .searchUsername(let username):
            return "/user/search/\(username)"
        case .changeUsername:
            return "/user/change/username"
        case .changeEmail:
            return "/user/change/email"
        case .changePassword:
            return "/user/change/password"
        case .deleteAccount:
            return "/user/delete"
        }
    }
    
    var protected: Bool {
        switch self {
        default:
            return true
        }
    }
    
    var body: (any Encodable)? {
        switch self {
        case .changeUsername(let username):
            return username
        case .changeEmail(let email):
            return email
        case .changePassword(let password):
            return password
        default:
            return nil
        }
    }
}
