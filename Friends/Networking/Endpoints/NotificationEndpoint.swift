//
//  NotificationEndpoint.swift
//  Friends
//
//  Created by Ziqa on 06/09/26.
//

import Foundation

enum NotificationEndpoint: Endpoint {
    case getAllNotifications
    
    var path: String {
        switch self {
        case .getAllNotifications:
            "/notification"
        }
    }
    
    var protected: Bool {
        return true
    }
    
    var method: HTTPMethod {
        switch self {
        case .getAllNotifications:
            return .get
        }
    }
    
    var body: (any Encodable)? {
        switch self {
        case .getAllNotifications:
            return nil
        }
    }
}
