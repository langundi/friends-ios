//
//  FriendProfileScreen.swift
//  Friends
//
//  Created by Ziqa on 01/08/26.
//

import SwiftUI
import Kingfisher
import OSLog

struct FriendProfileScreen: View {
    @Environment(AppRouter.self) var router
    @Namespace private var namespace
    @State private var viewModel: FriendProfileViewModel
    
    let userID: Int
    let username: String
    
    private var columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 3)
    
    init(factory: ViewModelFactory, userID: Int, username: String) {
        _viewModel = State(initialValue: factory.makeFriendProfileViewModel())
        
        self.userID = userID
        self.username = username
    }
    
    var body: some View {
        ScrollView {
            HStack(spacing: 24) {
                ProfilePictureView(imageURL: viewModel.profilePicture, size: .medium)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("@\(username)")
                        .font(.title3)
                        .fontWeight(.medium)
                    
                    HStack(alignment: .center, spacing: 32) {
                        Text("\(viewModel.posts.count) Posts")
                            .font(.title3)
                        
                        Button {
//                            router.push(to: .friendList)
                        } label: {
                            Text("\(0) Friends")
                                .font(.title3)
                        }
                        .buttonStyle(.plain)
                    }
                }
                
                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity)
            .padding()
            
            LazyVGrid(columns: columns, alignment: .center, spacing: 8) {
                ForEach(viewModel.posts) { post in
                    ImageView(imageURL: post.imageURL)
                        .matchedTransitionSource(id: post.id, in: namespace)
                        .onTapGesture {
                            router.push(to: .friendProfilePosts(selectedID: post.id, namespace: namespace))
                        }
                }
            }
            .padding([.leading, .trailing], 8)
            .padding(.bottom, 16)
        }
        .navigationBarTitleDisplayMode(.inline)
        .scrollIndicators(.hidden)
        .toolbarTitleDisplayMode(.inlineLarge)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Menu("", systemImage: "ellipsis") {
                    Button("Unfriend", systemImage: "person.slash.fill") {
                        
                    }
                    
                    Button("Block", systemImage: "nosign") {
                        
                    }
                }
            }
        }
        .overlay(alignment: .center) {
            if viewModel.isLoading {
                LoadingOverlay()
            }
        }
        .task {
            await viewModel.loadProfileAndPosts(id: userID)
        }
        .refreshable {
            await viewModel.loadProfileAndPosts(id: userID)
        }
    }
}

#Preview {
    NavigationStack {
        FriendProfileScreen(factory: ViewModelFactory(), userID: 1, username: "kolin")
    }
    .appPreviewEnvironments()
}
