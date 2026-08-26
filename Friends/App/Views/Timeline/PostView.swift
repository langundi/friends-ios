//
//  PostView.swift
//  Friends
//
//  Created by Ziqa on 16/08/26.
//

import SwiftUI

struct PostView: View {
    var viewModel: TimelineViewModel
    @State var post: PostResponse
    @State private var showComment: Bool = false
    
    init(viewModel: TimelineViewModel, post: PostResponse) {
        self.viewModel = viewModel
        self.post = post
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            HStack(spacing: 12) {
                Circle()
                    .frame(maxWidth: 40, maxHeight: 40)
                
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
        .padding()
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
                    post.likedByMe = false
                    post.likeCount -= 1
                }
            }
        } else {
            Task {
                await viewModel.likePost(id: post.id)
                withAnimation(.snappy) {
                    post.likedByMe = true
                    post.likeCount += 1
                }
            }
        }
    }
}

#Preview("Post") {
    let vm = TimelineViewModel(timelineStore: TimelineStore(postService: PostService(client: APIClient.shared)))
    PostView(viewModel: vm, post: PostResponse.postDummy)
}

#Preview("Captionless") {
    let vm = TimelineViewModel(timelineStore: TimelineStore(postService: PostService(client: APIClient.shared)))
    PostView(viewModel: vm, post: PostResponse.noCaptionPostDummy)
}
