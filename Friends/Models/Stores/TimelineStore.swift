//
//  TimelineStore.swift
//  Friends
//
//  Created by Ziqa on 20/08/26.
//

import Foundation

/// A representation of user's timeline.
@Observable
final class TimelineStore {
    
    private(set) var timeline: [PostResponse] = []
    private var lastFetchAt: Date?
    private let staleDuration: TimeInterval = 500
    
    private let postService: PostService
    
    init(postService: PostService) {
        self.postService = postService
    }
    
    func setTimeline(_ timeline: [PostResponse]) {
        self.timeline = timeline
    }
    
    func insert(_ post: PostResponse) {
        timeline.insert(post, at: 0)
    }
    
    func delete(_ id: Int) {
        guard let postID = timeline.firstIndex(where: { $0.id == id }) else {
            return
        }
        timeline.removeAll { $0.id == postID }
    }
    
    func invalidateLastFetch() {
        lastFetchAt = nil
    }
    
    func loadTimelineIfNeeded() async throws {
        if let lastFetchAt, Date().timeIntervalSince(lastFetchAt) < staleDuration {
            return
        }
        
        try await getTimeline()
    }
    
    /// Fetch timeline posts.
    func getTimeline() async throws {
        timeline = try await postService.getTimeline() ?? []
        lastFetchAt = Date()
    }
    
    /// Fetch more timeline posts.
    /// - Parameter request: MoreTimelineRequest.
    func getMoreTimeline(request: MoreTimelineRequest) async throws -> Int? {
        guard let result = try await postService.getMoreTimeline(request: request) else {
            return nil
        }
        timeline.append(contentsOf: result)
        return result.first?.id
    }
    
    /// Refresh timeline, used specifically for new post.
    func refreshTimeline() async throws {
        lastFetchAt = nil
        try await getTimeline()
    }
    
    /// Like a post.
    /// - Parameter id: PostID.
    func likePost(id: Int) async throws {
        try await postService.likePost(postID: id)
        if let index = timeline.firstIndex(where: { $0.id == id }) {
            timeline[index].likeCount += 1
            timeline[index].likedByMe = true
        }
    }
    
    /// Unlike a post.
    /// - Parameter id: PostID.
    func unlikePost(id: Int) async throws {
        try await postService.unlikePost(postID: id)
        if let index = timeline.firstIndex(where: { $0.id == id }) {
            timeline[index].likeCount -= 1
            timeline[index].likedByMe = false
        }
    }
}
