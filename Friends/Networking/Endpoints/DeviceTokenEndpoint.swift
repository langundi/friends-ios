//
//  DeviceTokenEndpoint.swift
//  Friends
//
//  Created by Ziqa on 04/09/26.
//

import Foundation

enum DeviceTokenEndpoint: Endpoint {
    case register(request: DeviceTokenRequest)
    case delete(request: DeviceTokenRequest)
    
    var method: HTTPMethod {
        switch self {
        case .register:
            return .post
        case .delete:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .register:
            return "/device-token/register"
        case .delete:
            return "/device-token/delete"
        }
    }
    
    var protected: Bool {
        return true
    }
    
    var body: (any Encodable)? {
        switch self {
        case .register(let device):
            return device
        case .delete(let device):
            return device
        }
    }
}
