//
//  FriendRowView.swift
//  Friends
//
//  Created by Ziqa on 19/08/26.
//

import SwiftUI

struct FriendRowView: View {
    var username: String
    var imageURL: String?
    var onUnfriendAction: () -> Void
    var onBlockAction: () -> Void
    
    var body: some View {
        HStack(spacing: 24) {
            ProfilePictureView(imageURL: imageURL, size: .small)
            
            Text("@\(username)")
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
