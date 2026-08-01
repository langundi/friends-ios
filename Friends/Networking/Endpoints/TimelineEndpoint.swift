//
//  TimelineEndpoint.swift
//  Friends
//
//  Created by Ziqa on 28/07/26.
//

import Foundation

enum TimelineEndpoint: Endpoint {
    case timeline
    
    var method: HTTPMethod {
        switch self {
        case .timeline:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .timeline:
            return "/timeline"
        }
    }
    
    var protected: Bool {
        switch self {
        case .timeline:
            return true
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var body: (any Encodable)? {
        return nil
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
}
