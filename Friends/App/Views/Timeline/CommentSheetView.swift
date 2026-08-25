//
//  CommentSheetView.swift
//  Friends
//
//  Created by Ziqa on 25/08/26.
//

import SwiftUI

struct CommentSheetView: View {
    @State private var reply: String = ""
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(alignment: .leading, spacing: 16) {
                    ForEach(0..<6, id: \.self) { comment in
                        HStack(alignment: .top, spacing: 16) {
                            Circle()
                                .foregroundStyle(.gray.opacity(0.15))
                                .frame(maxWidth: 45, maxHeight: 45)
                            
                            VStack(alignment: .leading) {
                                Text("@username")
                                
                                Text("Lorem ipsum dolor sit amet, ex officia magna nulla irure. Occaecat velit incididunt id voluptate fugiat reprehenderit enim. Tempor dolor et excepteur fugiat deserunt laborum velit.")
                                    .multilineTextAlignment(.leading)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 60)
            }
            .scrollIndicators(.hidden)
            .navigationTitle("Replies")
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
                        // send
                    } label: {
                        Image(systemName: "paperplane.fill")
                    }
                    .buttonStyle(ToolbarButtonStyle())
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    CommentSheetView()
}
