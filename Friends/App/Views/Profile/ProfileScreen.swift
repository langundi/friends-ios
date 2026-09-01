//
//  ProfileScreen.swift
//  Friends
//
//  Created by Ziqa on 01/08/26.
//

import SwiftUI
import Kingfisher
import OSLog

struct ProfileScreen: View {
    @AppStorage(Constants.isUserLoggedIn) var isLoggedIn: Bool = true
    @Environment(AppRouter.self) var router
    @Namespace private var namespace
    @State private var viewModel: ProfileViewModel
    @State private var timelineViewModel: TimelineViewModel
    
    private var columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 3)
    
    private var postCount: Int {
        viewModel.posts.count
    }
    
    private var friendCount: Int {
        viewModel.friends.count
    }
    
    init(factory: ViewModelFactory) {
        _viewModel = State(initialValue: factory.makeProfileViewModel())
        
        timelineViewModel = factory.timelineViewModel
    }
    
    var body: some View {
        ScrollView {
            HStack(spacing: 24) {
                ProfilePictureView(imageURL: viewModel.profilePicture, size: .medium)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("@\(viewModel.username)")
                        .font(.title3)
                        .fontWeight(.medium)
                    
                    HStack(alignment: .center, spacing: 32) {
                        Text("\(postCount) Posts")
                            .font(.title3)
                        
                        Button {
                            router.push(to: .friendList)
                        } label: {
                            Text("\(friendCount) Friends")
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
                            router.push(to: .profilePosts(selectedID: post.id, namespace: namespace))
                        }
                        .contextMenu {
                            Button(role: .destructive) {
                                Task {
                                    await viewModel.deletePost(id: post.id, objectKey: post.objectKey)
                                    await timelineViewModel.refreshTimeline()
                                }
                            } label: {
                                Label("Delete Post", systemImage: "trash")
                            }
                        }
                }
            }
            .padding([.leading, .trailing], 8)
            .padding(.bottom, 16)
        }
        .scrollIndicators(.hidden)
        .toolbarTitleDisplayMode(.inlineLarge)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    router.push(to: .settings)
                } label: {
                    Image(systemName: "gearshape")
                }
            }
        }
        .overlay(alignment: .center) {
            if viewModel.isLoading {
                LoadingOverlay()
            }
        }
        .task {
            await viewModel.loadProfileData()
        }
        .refreshable {
            await viewModel.refreshProfileData()
        }
    }
}

#Preview {
    NavigationStack {
        ProfileScreen(factory: ViewModelFactory())
    }
    .appPreviewEnvironments()
}
