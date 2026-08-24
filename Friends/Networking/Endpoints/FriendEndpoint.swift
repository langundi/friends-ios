//
//  FriendEndpoint.swift
//  Friend
//
//  Created by Ziqa on 19/08/26.
//

import Foundation

enum FriendEndpoint: Endpoint {
    case getFriendList
    case getFriendshipStatus(id: Int)
    case unfriend(id: Int)
    
    var method: HTTPMethod {
        switch self {
        case .getFriendList:
            return .get
        case .getFriendshipStatus:
            return .get
        case .unfriend:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .getFriendList:
            return "/friend"
        case .getFriendshipStatus(let id):
            return "/friend/\(id)/status"
        case .unfriend(let id):
            return"/friend/\(id)"
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
