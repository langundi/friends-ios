//
//  LikeButton.swift
//  Friends
//
//  Created by Ziqa on 16/08/26.
//


import SwiftUI
import Kingfisher
import OSLog

struct LikeButton: View {
    var liked: Bool = false
    var onAction: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            Button {
                onAction()
            } label: {
                Image(systemName: liked ? "heart.fill" : "heart")
                    .foregroundStyle(liked ? .red : .primary)
            }
            .buttonStyle(ToolbarButtonStyle())
        }
        .animation(.snappy(duration: 0.25), value: liked)
    }
}
