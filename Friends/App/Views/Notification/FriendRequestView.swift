//
//  FriendRequestView.swift
//  Friends
//
//  Created by Ziqa on 18/08/26.
//

import SwiftUI

struct FriendRequestView: View {
    var id: Int
    var username: String
    let senderID: Int
    let imageURL: String?
    var viewModel: NotificationViewModel
    
    var body: some View {
        HStack(spacing: 24) {
            ProfilePictureView(imageURL: imageURL, size: .small)
            
            Text("@\(username)")
            
            Spacer(minLength: 0)
            
            Button("Decline", role: .destructive) {
                Task {
                    await viewModel.declineFriendRequest(id: id)
                }
            }
            
            Button("Accept") {
                Task {
                    await viewModel.acceptFriendRequest(id: id, senderID: senderID)
                }
            }
            .foregroundStyle(.blue)
        }
        .padding(.horizontal)
    }
}
