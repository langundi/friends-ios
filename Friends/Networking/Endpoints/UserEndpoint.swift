//
//  UserEndpoint.swift
//  Friends
//
//  Created by Ziqa on 11/08/26.
//

import Foundation

enum UserEndpoint: Endpoint {
    case myProfile
    case friendProfile(id: Int)
    
    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .myProfile:
            return "/user"
        case .friendProfile(let id):
            return "/user/\(id)"
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
