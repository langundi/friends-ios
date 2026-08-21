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
    
    private let service: PostService
    
    init(postService: PostService) {
        self.service = postService
    }
    
    func setTimeline(_ timeline: [PostResponse]) {
        self.timeline = timeline
    }
    
    func insert(_ post: PostResponse) {
        timeline.insert(post, at: 0)
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
        timeline = try await service.getTimeline() ?? []
        lastFetchAt = Date()
    }
    
    /// Refresh timeline, used specifically for new post.
    func refreshTimeline() async throws {
        lastFetchAt = nil
        try await getTimeline()
    }
    
}
