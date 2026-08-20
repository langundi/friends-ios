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
    
    var timeline: [PostResponse] {
        timelineStore.timeline
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
            switch networkError {
            case .noDataRecieved:
                Logger.network.warning("Timeline: \(networkError.message)")
            default:
                AlertManager.shared.showAlert(title: "An error occured", message: networkError.message)
                Logger.network.error("Error fetching timeline: \(networkError.message)")
            }
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
