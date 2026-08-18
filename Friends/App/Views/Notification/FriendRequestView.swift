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
    var viewModel: FriendRequestViewModel
    
    var body: some View {
        HStack(spacing: 24) {
            Circle()
                .foregroundStyle(.gray.opacity(0.15))
                .frame(maxWidth: 50, maxHeight: 50)
            
            Text("@\(username)")
            
            Spacer(minLength: 0)
            
            Button("Decline", role: .destructive) {
                Task {
                    await viewModel.declineFriendRequest(id: id)
                }
            }
            
            Button("Accept") {
                Task {
                    await viewModel.acceptFriendRequest(id: id)
                }
            }
            .foregroundStyle(.blue)
        }
        .padding(.horizontal)
    }
}
