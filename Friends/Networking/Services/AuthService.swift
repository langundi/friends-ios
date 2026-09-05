//
//  AuthService.swift
//  Friends
//
//  Created by Ziqa on 28/07/26.
//

import Foundation

final class AuthService {
    
    private let client: APIClient
    
    init(client: APIClient) {
        self.client = client
    }
    
    func registerUser(request: RegisterRequest) async throws -> RegisterResponse {
        return try await client.request(endpoint: AuthEndpoint.register(request: request))
    }
    
    func loginUser(request: LoginRequest) async throws -> LoginResponse {
        try await client.request(endpoint: AuthEndpoint.login(request: request))
        
    }
    
    func logoutUser(request: RefreshRequest) async throws {
        try await client.requestVoid(endpoint: AuthEndpoint.logout(request: request))
    }
}
