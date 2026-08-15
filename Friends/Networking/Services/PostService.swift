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
    
    /// Current user posts, different from timeline posts.
    private(set) var posts: [PostResponse] = []
    
    init(client: APIClient) {
        self.client = client
    }
    
    /// Insert a post to posts array.
    /// - Parameter post: A post.
    func insert(_ post: PostResponse) {
        posts.insert(post, at: 0)
    }
    
    /// Replace posts with a new set of posts
    /// - Parameter posts: An array of post.
    func setPosts(_ posts: [PostResponse]) {
        self.posts = posts
    }
    
    /// Get posts.
    /// - Returns: An array of post.
    func getPosts() -> [PostResponse] {
        return posts
    }
    
    /// Make a new post to server.
    /// - Parameter request: The payload containing details for a new post.
    /// - Returns: A response containing the created post details.
    func newPost(request: NewPostRequest) async throws -> PostResponse {
        try await client.request(endpoint: PostEndpoint.newPost(request: request))
    }
    
    /// Fetch timeline from server.
    /// - Returns: An array of posts.
    func getTimeline() async throws -> [PostResponse] {
        try await client.request(endpoint: PostEndpoint.getTimeline)
    }
    
    /// Fetch presigned URL to store image.
    /// - Parameter request: The payload containing image metadata.
    /// - Returns: A response containing data from Cloudflare R2.
    func getPresignedUrl(request: UploadImageRequest) async throws -> UploadImageResponse {
        try await client.request(endpoint: PostEndpoint.getPresignedUrl(request: request))
    }
    
    /// Upload image to Cloudflare R2.
    /// - Parameters:
    ///   - uploadUrl: A presigned URL to upload the image.
    ///   - imageData: A converted and compressed image to upload.
    func uploadImageToBucket(uploadUrl: String, imageData: Data) async throws {
        try await client.uploadImageWith(presignedUrl: uploadUrl, imageData: imageData)
    }
    
    /// Fetch current user posts.
    /// - Returns: An array of posts.
    func getMyPosts() async throws -> [PostResponse] {
        let response: [PostResponse]
        response = try await client.request(endpoint: PostEndpoint.getMyPosts)
        return response
    }
    
    /// Fetch a user posts.
    /// - Parameter userId: Targeted user id.
    /// - Returns: An array of posts.
    func getUsersPosts(userID: Int) async throws -> [PostResponse] {
        try await client.request(endpoint: PostEndpoint.getUsersPosts(userId: userID))
    }
    
    func deletePost(request: DeletePostRequest) async throws {
        try await client.requestVoid(endpoint: PostEndpoint.deletePost(request: request))
    }
}
