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
    
    private let postService: PostService
    
    init(postService: PostService) {
        self.postService = postService
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
        posts = try await postService.getMyPosts() ?? []
        lastFetchAt = Date()
    }
    
    /// Delete user's posts
    /// - Parameter request: Payload.
    func deletePost(postID: Int, request: DeletePostRequest) async throws {
        try await postService.deletePost(postID: postID, request: request)
        posts.removeAll { $0.id == postID }
    }
    
    func getPresignedURL(request: UploadImageRequest) async throws -> UploadImageResponse {
        try await postService.getPresignedURL(request: request)
    }
    
    func uploadImage(uploadURL: String, imageData: Data) async throws {
        try await postService.uploadImage(uploadUrl: uploadURL, imageData: imageData)
    }
    
    func newPost(request: NewPostRequest) async throws -> PostResponse {
        try await postService.newPost(request: request)
    }
    
    /// Delete all images from object storage, used for user account deletion.
    /// - Parameter request: DeleteAllImageRequest
    func deleteAllImage(request: DeleteAllImageRequest) async throws {
        try await postService.deleteAllImage(request: request)
    }
    
    /// Like a post.
    /// - Parameter id: PostID.
    func likePost(id: Int) async throws {
        if let index = posts.firstIndex(where: { $0.id == id }) {
            posts[index].likeCount += 1
            posts[index].likedByMe = true
        }
    }
    
    /// Unlike a post.
    /// - Parameter id: PostID.
    func unlikePost(id: Int) async throws {
        if let index = posts.firstIndex(where: { $0.id == id }) {
            posts[index].likeCount -= 1
            posts[index].likedByMe = false
        }
    }
}
