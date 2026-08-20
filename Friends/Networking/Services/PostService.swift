//
//  PostService.swift
//  Friends
//
//  Created by Ziqa on 11/08/26.
//

import Foundation

@Observable
final class PostService {
    
    private let client: APIClient
    
    init(client: APIClient) {
        self.client = client
    }
    
    func getTimeline() async throws -> [PostResponse] {
        try await client.request(endpoint: PostEndpoint.getTimeline)
    }
    
    func getPresignedUrl(request: UploadImageRequest) async throws -> UploadImageResponse {
        try await client.request(endpoint: PostEndpoint.getPresignedUrl(request: request))
    }
    
    func uploadImage(uploadUrl: String, imageData: Data) async throws {
        try await client.uploadImage(presignedUrl: uploadUrl, imageData: imageData)
    }
    
    func newPost(request: NewPostRequest) async throws -> PostResponse {
        try await client.request(endpoint: PostEndpoint.newPost(request: request))
    }
    
    func getMyPosts() async throws -> [PostResponse] {
        try await client.request(endpoint: PostEndpoint.getMyPosts)
    }
    
    func deletePost(request: DeletePostRequest) async throws {
        try await client.requestVoid(endpoint: PostEndpoint.deletePost(request: request))
    }
    
    func getUsersPosts(userID: Int) async throws -> [PostResponse] {
        try await client.request(endpoint: PostEndpoint.getUsersPosts(userId: userID))
    }
}
