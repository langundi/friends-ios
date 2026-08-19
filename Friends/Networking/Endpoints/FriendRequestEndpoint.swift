//
//  FriendRequestEndpoint.swift
//  Friends
//
//  Created by Ziqa on 17/08/26.
//

import Foundation

enum FriendRequestEndpoint: Endpoint {
    case list
    case send(receiverId: Int)
    case accept(id: Int)
    case decline(id: Int)
    
    var method: HTTPMethod {
        switch self {
        case .list:
            return .get
        case .send:
            return .post
        case .accept:
            return .patch
        case .decline:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .list:
            return "/friend-request"
        case .send(let receiverId):
            return "/friend-request/\(receiverId)"
        case .accept(let id):
            return "/friend-request/\(id)"
        case .decline(let id):
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
