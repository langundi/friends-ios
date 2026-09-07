//
//  PostScreen.swift
//  Friends
//
//  Created by Ziqa on 16/08/26.
//

import SwiftUI

struct PostScreen: View {
    let postID: Int
    @Environment(AppRouter.self) var router
    @State private var viewModel: TimelineViewModel
    @State private var showComment: Bool = false
    @State private var post: PostResponse?
    
    init(factory: ViewModelFactory, postID: Int) {
        _viewModel = State(initialValue: factory.makeTimelineViewModel())
        self.postID = postID
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            // bad implementation XD
            if viewModel.post != nil {
                Button {
                    router.push(to: .friendProfile(userID: viewModel.post!.userID, username: viewModel.post!.username))
                } label: {
                    HStack(spacing: 12) {
                        ProfilePictureView(imageURL: viewModel.post!.profilePicture, size: .xsmall)
                        
                        Text("@\(viewModel.post!.username)")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .buttonStyle(.plain)
                .contentShape(.rect)
                .allowsHitTesting(viewModel.post!.username != viewModel.username)
                
                ImageView(imageURL: viewModel.post!.imageURL)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .layoutPriority(1)
                
                HStack(alignment: .top) {
                    if viewModel.post!.caption != "" {
                        Text(viewModel.post!.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading)
                    }
                    
                    Spacer()
                    
                    HStack(alignment: .top, spacing: 16) {
                        CommentButton(replyCount: viewModel.post!.replyCount) {
                            showComment.toggle()
                        }
                        
                        LikeButton(liked: viewModel.post!.likedByMe, likeCount: viewModel.post!.likeCount) {
                            likeUnlikePost()
                        }
                    }
                    .layoutPriority(0)
                }
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 80)
        .containerRelativeFrame(.vertical, alignment: .center)
        .onChange(of: showComment) { _, newValue in
            if newValue == false {
                viewModel.clearReplies()
            }
        }
        .sheet(isPresented: $showComment) {
            if viewModel.post != nil {
                VStack {
                    RepliesSheetView(viewModel: viewModel, postID: viewModel.post!.id, receiverID: viewModel.post!.userID)
                }
                .presentationDragIndicator(.visible)
                .presentationDetents([.large])
            }
        }
        .task {
            await viewModel.getPost(postID: postID) { message in
                AlertManager.shared.showAlert(title: "An error occured", message: message, primaryAction: .init(title: "OK", action: router.pop))
            }
        }
        .onDisappear {
            viewModel.emptyPost()
        }
    }
    
    private func likeUnlikePost() {
        if viewModel.post != nil {
            if viewModel.post!.likedByMe {
                Task {
                    await viewModel.unlikePost(id: viewModel.post!.id)
                    viewModel.post!.likedByMe = false
                    viewModel.post!.likeCount -= 1
                }
            } else {
                Task {
                    await viewModel.likePost(id: viewModel.post!.id, receiverID: viewModel.post!.userID)
                    viewModel.post!.likedByMe = true
                    viewModel.post!.likeCount += 1
                }
            }
        }
    }
}

#Preview("Post") {
    PostView(viewModel: TimelineViewModel.mockTimeline, post: PostResponse.postDummy)
        .appPreviewEnvironments()
}

#Preview("Captionless") {
    PostView(viewModel: TimelineViewModel.mockTimeline, post: PostResponse.noCaptionPostDummy)
        .appPreviewEnvironments()
}
