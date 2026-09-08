//
//  FriendListScreen2.swift
//  Friends
//
//  Created by Ziqa on 01/08/26.
//

import SwiftUI

struct FriendListScreen2: View {
    @Environment(AppRouter.self) var router
    @State private var viewModel: FriendProfileViewModel
    
    let userID: Int
    
    var friendsWithYou: [FriendsFriendResponse] {
        viewModel.friends.filter { ($0.friendsWithMe) }
    }
    
    var notFriendsWithYou: [FriendsFriendResponse] {
        viewModel.friends.filter { (!$0.friendsWithMe) }
    }
    
    init(factory: ViewModelFactory, userID: Int) {
        _viewModel = State(initialValue: factory.makeFriendProfileViewModel())
        self.userID = userID
    }
    
    var body: some View {
        List {
            if !friendsWithYou.isEmpty {
                Section {
                    ForEach(friendsWithYou) { friend in
                        FriendRowView2(id: friend.userID, username: friend.username, friendsWithMe: friend.friendsWithMe, imageURL: friend.profilePicture)
                        .listRowSeparator(.hidden)
                    }
                }
            }
            
            if !notFriendsWithYou.isEmpty {
                Section("Not friends with you") {
                    ForEach(notFriendsWithYou) { friend in
                        FriendRowView2(id: friend.userID, username: friend.username, friendsWithMe: friend.friendsWithMe, imageURL: friend.profilePicture) {
                            router.push(to: .search(username: friend.username))
                        }
                        .listRowSeparator(.hidden)
                    }
                }
            }
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
        .navigationTitle("Friends")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.getFriendList(id: userID)
        }
    }
}

#Preview {
    NavigationStack {
        FriendListScreen(factory: ViewModelFactory())
            .appPreviewEnvironments()
    }
}
