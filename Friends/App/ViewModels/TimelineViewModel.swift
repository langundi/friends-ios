//
//  HomeViewModel.swift
//  Friends
//
//  Created by Ziqa on 28/07/26.
//

import Foundation
import OSLog

@Observable
final class TimelineViewModel {
    
    var isLoading: Bool = false
    var isSheetLoading: Bool = false
    
    var timeline: [PostResponse] {
        timelineStore.timeline
    }
    
    var replies: [ReplyResponse] {
        timelineStore.replies
    }
    
    private let timelineStore: TimelineStore
    
    init(timelineStore: TimelineStore) {
        self.timelineStore = timelineStore
    }
    
    /// Fetch timeline.
    func getTimeline() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await timelineStore.loadTimelineIfNeeded()
        } catch let networkError as NetworkError {
            AlertManager.shared.showAlert(title: "An error occured", message: networkError.message)
            Logger.network.error("Error fetching timeline: \(networkError.message)")
        } catch {
            if error.isCancellation { return }
            AlertManager.shared.showAlert(title: "An error occured", message: error.localizedDescription)
            Logger.network.error("Error fetching timeline: \(error)")
        }
    }
    
    /// Re-fetch timeline.
    func refreshTimeline() async {
        timelineStore.invalidateLastFetch()
        await getTimeline()
    }
    
    
    /// Like post.
    /// - Parameter id: Post ID.
    func likePost(id: Int) async {
        do {
            try await timelineStore.likePost(id: id)
        } catch let networkError as NetworkError {
            AlertManager.shared.showAlert(title: "An error occured", message: networkError.message)
            Logger.network.error("Error fetching timeline: \(networkError.message)")
        } catch {
            if error.isCancellation { return }
            AlertManager.shared.showAlert(title: "An error occured", message: error.localizedDescription)
            Logger.network.error("Error fetching timeline: \(error)")
        }
    }
    
    /// Unlike post.
    /// - Parameter id: Post ID.
    func unlikePost(id: Int) async {
        do {
            try await timelineStore.unlikePost(id: id)
        } catch let networkError as NetworkError {
            AlertManager.shared.showAlert(title: "An error occured", message: networkError.message)
            Logger.network.error("Error fetching timeline: \(networkError.message)")
        } catch {
            if error.isCancellation { return }
            AlertManager.shared.showAlert(title: "An error occured", message: error.localizedDescription)
            Logger.network.error("Error fetching timeline: \(error)")
        }
    }
    
    /// Get post replies
    /// - Parameter id: PostID.
    func getReplies(id: Int) async {
        isSheetLoading = true
        defer { isSheetLoading = false }
        
        do {
            try await timelineStore.getPostReplies(id: id)
        } catch let networkError as NetworkError {
            AlertManager.shared.showAlert(title: "An error occured", message: networkError.message)
            Logger.network.error("Error fetching replies: \(networkError.message)")
        } catch {
            if error.isCancellation { return }
            AlertManager.shared.showAlert(title: "An error occured", message: error.localizedDescription)
            Logger.network.error("Error fetching replies: \(error)")
        }
    }
    
    /// Reply to post.
    /// - Parameters:
    ///   - id: Post ID.
    ///   - reply: Reply text.
    func replyPost(id: Int, reply: String) async {
        isSheetLoading = true
        defer { isSheetLoading = false }
        
        do {
            let request = ReplyRequest(reply: reply)
            try await timelineStore.replyPost(id: id, request: request)
            try await timelineStore.getPostReplies(id: id)
        } catch let networkError as NetworkError {
            AlertManager.shared.showAlert(title: "An error occured", message: networkError.message)
            Logger.network.error("Error fetching replies: \(networkError.message)")
        } catch {
            if error.isCancellation { return }
            AlertManager.shared.showAlert(title: "An error occured", message: error.localizedDescription)
            Logger.network.error("Error fetching replies: \(error)")
        }
    }
    
    /// Delete reply from post.
    /// - Parameter id: ReplyID.
    func deleteReply(id: Int) async {
        isSheetLoading = true
        defer { isSheetLoading = false }
        
        do {
            try await timelineStore.deleteReply(id: id)
        } catch let networkError as NetworkError {
            AlertManager.shared.showAlert(title: "An error occured", message: networkError.message)
            Logger.network.error("Error fetching replies: \(networkError.message)")
        } catch {
            if error.isCancellation { return }
            AlertManager.shared.showAlert(title: "An error occured", message: error.localizedDescription)
            Logger.network.error("Error fetching replies: \(error)")
        }
    }
}

// MARK: - Mock Timeline

extension TimelineViewModel {
    static var mockTimeline: TimelineViewModel {
        let service = PostService(client: APIClient.shared)
        let store = TimelineStore(postService: service)
        let vm = TimelineViewModel(timelineStore: store)
        let timeline = PostResponse.timelineDummy
        store.setTimeline(timeline)
        vm.isLoading = false
        return vm
    }
    
    static var mockEmpty: TimelineViewModel {
        let service = PostService(client: APIClient.shared)
        let store = TimelineStore(postService: service)
        let vm = TimelineViewModel(timelineStore: store)
        store.setTimeline([])
        vm.isLoading = false
        return vm
    }
    
    static var mockLoading: TimelineViewModel {
        let service = PostService(client: APIClient.shared)
        let store = TimelineStore(postService: service)
        let vm = TimelineViewModel(timelineStore: store)
        vm.isLoading = true
        return vm
    }
}
