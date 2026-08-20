//
//  PostView.swift
//  Friends
//
//  Created by Ziqa on 16/08/26.
//

import SwiftUI

struct PostView: View {
    var post: PostResponse
    
    @State private var showComment: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            HStack(spacing: 12) {
                Circle()
                    .frame(maxWidth: 40, maxHeight: 40)
                
                Text("@username")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            ImageView(imageURL: post.imageURL)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            
            HStack(alignment: .top) {
                if post.caption != "" {
                    Text(post.caption)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                
                Spacer()
                
                HStack(spacing: 16) {
                    LikeButton() {
                        print("like pressed")
                    }
                    
                    CommentButton() {
                        showComment.toggle()
                    }
                }
            }
        }
        .padding()
        .containerRelativeFrame(.vertical, alignment: .center)
        .sheet(isPresented: $showComment) {
            VStack {
                Text("Comment Sheet")
            }
            .presentationDragIndicator(.visible)
            .presentationDetents([.fraction(0.8)])
        }
    }
}

#Preview("Post") {
    PostView(post: PostResponse.singlePost)
}

#Preview("Captionless") {
    PostView(post: PostResponse.noCaptionPost)
}
