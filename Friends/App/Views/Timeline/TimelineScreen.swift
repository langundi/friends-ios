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
    private var factory: ViewModelFactory
    
    init(factory: ViewModelFactory) {
        self.factory = factory
        _viewModel = State(initialValue: factory.makeTimelineViewModel())
    }
    
    var body: some View {
        TimelineStackView(viewModel: viewModel, posts: viewModel.timeline)
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
            .environment(viewModel)
    }
}

#Preview {
    NavigationStack {
        TimelineScreen(factory: ViewModelFactory())
    }
    .appPreviewEnvironments()
}

#Preview("With Posts") {
    NavigationStack {
        TimelineStackView(viewModel: TimelineViewModel.mockTimeline, posts: PostResponse.timelineDummy)
            .navigationTitle("Timeline")
            .navigationBarTitleDisplayMode(.inline)
    }
    .appPreviewEnvironments()
}
