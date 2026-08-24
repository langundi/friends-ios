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
    var onAction: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            Button {
                onAction()
            } label: {
                Image(systemName: "bubble.right")
            }
            .buttonStyle(ToolbarButtonStyle())
        }
    }
}
