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
    private(set) var email = ""
    private(set) var profilePicture: String?
    private(set) var objectKey: String?
    
    private var lastFetchAt: Date?
    private let staleDuration: TimeInterval = 500
    
    private let userService: UserService
    
    init(userService: UserService) {
        self.userService = userService
    }
    
    func setProfilePicture(_ imageURL: String) {
        self.profilePicture = imageURL
    }
    
    func setObjectKey(_ objectKey: String) {
        self.objectKey = objectKey
    }
    
    func setUsername(_ username: String) {
        self.username = username
    }
    
    func invalidateLastFetch() {
        lastFetchAt = nil
    }
    
    /// Fetch profile when last fetch time has passed stale duration.
    func loadProfileIfNeeded() async throws {
        if let lastFetchAt, Date().timeIntervalSince(lastFetchAt) < staleDuration {
            return
        }
        
        try await getMyProfile()
    }
    
    /// Fetch user's profile.
    func getMyProfile() async throws {
        let result = try await userService.getMyProfile()
        username = result.username
        email = result.email
        
        if let profilePicture = result.profilePicture {
            self.profilePicture = profilePicture
        }
        
        if let objectKey = result.objectKey {
            self.objectKey = objectKey
        }
        
        lastFetchAt = Date()
    }
    
    /// Search for a username.
    /// - Parameter username: Username.
    /// - Returns: UsernameResponse.
    func searchUsername(username: String) async throws -> UsernameResponse {
        try await userService.searchUsername(username: username)
    }
    
    /// Prevents user from adding their self as a friend.
    /// - Parameter searchText: Search query.
    /// - Returns: Is current user's username or not.
    func checkSearchIsCurrentUsername(searchText: String) -> Bool {
        if searchText == username { return true }
        return false
    }
    
    /// Get presigned URL for profile picture upload.
    /// - Parameter request: UploadImageRequest.
    /// - Returns: UploadImageResponse
    func getPresignedURL(request: UploadImageRequest) async throws -> UploadImageResponse {
        try await userService.getPresignedURL(request: request)
    }
    
    /// Upload profile picture to bucket.
    /// - Parameters:
    ///   - uploadURL: Image public URL.
    ///   - imageData: Profile picture.
    func uploadImage(uploadURL: String, imageData: Data) async throws {
        try await userService.uploadImage(uploadUrl: uploadURL, imageData: imageData)
    }
    
    /// Set profile picture.
    /// - Parameter request: SetProfilePictureRequest.
    /// - Returns: SetProfilePictureResponse.
    func setProfilePicture(request: SetProfilePictureRequest) async throws -> SetProfilePictureResponse {
        try await userService.setProfilePicture(request: request)
    }
    
    /// Delete profile picture
    /// - Parameter request: DeleteProfilePictureRequest.
    func deleteProfilePicture(request: DeleteProfilePictureRequest) async throws {
        try await userService.deleteProfilePicture(request: request)
        profilePicture = nil
        objectKey = nil
    }
    
    /// Remove profile picture, used for setting up new profile picture.
    /// - Parameter request: RemoveProfilePictureRequest.
    func removeProfilePicture(request: DeleteProfilePictureRequest) async throws {
        try await userService.removeProfilePicture(request: request)
    }
    
    /// Change user's username.
    /// - Parameter request: UpdateUsernameRequest
    func changeUsername(request: ChangeUsernameRequest) async throws {
        try await userService.changeUsername(request: request)
        username = request.username
    }
    
    /// Change user's email.
    /// - Parameter request: UpdateEmailRequest
    func changeEmail(request: ChangeEmailRequest) async throws {
        try await userService.changeEmail(request: request)
        email = request.email
    }
    
    /// Change user's password.
    /// - Parameter request: ChangePasswordRequest
    func changePassword(request: ChangePasswordRequest) async throws {
        try await userService.changePassword(request: request)
    }
    
    /// Delete user's account.
    func deleteAccount() async throws {
        try await userService.deleteAccount()
        username = ""
        email = ""
        profilePicture = nil
        objectKey = nil
    }
    
    func getFriendProfile(userID: Int) async throws -> UserResponse {
        try await userService.getFriendProfile(userID: userID)
    }
}
