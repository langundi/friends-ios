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
        let response: LoginResponse
        response = try await client.request(endpoint: AuthEndpoint.login(request: request))
        try Keychain.set(response.accessToken, Constants.accessToken)
        try Keychain.set(response.refreshToken, Constants.refreshToken)
        return response
    }
    
    func logoutUser(request: RefreshRequest) async throws {
        try await client.requestVoid(endpoint: AuthEndpoint.logout(request: request))
    }
}
