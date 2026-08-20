//
//  TimelineScreen.swift
//  Friends
//
//  Created by Ziqa on 28/07/26.
//

import SwiftUI
import Kingfisher
import OSLog

struct TimelineScreen: View {
    @Environment(AppRouter.self) var router
    @Environment(\.scenePhase) var scenePhase
    @State private var viewModel: TimelineViewModel
    
    init(factory: ViewModelFactory) {
        _viewModel = State(initialValue: factory.makeTimelineViewModel())
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                LoadingOverlay()
            } else {
                TimelineStackView(posts: viewModel.timeline)
                    .environment(viewModel)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    router.push(to: .notification)
                } label: {
                    Label("Notifications", systemImage: "bell")
                        .labelStyle(.iconOnly)
                }
                
                Button {
                    router.push(to: .newPost)
                } label: {
                    Label("New Post", systemImage: "plus")
                        .labelStyle(.iconOnly)
                }
            }
        }
        .overlay(alignment: .center) {
            if viewModel.isLoading {
                LoadingOverlay()
            }
        }
        .task {
            await viewModel.getTimeline()
        }
        .refreshable {
            await viewModel.refreshTimeline()
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                Task {
                    await viewModel.refreshIfStale()
//                    print("last fetch: \(viewModel.lastFetchedAt)")
                }
            }
        }
    }
}





#Preview {
    NavigationStack {
        TimelineScreen(factory: ViewModelFactory())
    }
    .withPreviewEnvironments()
}

#Preview("With Posts") {
    let mock = TimelineViewModel.mockTimeline.timeline
    NavigationStack {
        TimelineStackView(posts: mock)
            .navigationTitle("Timeline")
            .navigationBarTitleDisplayMode(.inline)
    }
    .withPreviewEnvironments()  
}
