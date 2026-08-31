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
    
    func getTimeline() async throws -> [PostResponse]? {
        try await client.requestOptional(endpoint: PostEndpoint.getTimeline)
    }
    
    func newPost(request: NewPostRequest) async throws -> PostResponse {
        try await client.request(endpoint: PostEndpoint.newPost(request: request))
    }
    
    func getPresignedURL(request: UploadImageRequest) async throws -> UploadImageResponse {
        try await client.request(endpoint: PostEndpoint.getPresignedUrl(request: request))
    }
    
    /// Upload image to bucket using presigned URL.
    func uploadImage(uploadUrl: String, imageData: Data) async throws {
        try await client.uploadImage(presignedUrl: uploadUrl, imageData: imageData)
    }
    
    func getMyPosts() async throws -> [PostResponse]? {
        try await client.requestOptional(endpoint: UserEndpoint.getMyPosts)
    }
    
    func getFriendPosts(userID: Int) async throws -> [PostResponse] {
        try await client.request(endpoint: UserEndpoint.getFriendPosts(id: userID))
    }
    
    func deletePost(request: DeletePostRequest) async throws {
        try await client.requestVoid(endpoint: PostEndpoint.deletePost(request: request))
    }
    
    func likePost(postID: Int) async throws {
        try await client.requestVoid(endpoint: PostEndpoint.likePost(id: postID))
    }
    
    func unlikePost(postID: Int) async throws {
        try await client.requestVoid(endpoint: PostEndpoint.unlikePost(id: postID))
    }
    
    func getPostReplies(postID: Int) async throws -> [ReplyResponse]? {
        try await client.requestOptional(endpoint: PostEndpoint.getReplies(id: postID))
    }
    
    func replyPost(postID: Int, request: ReplyRequest) async throws -> ReplyResponse {
        try await client.request(endpoint: PostEndpoint.replyPost(id: postID, request: request))
    }
    
    func deleteReply(replyID: Int) async throws {
        try await client.requestVoid(endpoint: PostEndpoint.deleteReply(id: replyID))
    }
    
    func deleteAllImage(request: DeleteAllImageRequest) async throws {
        try await client.requestVoid(endpoint: PostEndpoint.deleteAllImage(request: request))
    }
}
