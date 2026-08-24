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
    
    var method: HTTPMethod {
        switch self {
        default:
            return .get
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
        default:
            return nil
        }
    }
}
