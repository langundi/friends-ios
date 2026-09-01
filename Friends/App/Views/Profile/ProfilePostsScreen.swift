//
//  ProfilePostsScreen.swift
//  Friends
//
//  Created by Ziqa on 01/09/26.
//

import SwiftUI

struct ProfilePostsScreen: View {
    @State private var profileViewModel: ProfileViewModel
    @State private var timelineViewModel: TimelineViewModel
    var selectedID: Int
    
    init(factory: ViewModelFactory, selectedID: Int) {
        self.profileViewModel = factory.profileViewModel
        self.timelineViewModel = factory.timelineViewModel
        self.selectedID = selectedID
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical) {
                LazyVStack(alignment: .center, spacing: 0) {
                    ForEach(profileViewModel.posts) { post in
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
