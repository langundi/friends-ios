//
//  FriendRowView.swift
//  Friends
//
//  Created by Ziqa on 19/08/26.
//

import SwiftUI

struct FriendRowView: View {
    var username: String
    var onUnfriendAction: () -> Void
    var onBlockAction: () -> Void
    
    var body: some View {
        HStack(spacing: 24) {
            Circle()
                .foregroundStyle(.gray.opacity(0.15))
                .frame(maxWidth: 50, maxHeight: 50)
            
            Text("@\(username)")
                .font(.headline)
                .padding(.vertical)
            
            Spacer(minLength: 0)
            
            Menu("", systemImage: "ellipsis") {
                Button("Unfriend", systemImage: "person.slash.fill") {
                    onUnfriendAction()
                }
                
                Button("Block", systemImage: "nosign") {
                    onBlockAction()
                }
            }
        }
    }
}
