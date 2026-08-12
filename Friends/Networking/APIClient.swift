//
//  APIClient.swift
//  Friends
//
//  Created by Ziqa on 28/07/26.
//

import Foundation
import OSLog

struct APIClient {
    static let shared = APIClient()
    
    private let tokenManager: TokenManager
    
    init() {
        self.tokenManager = TokenManager()
    }
    
    func request<T: Decodable>(endpoint: Endpoint) async throws -> T {
        do {
            return try await execute(endpoint: endpoint)
        } catch NetworkError.apiError(let statusCode, _) where statusCode == 401 && endpoint.protected {
            _ = try await tokenManager.refreshToken()
            return try await execute(endpoint: endpoint)
        }
    }
    
    func requestVoid(endpoint: Endpoint) async throws {
        do {
            try await executeVoid(endpoint: endpoint)
        } catch NetworkError.apiError(let statusCode, _) where statusCode == 401 && endpoint.protected {
            _ = try await tokenManager.refreshToken()
            try await executeVoid(endpoint: endpoint)
        }
    }
    
    func uploadImageWith(presignedUrl: String, imageData: Data) async throws {
        guard let url = URL(string: presignedUrl) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.put.rawValue
        request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        
        let (_, response) = try await URLSession.shared.upload(for: request, from: imageData)
        
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.unknown
        }
        
        print("Upload Status: \(response.statusCode)")
    }
    
    private func execute<T: Decodable>(endpoint: Endpoint) async throws -> T {
        guard let url = URL(string: endpoint.fullURL) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        
        if endpoint.protected {
            guard let token: String = try? Keychain.get(Constants.accessToken) else {
                throw NetworkError.sessionExpired
            }
            
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = endpoint.body {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(body)
        }
    
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.unknown
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let json: JSONResponse<T>
        
        do {
            json = try decoder.decode(JSONResponse<T>.self, from: data)
        } catch let error as DecodingError {
            throw NetworkError.decodingError(error)
        }
        
        guard (200..<300).contains(response.statusCode) else {
            throw NetworkError.apiError(
                statusCode: response.statusCode,
                message: json.error?.message ?? "Unknown error."
            )
        }
        
        guard let result = json.data else {
            throw NetworkError.noDataRecieved
        }
        
        return result
    }
    
    private func executeVoid(endpoint: Endpoint) async throws {
        guard let url = URL(string: endpoint.fullURL) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        
        if endpoint.protected {
            guard let token: String = try? Keychain.get(Constants.accessToken) else {
                throw NetworkError.sessionExpired
            }
            
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = endpoint.body {
            request.httpBody = try JSONEncoder().encode(body)
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknown
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let json: JSONResponse<NoData>
        
        do {
            json = try decoder.decode(JSONResponse<NoData>.self, from: data)
        } catch let error as DecodingError {
            throw NetworkError.decodingError(error)
        }
        
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw NetworkError.apiError(
                statusCode: httpResponse.statusCode,
                message: json.error?.message ?? "Unknown error"
            )
        }
    }
}
