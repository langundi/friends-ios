//
//  ReplyToUserScreen.swift
//  Friends
//
//  Created by Ziqa on 12/09/26.
//

import SwiftUI

struct ReplyToUserScreen: View {
    let viewModel: TimelineViewModel
    var reply: ReplyResponse
    let postOwnerID: Int
    @Environment(\.dismiss) var dismiss
    @State private var replyText: String = ""
    @FocusState private var isReplyFieldFocused: Bool
    
    
    init(viewModel: TimelineViewModel, reply: ReplyResponse, postOwnerID: Int) {
        self.viewModel = viewModel
        self.reply = reply
        self.postOwnerID = postOwnerID
    }
    
    var body: some View {
        NavigationStack {
            HStack(alignment: .top, spacing: 16) {
                ProfilePictureView(imageURL: reply.profilePicture, size: .xsmall)
                
                VStack(alignment: .leading) {
                    Text("@\(reply.username)")
                    
                    Text(reply.reply)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Reply to \(reply.username)")
            .navigationBarTitleDisplayMode(.inline)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .overlay(alignment: .bottom) {
                HStack {
                    Group {
                        if #available(iOS 26.0, *) {
                            TextField("Write a reply...", text: $replyText)
                                .focused($isReplyFieldFocused)
                                .padding(.leading)
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                                .glassEffect()
                        } else {
                            TextField("Write a reply...", text: $replyText)
                                .padding(.leading)
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                        }
                    }
                    .layoutPriority(1)
                    .autocorrectionDisabled()
                    .onChange(of: replyText) { _, newValue in
                        replyText = String(newValue.prefix(60))
                    }
                    
                    Button {
                        Task {
                            let finalReply = "@\(reply.username) " + replyText
                            await viewModel.replyUser(id: reply.postID, reply: finalReply, receiverID: reply.userID, postOwnerID: postOwnerID)
                            isReplyFieldFocused = false
                            dismiss()
                        }
                    } label: {
                        Image(systemName: "paperplane.fill")
                    }
                    .buttonStyle(ToolbarButtonStyle())
                }
                .padding()
            }
        }
    }
}

#Preview {
    ReplyToUserScreen(viewModel: TimelineViewModel.mockTimeline, reply: ReplyResponse.mockReply, postOwnerID: 1)
}
