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
    @State private var isPostLiked: Bool
    @State private var showComment: Bool = false
    
    init(viewModel: TimelineViewModel, post: PostResponse) {
        self.viewModel = viewModel
        self.post = post
        _isPostLiked = State(initialValue: post.likedByMe)
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            HStack(spacing: 12) {
                ProfilePictureView(imageURL: post.profilePicture, size: .xsmall)
                
                Text("@\(post.username)")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
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
                    LikeButton(liked: post.likedByMe) {
                        likeUnlikePost()
                    }
                    
                    CommentButton() {
                        showComment.toggle()
                    }
                }
                .layoutPriority(0)
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 80)
        .containerRelativeFrame(.vertical, alignment: .center)
        .sheet(isPresented: $showComment) {
            VStack {
                RepliesSheetView(viewModel: viewModel, postID: post.id)
            }
            .presentationDragIndicator(.visible)
            .presentationDetents([.large])
        }
    }
    
    private func likeUnlikePost() {
        if post.likedByMe {
            Task {
                await viewModel.unlikePost(id: post.id)
                withAnimation(.snappy) {
                    isPostLiked = false
                }
            }
        } else {
            Task {
                await viewModel.likePost(id: post.id)
                withAnimation(.snappy) {
                    isPostLiked = true
                }
            }
        }
    }
}

#Preview("Post") {
    PostView(viewModel: TimelineViewModel.mockTimeline, post: PostResponse.postDummy)
}

#Preview("Captionless") {
    PostView(viewModel: TimelineViewModel.mockTimeline, post: PostResponse.noCaptionPostDummy)
}
