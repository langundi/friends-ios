//
//  AuthService.swift
//  Friends
//
//  Created by Ziqa on 28/07/26.
//

import Foundation

final class AuthService {
    static let shared = AuthService()
    private let client = APIClient.shared
    
    init() {}
    
    func registerUser(user: RegisterRequest) async throws -> RegisterResponse {
        return try await client.request(endpoint: AuthEndpoint.register(user: user))
    }
    
    func loginUser(user: LoginRequest) async throws -> LoginResponse {
        let response: LoginResponse
        response = try await client.request(endpoint: AuthEndpoint.login(user: user))
        try Keychain.set(response.accessToken, Constants.accessToken)
        try Keychain.set(response.refreshToken, Constants.refreshToken)
        return response
    }
    
    func logoutUser(refresh: RefreshRequest) async throws {
        // REFRESH HASN'T UPDATED AFTER REFRESH, FIND WAY TO CALL WITH NEW REFRESH
        try await client.requestVoid(endpoint: AuthEndpoint.logout(refresh: refresh))
    }
}
