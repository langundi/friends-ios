//
//  PostView.swift
//  Friends
//
//  Created by Ziqa on 16/08/26.
//

import SwiftUI

struct PostView: View {
    var viewModel: TimelineViewModel
    var post: PostResponse
    @Environment(AppRouter.self) var router
    @State private var showComment: Bool = false
    
    init(viewModel: TimelineViewModel, post: PostResponse) {
        self.viewModel = viewModel
        self.post = post
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            Button {
                router.push(to: .friendProfile(userID: post.userID, username: post.username))
            } label: {
                HStack(spacing: 12) {
                    ProfilePictureView(imageURL: post.profilePicture, size: .xsmall)
                    
                    Text("@\(post.username)")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(.plain)
            .contentShape(.rect)
            .allowsHitTesting(post.username != viewModel.username)
            
            ImageView(imageURL: post.imageURL)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .layoutPriority(1)
            
            HStack(alignment: .top) {
                if post.caption != "" {
                    Text(post.caption)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading)
                }
                
                Spacer()
                
                HStack(alignment: .top, spacing: 16) {
                    CommentButton(replyCount: post.replyCount) {
                        showComment.toggle()
                    }
                    
                    LikeButton(liked: post.likedByMe, likeCount: post.likeCount) {
                        likeUnlikePost()
                    }
                }
                .layoutPriority(0)
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
            VStack {
                RepliesSheetView(viewModel: viewModel, postID: post.id, receiverID: post.userID)
            }
            .presentationDragIndicator(.visible)
            .presentationDetents([.large])
        }
    }
    
    private func likeUnlikePost() {
        if post.likedByMe {
            Task {
                await viewModel.unlikePost(id: post.id)
            }
        } else {
            Task {
                await viewModel.likePost(id: post.id, receiverID: post.userID)
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
