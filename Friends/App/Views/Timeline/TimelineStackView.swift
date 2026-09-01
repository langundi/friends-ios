//
//  TimelineStackView.swift
//  Friends
//
//  Created by Ziqa on 16/08/26.
//


import SwiftUI
import Kingfisher
import OSLog

struct TimelineStackView: View {
    @Environment(AppRouter.self) var router
    var viewModel: TimelineViewModel
    var posts: [PostResponse]
    @State private var scrolledID: Int?
    @State private var showLoadMore: Bool = false
    
    private var currentCreatedAt: Date {
        guard let post = posts.first(where: { $0.id == scrolledID }) else {
            return Date()
        }
        return post.createdAt
    }
    
    init(viewModel: TimelineViewModel, posts: [PostResponse]) {
        self.viewModel = viewModel
        self.posts = posts
    }
    
    var body: some View {
        Group {
            if posts.isEmpty {
                ScrollView {
                    ContentUnavailableView {
                        Image(systemName: "person.2.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.gray)
                    } description: {
                        Text("Let's add some friends!")
                    } actions: {
                        Button {
                            router.push(to: .search)
                        } label: {
                            Label("Find Friends", systemImage: "magnifyingglass")
                        }
                    }
                }
                .refreshable {
                    await viewModel.refreshTimeline()
                }
            } else {
                ScrollView(.vertical) {
                    LazyVStack(alignment: .center, spacing: 0) {
                        ForEach(posts) { post in
                            PostView(viewModel: viewModel, post: post)
                        }
                    }
                    .scrollTargetLayout()
                }
                .ignoresSafeArea(edges: [.horizontal, .bottom])
                .scrollTargetBehavior(.paging)
                .scrollIndicators(.hidden)
                .scrollPosition(id: $scrolledID)
                .overlay(alignment: .bottom) {
                    if showLoadMore {
                        Button {
                            // load more posts
                        } label: {
                            Label("Load More", systemImage: "arrow.down")
                                .padding()
                        }
                        .buttonStyle(ToolbarButtonStyle())
                        .transition(.blurReplace)
                        .padding(.bottom)
                    }
                }
                .onChange(of: scrolledID) { oldValue, newValue in
                    checkForLoadMore(currentID: newValue)
                }
                .refreshable {
                    await viewModel.refreshTimeline()
                }
                .animation(.snappy, value: showLoadMore)
            }
        }
    }
    
    private func checkForLoadMore(currentID: Int?) {
        guard let currentID, let index = posts.firstIndex(where: { $0.id == currentID }) else {
            return
        }
        
        if index == posts.count - 1 {
            showLoadMore = true
        } else {
            showLoadMore = false
        }
    }
}

#Preview {
    TimelineStackView(viewModel: TimelineViewModel.mockTimeline, posts: PostResponse.timelineDummy)
        .appPreviewEnvironments()
}
