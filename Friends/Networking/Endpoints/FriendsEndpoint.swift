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
    
    var method: HTTPMethod {
        switch self {
        case .list:
            return .get
        case .status:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .list:
            return "/friends"
        case .status(let userID):
            return "/friends/\(userID)/status"
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
