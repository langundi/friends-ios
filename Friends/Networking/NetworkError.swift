//
//  NetworkError.swift
//  Friends
//
//  Created by Ziqa on 28/07/26.
//

import Foundation

enum NetworkError: Error {
    case noInternet
    case invalidURL
    case sessionExpired
    case decodingError(Error)
    case apiError(statusCode: Int, message: String)
    case noDataRecieved
    case unknown
    
    var message: String {
        switch self {
        case .noInternet:
            return "No internet connection. Please check your network."
        case .invalidURL:
            return "Invalid URL."
        case .sessionExpired:
            return "Session expired. Please login."
        case .decodingError(let error):
            return "Decoding error: \(error)"
        case .apiError(_, let message):
            return message
        case .noDataRecieved:
            return "No data received."
        case .unknown:
            return "An unexpected error occured."
        }
    }
}
