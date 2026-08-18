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
                List {
                    ForEach(viewModel.friendRequests) { request in
                        HStack(spacing: 24) {
                            Circle()
                                .foregroundStyle(.gray.opacity(0.15))
                                .frame(maxWidth: 50, maxHeight: 50)
                            
                            Text(request.senderUsername)
                            
                            Spacer(minLength: 0)
                            
                            Button("Decline", role: .destructive) {
                                Task {
                                    await viewModel.declineFriendRequest(id: request.id)
                                }
                            }
                            
                            Button("Accept") {
                                
                            }
                            .foregroundStyle(.blue)
                        }
                        .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
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
