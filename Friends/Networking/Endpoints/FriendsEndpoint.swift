//
//  FriendsEndpoint.swift
//  Friends
//
//  Created by Ziqa on 19/08/26.
//

import Foundation

enum FriendsEndpoint: Endpoint {
    case list
    case status(userID: Int)
    case unfriend(id: Int)
    
    var method: HTTPMethod {
        switch self {
        case .list:
            return .get
        case .status:
            return .get
        case .unfriend:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .list:
            return "/friends"
        case .status(let userID):
            return "/friends/\(userID)/status"
        case .unfriend(let id):
            return"/friends/\(id)"
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
