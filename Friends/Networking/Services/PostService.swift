//
//  PostService.swift
//  Friends
//
//  Created by Ziqa on 11/08/26.
//

import Foundation

final class PostService {
    private let client: APIClient
    
    init(client: APIClient) {
        self.client = client
    }
    
    func getPresignedUrl(request: UploadImageRequest) async throws -> UploadImageResponse {
        let response: UploadImageResponse
        response = try await client.request(endpoint: PostEndpoint.getPresignedUrl(request: request))
        return response
    }
    
    func uploadImageToBucket(uploadUrl: String, imageData: Data) async throws {
        try await client.uploadImageWith(presignedUrl: uploadUrl, imageData: imageData)
    }
    
    func newPost(request: NewPostRequest) async throws -> PostResponse {
        let response: PostResponse
        response = try await client.request(endpoint: PostEndpoint.newPost(request: request))
        return response
    }
    
    func getMyPosts() async throws -> [PostResponse] {
        let response: [PostResponse]
        response = try await client.request(endpoint: PostEndpoint.getMyPosts)
        return response
    }
    
    func getUsersPosts(userId: Int) async throws -> [PostResponse] {
        let response: [PostResponse]
        response = try await client.request(endpoint: PostEndpoint.getUsersPosts(userId: userId))
        return response
    }
}
