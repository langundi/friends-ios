//
//  FriendListScreen.swift
//  Friends
//
//  Created by Ziqa on 01/08/26.
//

import SwiftUI

struct FriendListScreen: View {
    @State private var viewModel: ProfileViewModel
    
    var sortedFriends: [FriendResponse] {
        viewModel.friends.sorted { $0.username < $1.username }
    }
    
    init(factory: ViewModelFactory) {
        _viewModel = State(initialValue: factory.makeProfileViewModel())
    }
    
    var body: some View {
        List {
            ForEach(sortedFriends) { friend in
                FriendRowView(username: friend.username) {
                    Task {
                        await viewModel.unfriend(id: friend.id)
                    }
                } onBlockAction: {
                    print("block")
                }
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
        .navigationTitle("Friends")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.getFriendList()
        }
        .refreshable {
            await viewModel.refreshFriendList()
        }
    }
}

#Preview {
    NavigationStack {
        FriendListScreen(factory: ViewModelFactory())
            .withPreviewEnvironments()
    }
}
