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
        replyStore.replies
    }
    
    var username: String {
        userStore.username
    }
    
    private let timelineStore: TimelineStore
    private let postStore: PostStore
    private let replyStore: ReplyStore
    private let userStore: UserStore
    
    init(timelineStore: TimelineStore, postStore: PostStore, replyStore: ReplyStore, userStore: UserStore) {
        self.timelineStore = timelineStore
        self.postStore = postStore
        self.replyStore = replyStore
        self.userStore = userStore
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
    
    /// Fetch more timeline posts.
    /// - Parameter lastCreatedAt: The last post's `createdAt` property.
    func getMoreTimeline(lastCreatedAt: Date, completion: @escaping (Int) -> Void) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let request = MoreTimelineRequest(createdAt: lastCreatedAt)
            let nextID = try await timelineStore.getMoreTimeline(request: request) ?? -1 // -1 = reached the end
            completion(nextID)
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
    func likePost(id: Int, receiverID: Int) async {
        do {
            let request = LikePostRequest(senderUsername: userStore.username, receiverID: receiverID)
            try await timelineStore.likePost(id: id, request: request)
            // Change like state for posts that are both in timeline and profile or a friend profile
            try await postStore.likePost(id: id)
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
            // Change state for posts that are both in timeline and profile or a friend profile
            try await postStore.unlikePost(id: id)
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
            try await replyStore.getPostReplies(id: id)
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
    func replyPost(id: Int, reply: String, receiverID: Int) async {
        isSheetLoading = true
        defer { isSheetLoading = false }
        
        do {
            let request = ReplyRequest(reply: reply, username: userStore.username, receiverID: receiverID)
            let replyResult = try await replyStore.replyPost(id: id, request: request)
            replyStore.insert(replyResult)
        } catch let networkError as NetworkError {
            AlertManager.shared.showAlert(title: "An error occured", message: networkError.message)
            Logger.network.error("Error replying: \(networkError.message)")
        } catch {
            if error.isCancellation { return }
            AlertManager.shared.showAlert(title: "An error occured", message: error.localizedDescription)
            Logger.network.error("Error replying: \(error)")
        }
    }
    
    /// Delete reply from post.
    /// - Parameter id: ReplyID.
    func deleteReply(id: Int) async {
        isSheetLoading = true
        defer { isSheetLoading = false }
        
        do {
            try await replyStore.deleteReply(id: id)
        } catch let networkError as NetworkError {
            AlertManager.shared.showAlert(title: "An error occured", message: networkError.message)
            Logger.network.error("Error deleting reply: \(networkError.message)")
        } catch {
            if error.isCancellation { return }
            AlertManager.shared.showAlert(title: "An error occured", message: error.localizedDescription)
            Logger.network.error("Error deleting reply: \(error)")
        }
    }
    
    func clearReplies() {
        replyStore.clearReplies()
    }
}

// MARK: - Mock Timeline

extension TimelineViewModel {
    static var mockTimeline: TimelineViewModel {
        let postService = PostService(client: APIClient.shared)
        let userService = UserService(client: APIClient.shared)
        
        let timelineStore = TimelineStore(postService: postService)
        let postStore = PostStore(postService: postService)
        let replyStore = ReplyStore(postService: postService)
        let userStore = UserStore(userService: userService)
        
        let vm = TimelineViewModel(timelineStore: timelineStore, postStore: postStore, replyStore: replyStore, userStore: userStore)
        
        let timeline = PostResponse.timelineDummy
        timelineStore.setTimeline(timeline)
        vm.isLoading = false
        return vm
    }
    
    static var mockEmpty: TimelineViewModel {
        let postService = PostService(client: APIClient.shared)
        let userService = UserService(client: APIClient.shared)
        
        let timelineStore = TimelineStore(postService: postService)
        let postStore = PostStore(postService: postService)
        let replyStore = ReplyStore(postService: postService)
        let userStore = UserStore(userService: userService)
        
        let vm = TimelineViewModel(timelineStore: timelineStore, postStore: postStore, replyStore: replyStore, userStore: userStore)
        
        timelineStore.setTimeline([])
        vm.isLoading = false
        return vm
    }
    
    static var mockLoading: TimelineViewModel {
        let postService = PostService(client: APIClient.shared)
        let userService = UserService(client: APIClient.shared)
        
        let timelineStore = TimelineStore(postService: postService)
        let postStore = PostStore(postService: postService)
        let replyStore = ReplyStore(postService: postService)
        let userStore = UserStore(userService: userService)
        
        let vm = TimelineViewModel(timelineStore: timelineStore, postStore: postStore, replyStore: replyStore, userStore: userStore)
        
        vm.isLoading = true
        return vm
    }
}
