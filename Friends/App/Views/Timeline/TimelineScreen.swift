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
    @State private var viewModel: TimelineViewModel
    
    init(factory: ViewModelFactory) {
        _viewModel = State(initialValue: factory.makeTimelineViewModel())
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                LoadingOverlay()
            } else {
                TimelineStackView(posts: viewModel.timelinePosts)
                    .environment(viewModel)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    Task {
                        await viewModel.refreshTimeline()
                    }
                } label: {
                    Label("Refresh Timeline", systemImage: "arrow.counterclockwise")
                        .labelStyle(.iconOnly)
                }
            }
            
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
                    Label("New Post", systemImage: "camera")
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
    }
}





#Preview {
    NavigationStack {
        TimelineScreen(factory: ViewModelFactory())
    }
    .withPreviewEnvironments()
}

#Preview("With Posts") {
    let mock = TimelineViewModel.mock.timelinePosts
    NavigationStack {
        TimelineStackView(posts: mock)
            .navigationTitle("Timeline")
            .navigationBarTitleDisplayMode(.inline)
    }
    .withPreviewEnvironments()
        
}
