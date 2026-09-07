//
//  FriendRowView.swift
//  Friends
//
//  Created by Ziqa on 19/08/26.
//

import SwiftUI

struct FriendRowView: View {
    @Environment(AppRouter.self) var router
    var id: Int
    var username: String
    var imageURL: String?
    var onUnfriendAction: () -> Void
    var onBlockAction: () -> Void
    
    var body: some View {
        HStack(spacing: 24) {
            Button {
                router.push(to: .friendProfile(userID: id, username: username))
            } label: {
                HStack(spacing: 12) {
                    ProfilePictureView(imageURL: imageURL, size: .small)
                    
                    Text("@\(username)")
                        .padding(.vertical)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(.rect)
            }
            .buttonStyle(.plain)
            
            Menu("", systemImage: "ellipsis") {
                Button("Unfriend", systemImage: "person.slash.fill") {
                    onUnfriendAction()
                }
                
                Button("Block", systemImage: "nosign") {
                    onBlockAction()
                }
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    FriendRowView(id: 1, username: "kolin", imageURL: nil) {
        
    } onBlockAction: {
        
    }
    .appPreviewEnvironments()
}
