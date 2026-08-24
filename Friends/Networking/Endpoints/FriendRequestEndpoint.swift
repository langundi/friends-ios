//
//  FriendRequestEndpoint.swift
//  Friends
//
//  Created by Ziqa on 17/08/26.
//

import Foundation

enum FriendRequestEndpoint: Endpoint {
    case sendFriendRequest(id: Int)
    case getFriendRequests
    case acceptFriendRequest(id: Int)
    case declineFriendRequest(id: Int)
    
    var method: HTTPMethod {
        switch self {
        case .sendFriendRequest:
            return .post
        case .getFriendRequests:
            return .get
        case .acceptFriendRequest:
            return .patch
        case .declineFriendRequest:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .sendFriendRequest(let id):
            return "/friend-request/\(id)"
        case .getFriendRequests:
            return "/friend-request"
        case .acceptFriendRequest(let id):
            return "/friend-request/\(id)"
        case .declineFriendRequest(let id):
            return "/friend-request/\(id)"
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
