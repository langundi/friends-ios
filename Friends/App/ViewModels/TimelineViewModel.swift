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
    private let postService: PostService
    
    var isLoading: Bool = false
    var hasLoaded: Bool = false
    var timelinePosts: [PostResponse] = []
    var lastFetchedAt: Date?
    private let staleTreshold: TimeInterval = 10
    
    init(postService: PostService) {
        self.postService = postService
    }
    
    func getTimeline() async {
        print("get")
        guard !hasLoaded else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            timelinePosts = try await postService.getTimeline()
            
            hasLoaded = true
            
            lastFetchedAt = Date()
            
            print("last fetch: \(lastFetchedAt)")
        } catch let networkError as NetworkError {
            switch networkError {
            case .noDataRecieved:
                Logger.network.warning("Error fetching timeline: \(networkError.message)")
                hasLoaded = true
            default:
                AlertManager.shared.showAlert(
                    title: "An error occured",
                    message: networkError.message
                )
            }
        } catch {
            AlertManager.shared.showAlert(
                title: "An error occured",
                message: error.localizedDescription
            )
        }
    }
    
    func refreshTimeline() async {
        print("refresh")
        hasLoaded = false
        await getTimeline()
    }
    
    func refreshIfStale() async {
        print("stale refresh")
        print("last: \(lastFetchedAt)")
        guard let lastFetchedAt else {
            return
        }
        
        if Date().timeIntervalSince(lastFetchedAt) > staleTreshold {
            await refreshTimeline()
        }
    }
}

extension TimelineViewModel {
    static var mock: TimelineViewModel {
        let vm = TimelineViewModel(postService: PostService(client: APIClient.shared))
        vm.timelinePosts = [
            PostResponse(
                id: 1,
                userID: 1,
                caption: "Test 1",
                imageURL: "https://images.unsplash.com/photo-1784558473693-6b396480e729?q=80&w=1336&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                objectKey: "posts/1/image.jpeg",
                createdAt: Date()
            ),
            PostResponse(
                id: 2,
                userID: 1,
                caption: "",
                imageURL: "https://images.unsplash.com/photo-1784558473693-6b396480e729?q=80&w=1336&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                objectKey: "posts/1/image.jpeg",
                createdAt: Date().addingTimeInterval(3600)
            ),
            PostResponse(
                id: 3,
                userID: 1,
                caption: "Test 3",
                imageURL: "https://images.unsplash.com/photo-1784558473693-6b396480e729?q=80&w=1336&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                objectKey: "posts/1/image.jpeg",
                createdAt: Date().addingTimeInterval(7200)
            ),
            PostResponse(
                id: 4,
                userID: 1,
                caption: "Test 4",
                imageURL: "https://images.unsplash.com/photo-1784558473693-6b396480e729?q=80&w=1336&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                objectKey: "posts/1/image.jpeg",
                createdAt: Date().addingTimeInterval(7200)
            ),
            PostResponse(
                id: 5,
                userID: 1,
                caption: "Test 5",
                imageURL: "https://images.unsplash.com/photo-1784558473693-6b396480e729?q=80&w=1336&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                objectKey: "posts/1/image.jpeg",
                createdAt: Date().addingTimeInterval(7200)
            ),
            PostResponse(
                id: 6,
                userID: 1,
                caption: "Test 6",
                imageURL: "https://images.unsplash.com/photo-1784558473693-6b396480e729?q=80&w=1336&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                objectKey: "posts/1/image.jpeg",
                createdAt: Date().addingTimeInterval(7200)
            ),
        ]
        vm.isLoading = false
        return vm
    }
    
    static var mockEmpty: TimelineViewModel {
        let vm = TimelineViewModel(postService: PostService(client: APIClient.shared))
        vm.timelinePosts = []
        vm.isLoading = false
        return vm
    }
    
    static var mockLoading: TimelineViewModel {
        let vm = TimelineViewModel(postService: PostService(client: APIClient.shared))
        vm.isLoading = true
        return vm
    }
}
