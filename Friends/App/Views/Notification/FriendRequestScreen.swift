//
//  FriendRequestScreen.swift
//  Friends
//
//  Created by Ziqa on 01/08/26.
//

import SwiftUI

struct FriendRequestScreen: View {
    @State private var viewModel: NotificationViewModel
    
    init(factory: ViewModelFactory) {
        _viewModel = State(initialValue: factory.makeNotificationViewModel())
    }
    
    var body: some View {
        Group {
            if viewModel.friendRequests.isEmpty {
                ScrollView {
                    ContentUnavailableView {
                        Image(systemName: "person.2.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.gray)
                    } description: {
                        Text("No friend requests.")
                    }
                }
            } else {
                ScrollView(.vertical) {
                    LazyVStack(alignment: .center, spacing: 0) {
                        ForEach(viewModel.friendRequests) { request in
                            FriendRequestView(id: request.id, username: request.senderUsername, imageURL: request.profilePicture, viewModel: viewModel)
                        }
                    }
                }
                .scrollIndicators(.hidden)
            }
        }
        .navigationTitle("Friend Requests")
        .navigationBarTitleDisplayMode(.inline)
        .overlay {
            if viewModel.isLoading {
                LoadingOverlay()
            }
        }
        .task {
            await viewModel.getFriendRequests()
        }
        .refreshable {
            await viewModel.refreshFriendRequests()
        }
    }
}

#Preview {
    NavigationStack {
        FriendRequestScreen(factory: ViewModelFactory())
    }
    .appPreviewEnvironments()
}
