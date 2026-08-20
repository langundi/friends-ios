//
//  TokenManager.swift
//  Friends
//
//  Created by Ziqa on 28/07/26.
//

import Foundation

actor TokenManager {
    
    private var refreshTask: Task<String, Error>?
    private var isLoggedIn: Bool {
        get { UserDefaults.standard.bool(forKey: Constants.isUserLoggedIn) }
        set { UserDefaults.standard.set(newValue, forKey: Constants.isUserLoggedIn) }
    }
    
    func refreshToken() async throws -> String {
        if let refreshTask = refreshTask {
            return try await refreshTask.value
        }
        
        let task = Task<String, Error> {
            defer { refreshTask = nil }
            return try await performRefresh()
        }
        
        refreshTask = task
        
        return try await task.value
    }
    
    private func performRefresh() async throws -> String {
        guard let token: String = try? Keychain.get(Constants.refreshToken) else {
            isLoggedIn = false
            throw NetworkError.sessionExpired
        }
        
        let endpoint = AuthEndpoint.refresh(token: RefreshRequest(refreshToken: token))
        
        guard let url = await URL(string: endpoint.fullURL) else {
            throw NetworkError.invalidURL
        }
        
        let payload = RefreshRequest(refreshToken: token)
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(payload)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.unknown
        }
        
        let json: JSONResponse<RefreshResponse>
        
        do {
            json = try JSONDecoder().decode(JSONResponse<RefreshResponse>.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
        
        guard (200..<300).contains(response.statusCode) else {
            switch response.statusCode {
            case 401:
                isLoggedIn = false
                deleteTokensFromKeychain()
                throw NetworkError.sessionExpired
            default:
                throw NetworkError.apiError(
                    statusCode: response.statusCode,
                    message: json.error?.message ?? "Unknown error."
                )
            }
        }
        
        guard let result = await json.data else {
            throw NetworkError.noDataRecieved
        }
        
        try? Keychain.set(result.accessToken, Constants.accessToken)
        
        return result.accessToken
    }
    
    private func deleteTokensFromKeychain() {
        _ = Keychain.delete(Constants.accessToken)
        _ = Keychain.delete(Constants.refreshToken)
    }
}
