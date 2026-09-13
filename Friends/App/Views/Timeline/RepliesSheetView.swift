//
//  RepliesSheetView.swift
//  Friends
//
//  Created by Ziqa on 25/08/26.
//

import SwiftUI

struct RepliesSheetView: View {
    @Environment(AppRouter.self) var router
    @State private var reply: String = ""
    @State private var selectedReply: ReplyResponse? = nil
    @State private var showReplyToUserSheet: Bool = false
    @FocusState private var isReplyFieldFocused: Bool
    var viewModel: TimelineViewModel
    var postID: Int
    var receiverID: Int
    
    init(viewModel: TimelineViewModel, postID: Int, receiverID: Int) {
        self.viewModel = viewModel
        self.postID = postID
        self.receiverID = receiverID
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.replies.isEmpty {
                    ContentUnavailableView("", systemImage: "bubble.right.fill", description: Text("Be the first one to reply!"))
                } else {
                    ScrollView(.vertical) {
                        LazyVStack(alignment: .leading, spacing: 24) {
                            ForEach(viewModel.replies) { reply in
                                HStack(alignment: .top, spacing: 16) {
                                    ProfilePictureView(imageURL: reply.profilePicture, size: .xsmall)
                                    
                                    VStack(alignment: .leading) {
                                        Text("@\(reply.username)")
                                        
                                        Text(reply.reply)
                                            .multilineTextAlignment(.leading)
                                    }
                                    
                                    Spacer(minLength: 0)
                                    
                                    if reply.repliedByMe {
                                        Menu("", systemImage: "ellipsis") {
                                            Button("Delete", systemImage: "trash") {
                                                Task {
                                                    await viewModel.deleteReply(id: postID, replyID: reply.id)
                                                    await viewModel.getReplies(id: postID)
                                                }
                                            }
                                        }
                                    } else {
                                        Button {
                                            selectedReply = reply
                                        } label: {
                                            Text("Reply")
                                        }
                                    }
                                }
                                
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 48)
                        .padding(.bottom, 60)
                    }
                    .scrollIndicators(.hidden)
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .overlay(alignment: .bottom) {
                HStack {
                    Group {
                        if #available(iOS 26.0, *) {
                            TextField("Write a reply...", text: $reply)
                                .focused($isReplyFieldFocused)
                                .padding(.leading)
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                                .glassEffect()
                        } else {
                            TextField("Write a reply...", text: $reply)
                                .padding(.leading)
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                        }
                    }
                    .layoutPriority(1)
                    .autocorrectionDisabled()
                    .onChange(of: reply) { _, newValue in
                        reply = String(newValue.prefix(60))
                    }
                    
                    Button {
                        Task {
                            await viewModel.replyPost(id: postID, reply: reply, receiverID: receiverID, postOwnerID: receiverID)
                            reply = ""
                            isReplyFieldFocused = false
                        }
                    } label: {
                        Image(systemName: "paperplane.fill")
                    }
                    .buttonStyle(ToolbarButtonStyle())
                }
                .padding()
            }
            .overlay(alignment: .center) {
                if viewModel.isSheetLoading {
                    LoadingOverlay()
                }
            }
            .sheet(item: $selectedReply) { reply in
                ReplyToUserScreen(viewModel: viewModel, reply: reply, postOwnerID: receiverID)
            }
            .task {
                await viewModel.getReplies(id: postID)
            }
        }
    }
}

#Preview {
    RepliesSheetView(viewModel: TimelineViewModel.mockTimeline, postID: 1, receiverID: 1)
}
