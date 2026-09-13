//
//  ReplyStore.swift
//  Friends
//
//  Created by Ziqa on 27/08/26.
//

import Foundation

@Observable
final class ReplyStore {
    
    private(set) var replies: [ReplyResponse] = []
    private var lastFetchAt: Date?
    private let staleDuration: TimeInterval = 500
    
    private let postService: PostService
    
    init(postService: PostService) {
        self.postService = postService
    }
    
    func insert(_ reply: ReplyResponse) {
        replies.append(reply)
    }
    
    /// Fetch post replies.
    /// - Parameter id: PostID.
    func getPostReplies(id: Int) async throws {
        replies = try await postService.getPostReplies(postID: id) ?? []
    }
    
    /// Reply to a post.
    /// - Parameters:
    ///   - id: PostID.
    ///   - request: ReplyRequest.
    /// - Returns: ReplyResponse.
    func replyPost(id: Int, request: ReplyRequest) async throws -> ReplyResponse {
        try await postService.replyPost(postID: id, request: request)
    }
    
    // Reply to a user.
    /// - Parameters:
    ///   - id: PostID.
    ///   - request: ReplyRequest.
    /// - Returns: ReplyResponse.
    func replyUser(id: Int, request: ReplyRequest) async throws -> ReplyResponse {
        try await postService.replyUser(postID: id, request: request)
    }
    
    /// Delete a reply from post.
    /// - Parameters:
    ///   - id: PostID.
    ///   - request: DeleteReplyRequest
    func deleteReply(id: Int, request: DeleteReplyRequest) async throws {
        try await postService.deleteReply(replyID: id, request: request)
        replies.removeAll { $0.id == id }
    }
    
    func clearReplies() {
        replies.removeAll()
    }
}
