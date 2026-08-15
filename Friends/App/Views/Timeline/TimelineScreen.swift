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
        .navigationTitle("Timeline")
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

private struct TimelineStackView: View {
    var posts: [PostResponse]
    
    var body: some View {
        if posts.isEmpty {
            ContentUnavailableView {
                Image(systemName: "person.2.fill")
            } description: {
                Text("Let's add some friends!")
            } actions: {
                Button {
                    // navigate to search friend
                } label: {
                    Label("Find Friend", systemImage: "magnifyingglass")
                }

            }
        } else {
            ScrollView(.vertical) {
                LazyVStack(alignment: .center, spacing: 36) {
                    ForEach(posts) { post in
                        KFImage(URL(string: post.imageURL))
                            .resizable()
                            .onFailure { error in
                                Logger.kingfisher.error("KF Error: \(error)")
                            }
                            .frame(maxWidth: .infinity)
                            .aspectRatio(1.0, contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }
                .padding()
            }
            .scrollIndicators(.hidden)
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
    TimelineStackView(posts: mock)
        .withPreviewEnvironments()
}

#Preview("Empty State") {
    let mock = TimelineViewModel.mockEmpty.timelinePosts
    TimelineStackView(posts: mock)
        .withPreviewEnvironments()
}
