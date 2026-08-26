//
//  RepliesSheetView.swift
//  Friends
//
//  Created by Ziqa on 25/08/26.
//

import SwiftUI

struct RepliesSheetView: View {
    var viewModel: TimelineViewModel
    var postID: Int
    @State private var reply: String = ""
    
    init(viewModel: TimelineViewModel, postID: Int) {
        self.viewModel = viewModel
        self.postID = postID
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
                                    Circle()
                                        .foregroundStyle(.gray.opacity(0.15))
                                        .frame(maxWidth: 45, maxHeight: 45)
                                    
                                    VStack(alignment: .leading, spacing: 12) {
                                        HStack(alignment: .top) {
                                            Text("@\(reply.username)")
                                            
                                            Spacer(minLength: 0)
                                            
                                            if reply.repliedByMe {
                                                Menu("", systemImage: "ellipsis") {
                                                    Button("Delete", systemImage: "trash") {
                                                        Task {
                                                            await viewModel.deleteReply(id: reply.id)
                                                            await viewModel.getReplies(id: postID)
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        
                                        Text(reply.reply)
                                            .multilineTextAlignment(.leading)
                                    }
                                    .padding(.vertical, 4)
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
                            await viewModel.replyPost(id: postID, reply: reply)
                            reply = ""
                        }
                    } label: {
                        Image(systemName: "paperplane.fill")
                    }
                    .buttonStyle(ToolbarButtonStyle())
                }
                .padding(.horizontal)
            }
            .overlay(alignment: .center) {
                if viewModel.isSheetLoading {
                    LoadingOverlay()
                }
            }
            .task {
                await viewModel.getReplies(id: postID)
            }
        }
    }
}

#Preview {
    RepliesSheetView(viewModel: TimelineViewModel(timelineStore: TimelineStore(postService: PostService(client: APIClient.shared))), postID: 1)
}
