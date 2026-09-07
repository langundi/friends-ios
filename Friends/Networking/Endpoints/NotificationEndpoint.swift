//
//  NotificationEndpoint.swift
//  Friends
//
//  Created by Ziqa on 06/09/26.
//

import Foundation

enum NotificationEndpoint: Endpoint {
    case getAllNotifications
    case readNotifications
    
    var path: String {
        switch self {
        case .getAllNotifications:
            "/notification"
        case .readNotifications:
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
        case .readNotifications:
            return .patch
        }
    }
    
    var body: (any Encodable)? {
        switch self {
        case .getAllNotifications:
            return nil
        case .readNotifications:
            return nil
        }
    }
}
