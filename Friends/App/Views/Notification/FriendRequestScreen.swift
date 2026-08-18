//
//  FriendRequestScreen.swift
//  Friends
//
//  Created by Ziqa on 01/08/26.
//

import SwiftUI

struct FriendRequestScreen: View {
    @State private var viewModel: FriendRequestViewModel
    
    init(factory: ViewModelFactory) {
        _viewModel = State(initialValue: factory.makeFriendRequestViewModel())
    }
    
    var body: some View {
        Group {
            if viewModel.friendRequests.isEmpty {
                ContentUnavailableView {
                    Image(systemName: "person.2.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.gray)
                } description: {
                    Text("No friend requests.")
                }
            } else {
                ScrollView(.vertical) {
                    LazyVStack(alignment: .center, spacing: 0) {
                        ForEach(viewModel.friendRequests) { request in
                            FriendRequestView(id: request.id, username: request.senderUsername, viewModel: viewModel)
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
    }
}

#Preview {
    NavigationStack {
        FriendRequestScreen(factory: ViewModelFactory())
    }
    .withPreviewEnvironments()
}
