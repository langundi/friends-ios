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
    
    private let service: PostService
    
    init(service: PostService) {
        self.service = service
    }
    
    /// Replace posts with a new set of posts
    /// - Parameter posts: An array of post.
    func setPosts(_ posts: [PostResponse]) {
        self.posts = posts
    }
    
    /// Insert a new post.
    /// - Parameter post: New post.
    func insert(_ post: PostResponse) {
        posts.insert(post, at: 0)
    }
    
    func getMyPosts() async throws {
        posts = try await service.getMyPosts()
    }
    
    func deletePost(request: DeletePostRequest) async throws {
        try await service.deletePost(request: request)
        posts.removeAll { $0.id == request.id }
    }
}
