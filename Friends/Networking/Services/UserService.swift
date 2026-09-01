//
//  UserService.swift
//  Friends
//
//  Created by Ziqa on 11/08/26.
//

import Foundation

final class UserService {
    private let client: APIClient
    
    init(client: APIClient) {
        self.client = client
    }
    
    func getMyProfile() async throws -> UserResponse {
        try await client.request(endpoint: UserEndpoint.getMyProfile)
    }
    
    func getFriendProfile(userID: Int) async throws -> UserResponse {
        try await client.request(endpoint: UserEndpoint.getFriendProfile(id: userID))
    }
    
    func searchUsername(username: String) async throws -> UsernameResponse {
        try await client.request(endpoint: UserEndpoint.searchUsername(username: username))
    }
    
    func getPresignedURL(request: UploadImageRequest) async throws -> UploadImageResponse {
        try await client.request(endpoint: UserEndpoint.profileImageURL(request: request))
    }
    
    /// Upload image to bucket using presigned URL.
    func uploadImage(uploadUrl: String, imageData: Data) async throws {
        try await client.uploadImage(presignedUrl: uploadUrl, imageData: imageData)
    }
    
    func setProfilePicture(request: SetProfilePictureRequest) async throws -> SetProfilePictureResponse {
        try await client.request(endpoint: UserEndpoint.setProfilePicture(request: request))
    }
    
    func deleteProfilePicture(request: DeleteProfilePictureRequest) async throws {
        try await client.requestVoid(endpoint: UserEndpoint.deleteProfilePicture(request: request))
    }
    
    func removeProfilePicture(request: DeleteProfilePictureRequest) async throws {
        try await client.requestVoid(endpoint: UserEndpoint.removeProfilePicture(request: request))
    }
    
    func changeUsername(request: ChangeUsernameRequest) async throws {
        try await client.requestVoid(endpoint: UserEndpoint.changeUsername(request: request))
    }
    
    func changeEmail(request: ChangeEmailRequest) async throws {
        try await client.requestVoid(endpoint: UserEndpoint.changeEmail(request: request))
    }
    
    func changePassword(request: ChangePasswordRequest) async throws {
        try await client.requestVoid(endpoint: UserEndpoint.changePassword(request: request))
    }
    
    func deleteAccount() async throws {
        try await client.requestVoid(endpoint: UserEndpoint.deleteAccount)
    }
}
