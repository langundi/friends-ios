//
//  FriendEndpoint.swift
//  Friends
//
//  Created by Ziqa on 17/08/26.
//

import Foundation

enum FriendEndpoint: Endpoint {
    case friendRequests
    case getFriendshipStatus(userId: Int)
    case sendRequest(receiverId: Int)
    case declineRequest(id: Int)
    
    var method: HTTPMethod {
        switch self {
        case .friendRequests, .getFriendshipStatus:
            return .get
        case .sendRequest:
            return .post
        case .declineRequest:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .friendRequests:
            return "/friend-request"
        case .getFriendshipStatus(let userId):
            return "/friend-request/\(userId)"
        case .sendRequest(let receiverId):
            return "/friend-request/send/\(receiverId)"
        case .declineRequest(let id):
            return "/friend-request/decline/\(id)"
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
