//
//  CommentButton.swift
//  Friends
//
//  Created by Ziqa on 16/08/26.
//


import SwiftUI
import Kingfisher
import OSLog

struct CommentButton: View {
    var replyCount: Int
    var onAction: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            Button {
                onAction()
            } label: {
                HStack {
                    Image(systemName: "bubble.right")
                    
                    Text("\(replyCount)")
                        .monospaced()
                }
                .padding(.horizontal, 8)
            }
            .buttonStyle(ToolbarButtonStyle())
        }
    }
}
