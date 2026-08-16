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
    
    var posts: [PostResponse]
    
    var body: some View {
        if posts.isEmpty {
            ContentUnavailableView {
                Image(systemName: "person.2.fill")
            } description: {
                Text("Let's add some friends!")
            } actions: {
                Button {
                    router.push(to: .search)
                } label: {
                    Label("Find Friend", systemImage: "magnifyingglass")
                }

            }
        } else {
            ScrollView(.vertical) {
                LazyVStack(alignment: .center, spacing: 0) {
                    ForEach(posts) { post in
                        PostView(post: post)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.paging)
            .scrollIndicators(.hidden)
            .ignoresSafeArea()
        }
    }
}
