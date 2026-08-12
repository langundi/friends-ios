//
//  TimelineScreen.swift
//  Friends
//
//  Created by Ziqa on 28/07/26.
//

import SwiftUI
import Kingfisher

struct TimelineScreen: View {
    @AppStorage(Constants.isUserLoggedIn) var isLoggedIn: Bool = true
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
                TimelineStackView()
                    .environment(viewModel)
            }
        }
        .navigationTitle("Timeline")
        .toolbarTitleDisplayMode(.inlineLarge)
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
    }
}

private struct TimelineStackView: View {
    @Environment(TimelineViewModel.self) var viewmodel
    
    var body: some View {
        if viewmodel.posts.isEmpty {
            ContentUnavailableView(
                "Nothing Here",
                systemImage: "photo.on.rectangle.angled",
                description: Text("Follow friends to see their posts.")
            )
        } else {
            ScrollView(.vertical) {
                LazyVStack(alignment: .center, spacing: 36) {
                    ForEach(viewmodel.posts) { post in
                        KFImage(URL(string: post.imageURL))
                            .resizable()
                            .onSuccess { result in
                                print("Image loaded from cache: \(result.cacheType)")
                            }
                            .onFailure { error in
                                print("KF error: \(error)")
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
    TimelineStackView()
        .environment(TimelineViewModel.mock)
        .withPreviewEnvironments()
}

#Preview("Empty State") {
    TimelineStackView()
        .environment(TimelineViewModel.mockEmpty)
        .withPreviewEnvironments()
}
