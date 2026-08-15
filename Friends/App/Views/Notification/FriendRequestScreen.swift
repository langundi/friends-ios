//
//  FriendRequestScreen.swift
//  Friends
//
//  Created by Ziqa on 01/08/26.
//

import SwiftUI

struct FriendRequestScreen: View {
    @State private var viewModel: FriendRequestViewModel
    
    init(factory: ViewModelFactory) {
        _viewModel = State(initialValue: factory.makeFriendRequestViewModel())
    }
    
    var body: some View {
        List {
            ForEach(0..<viewModel.friendRequest, id: \.self) { i in
                HStack(spacing: 24) {
                    Circle()
                        .foregroundStyle(.gray.opacity(0.15))
                        .frame(maxWidth: 50, maxHeight: 50)
                    
                    Text("@username")
                    
                    Spacer(minLength: 0)
                    
                    Button("Decline", role: .destructive) {
                        
                    }
                    
                    if #available(iOS 26.0, *) {
                        Button("Accept", role: .confirm) {
                            
                        }
                        .foregroundStyle(.blue)
                    } else {
                        Button("Accept") {
                            
                        }
                        .foregroundStyle(.blue)
                    }
                }
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
        .navigationTitle("Friend Requests")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        FriendRequestScreen(factory: ViewModelFactory())
    }
    .withPreviewEnvironments()
}
