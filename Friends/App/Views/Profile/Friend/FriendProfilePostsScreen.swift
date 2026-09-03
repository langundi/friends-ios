//
//  FriendProfilePostsScreen.swift
//  Friends
//
//  Created by Ziqa on 01/09/26.
//

import SwiftUI

struct FriendProfilePostsScreen: View {
    var selectedID: Int
    @State private var friendProfileViewModel: FriendProfileViewModel
    @State private var timelineViewModel: TimelineViewModel
    
    init(factory: ViewModelFactory, selectedID: Int) {
        self.friendProfileViewModel = factory.friendProfileViewModel
        self.timelineViewModel = factory.timelineViewModel
        self.selectedID = selectedID
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical) {
                LazyVStack(alignment: .center, spacing: 0) {
                    ForEach(friendProfileViewModel.posts) { post in
                        PostView(viewModel: timelineViewModel, post: post)
                            .id(post.id)
                    }
                }
                .scrollTargetLayout()
            }
            .ignoresSafeArea(edges: [.horizontal, .bottom])
            .scrollTargetBehavior(.paging)
            .scrollIndicators(.hidden)
            .onAppear {
                proxy.scrollTo(selectedID, anchor: .top)
            }
        }
    }
}

#Preview {
    ProfilePostsScreen(factory: ViewModelFactory(), selectedID: 1)
}
