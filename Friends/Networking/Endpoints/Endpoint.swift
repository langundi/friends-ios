//
//  Endpoint.swift
//  Friends
//
//  Created by Ziqa on 28/07/26.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    var protected: Bool { get }
    var headers: [String: String]? { get }
    var body: Encodable? { get }
    var method: HTTPMethod { get }
    var fullURL: String { get }
}

extension Endpoint {
    var baseURL: String { "http://192.168.1.15:8080" }
    
    var queryItems: [URLQueryItem]? { return nil }
    var headers: [String: String]? { return nil }
    var body: [Encodable]? { return nil }
    
    var fullURL: String {
        let base = [baseURL, path]
            .map { $0.trimmingCharacters(in: .init(charactersIn: "/")) }
            .joined(separator: "/")
        
        guard let items = queryItems, !items.isEmpty, var components = URLComponents(string: base) else {
            return base
        }
        
        components.queryItems = items
        return components.url?.absoluteString ?? base
    }
}
