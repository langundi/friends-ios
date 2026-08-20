//
//  PostStore.swift
//  Friends
//
//  Created by Ziqa on 20/08/26.
//

import Foundation

/// A representation of a user's posts.
@Observable
final class PostStore {
    
    private(set) var posts: [PostResponse] = []
    private var lastFetchAt: Date?
    private let staleDuration: TimeInterval = 500
    
    private let service: PostService
    
    init(postService: PostService) {
        self.service = postService
    }
    
    func setPosts(_ posts: [PostResponse]) {
        self.posts = posts
    }
    
    func insert(_ post: PostResponse) {
        posts.insert(post, at: 0)
    }
    
    func invalidateLastFetch() {
        lastFetchAt = nil
    }
    
    /// Fetch post when last fetch time has passed stale duration.
    func loadPostIfNeeded() async throws {
        if let lastFetchAt, Date().timeIntervalSince(lastFetchAt) < staleDuration {
            return
        }
        
        try await getMyPosts()
    }
    
    /// Fetch user's posts.
    func getMyPosts() async throws {
        posts = try await service.getMyPosts()
        lastFetchAt = Date()
    }
    
    /// Delete user's posts
    /// - Parameter request: Payload.
    func deletePost(request: DeletePostRequest) async throws {
        try await service.deletePost(request: request)
        posts.removeAll { $0.id == request.id }
    }
    
    func getPresignedURL(request: UploadImageRequest) async throws -> UploadImageResponse {
        try await service.getPresignedUrl(request: request)
    }
    
    func uploadImage(uploadURL: String, imageData: Data) async throws {
        try await service.uploadImage(uploadUrl: uploadURL, imageData: imageData)
    }
    
    func newPost(request: NewPostRequest) async throws -> PostResponse {
        try await service.newPost(request: request)
    }
}
