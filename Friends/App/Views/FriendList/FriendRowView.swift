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

struct FriendRowView2: View {
    @Environment(AppRouter.self) var router
    var id: Int
    var username: String
    var friendsWithMe: Bool
    var imageURL: String?
    var onAddAction: (() -> Void)?
    
    var body: some View {
        HStack(spacing: 24) {
            Button {
                if friendsWithMe {
                    router.push(to: .friendProfile(userID: id, username: username))
                }
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
            
            if let onAddAction {
                Button {
                    onAddAction()
                } label: {
                    HStack {
                        Image(systemName: "plus")
                            .fontWeight(.medium)
                        
                        Text("Add")
                            .fontWeight(.semibold)
                    }
                    .foregroundStyle(.blue)
                }
            }
        }
    }
}

#Preview {
    FriendRowView(id: 1, username: "kolin", imageURL: nil) {
        
    } onBlockAction: {
        
    }
    .appPreviewEnvironments()
}
