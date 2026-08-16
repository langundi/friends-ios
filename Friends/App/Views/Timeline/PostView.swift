//
//  PostView.swift
//  Friends
//
//  Created by Ziqa on 16/08/26.
//

import SwiftUI
import Kingfisher
import OSLog

struct PostView: View {
    var post: PostResponse
    
    @State private var showComment: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            HStack(spacing: 12) {
                Circle()
                    .frame(maxWidth: 45, maxHeight: 45)
                
                Text("@username")
                    .font(.title3)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            KFImage(URL(string: post.imageURL))
                .resizable()
                .onFailure { error in
                    Logger.kingfisher.error("KF Error: \(error)")
                }
                .frame(maxWidth: .infinity)
                .aspectRatio(1.0, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            
            HStack(alignment: .top) {
                if post.caption != "" {
                    Text(post.caption)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Spacer()
                
                HStack(spacing: 16) {
                    CommentButton() {
                        showComment.toggle()
                    }
                    
                    LikeButton() {
                        print("like pressed")
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

#Preview {
    PostView(post: PostResponse.singlePost)
}
