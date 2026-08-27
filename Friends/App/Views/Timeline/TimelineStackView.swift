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
    
    init(viewModel: TimelineViewModel, posts: [PostResponse]) {
        self.viewModel = viewModel
        self.posts = posts
    }
    
    var body: some View {
        if posts.isEmpty {
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
        } else {
            ScrollView(.vertical) {
                LazyVStack(alignment: .center, spacing: 0) {
                    ForEach(posts) { post in
                        PostView(viewModel: viewModel, post: post)
                    }
                }
                .scrollTargetLayout()
            }
            .ignoresSafeArea()
            .scrollTargetBehavior(.paging)
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    TimelineStackView(viewModel: TimelineViewModel.mockTimeline, posts: PostResponse.timelineDummy)
        .withPreviewEnvironments()
}
