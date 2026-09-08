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
    @State private var scrollID: Int?
    @State private var pendingScrollID: Int?
    @State private var showLoadMore: Bool = false
    @State private var showScrollToTop: Bool = false
    @State private var noMorePost: Bool = false
    
    private var currentCreatedAt: Date {
        guard let post = viewModel.timeline.first(where: { $0.id == scrollID }) else {
            return Date()
        }
        return post.createdAt
    }
    
    init(viewModel: TimelineViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Group {
            if viewModel.timeline.isEmpty {
                ScrollView {
                    ContentUnavailableView {
                        Image("megamind")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150)
                    } description: {
                        Text("No friends?")
                            .font(.title)
                            .fontWeight(.bold)
                    } actions: {
                        Button {
                            router.push(to: .search(username: nil))
                        } label: {
                            Label("Find Friends", systemImage: "magnifyingglass")
                        }
                    }
                }
                .refreshable {
                    await viewModel.refreshTimeline()
                }
            } else {
                ScrollViewReader { proxy in
                    ScrollView(.vertical) {
                        LazyVStack(alignment: .center, spacing: 0) {
                            ForEach(viewModel.timeline) { post in
                                PostView(viewModel: viewModel, post: post)
                                    .id(post.id)
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .ignoresSafeArea(edges: [.horizontal, .bottom])
                    .scrollTargetBehavior(.paging)
                    .scrollIndicators(.hidden)
                    .scrollPosition(id: $scrollID)
                    .overlay(alignment: .bottom) {
                        if showLoadMore && !noMorePost {
                            Button {
                                Task {
                                    await viewModel.getMoreTimeline(lastCreatedAt: currentCreatedAt) { id in
                                        setNextScrollID(id: id)
                                    }
                                }
                            } label: {
                                Label("Load More", systemImage: "arrow.down")
                                    .padding()
                            }
                            .disabled(viewModel.isLoading)
                            .buttonStyle(ToolbarButtonStyle())
                            .transition(.blurReplace)
                            .padding(.bottom)
                        }
                    }
                    .overlay(alignment: .topTrailing) {
                        if showScrollToTop {
                            Button {
                                withAnimation(.snappy) {
                                    let top = viewModel.timeline.first?.id
                                    proxy.scrollTo(top, anchor: .top)
                                    scrollID = top
                                }
                            } label: {
                                Image(systemName: "arrow.up")
                            }
                            .disabled(viewModel.isLoading)
                            .buttonStyle(ToolbarButtonStyle())
                            .padding(.trailing)
                            .transition(.blurReplace)
                        }
                    }
                    .onChange(of: scrollID) { _, newValue in
                        checkForLoadMore(currentID: newValue)
                        checkForScrollToTop(currentID: newValue)
                    }
                    .onChange(of: viewModel.timeline) { _, _ in
                        if let id = pendingScrollID {
                            // Scroll to next post after more timeline loaded
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                withAnimation(.snappy) {
                                    proxy.scrollTo(id, anchor: .top)
                                    pendingScrollID = nil
                                }
                            }
                        }
                    }
                    .refreshable {
                        await viewModel.refreshTimeline()
                    }
                    .animation(.snappy, value: showLoadMore)
                    .animation(.snappy, value: showScrollToTop)
                }
            }
        }
    }
    
    private func checkForLoadMore(currentID: Int?) {
        guard let currentID, let index = viewModel.timeline.firstIndex(where: { $0.id == currentID }) else {
            return
        }
        
        if index == viewModel.timeline.count - 1 {
            showLoadMore = true
        } else {
            showLoadMore = false
        }
    }
    
    private func checkForScrollToTop(currentID: Int?) {
        guard let currentID, let index = viewModel.timeline.firstIndex(where: { $0.id == currentID }) else {
            return
        }
        
        if index >= 1 {
            showScrollToTop = true
        } else {
            showScrollToTop = false
        }
    }
    
    private func setNextScrollID(id: Int) {
        guard id != -1 else {
            AlertManager.shared.showAlert(title: "Hmmm", message: "Go outside bro.")
            noMorePost = true
            return
        }
        showLoadMore = false
        pendingScrollID = id
    }
}

#Preview {
    TimelineStackView(viewModel: TimelineViewModel.mockEmpty)
        .appPreviewEnvironments()
}
