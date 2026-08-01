//
//  AuthEndpoint.swift
//  Friends
//
//  Created by Ziqa on 28/07/26.
//

import Foundation

enum AuthEndpoint: Endpoint {
    case register(user: RegisterRequest)
    case login(user: LoginRequest)
    case refresh(token: RefreshRequest)
    case logout(refresh: RefreshRequest)
    
    var method: HTTPMethod {
        switch self {
        case .register, .login, .refresh, .logout:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .register:
            return "auth/register"
        case .login:
            return "auth/login"
        case .refresh:
            return "auth/refresh"
        case .logout:
            return "auth/logout"
        }
    }
    
    var protected: Bool {
        switch self {
        case .register, .login, .refresh:
            return false
        case .logout:
            return true
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return ["Content-Type": "application/json"]
        }
    }
    
    var body: (any Encodable)? {
        switch self {
        case .register(let user):
            return user
        case .login(let user):
            return user
        case .refresh(let token):
            return token
        case .logout(let refresh):
            return refresh
        }
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
}
