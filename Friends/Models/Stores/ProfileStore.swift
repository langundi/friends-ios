//
//  UserStore.swift
//  Friends
//
//  Created by Ziqa on 20/08/26.
//

import Foundation

/// A representation of user's profile.
@Observable
final class UserStore {
    
    private(set) var username = ""
    
    private let service: UserService
    
    init(service: UserService) {
        self.service = service
    }
    
    func setUsername(_ username: String) {
        self.username = username
    }
    
    func getMyProfile() async throws {
        let result = try await service.getMyProfile()
        username = result.username
    }
    
    func checkSearchIsCurrentUsername(searchText: String) -> Bool {
        if searchText == username { return true }
        return false
    }
}
