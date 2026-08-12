//
//  NotificationScreen.swift
//  Friends
//
//  Created by Ziqa on 29/07/26.
//

import SwiftUI

struct NotificationScreen: View {
    @Environment(AppRouter.self) var router
    @State private var viewModel: NotificationViewModel
    
    init(factory: ViewModelFactory) {
        _viewModel = State(initialValue: factory.makeNotificationViewModel())
    }
    
    var body: some View {
        Group {
            List {
                ForEach(0..<10) { i in
                    HStack(spacing: 16) {
                        Circle()
                            .frame(maxWidth: 50, maxHeight: 50)
                        
                        VStack(alignment: .leading) {
                            Text("@manny")
                                .font(.headline)
                            
                            HStack {
                                Text("Liked your post")
                                
                                Text("Today")
                                    .foregroundStyle(.secondary)
                            }
                        }
                            .padding(.vertical)
                    }
                    .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    router.push(to: .friendRequest)
                } label: {
                    Label("Friend Request", systemImage: "person.badge.plus")
                        .labelStyle(.iconOnly)
                }
                .badge(viewModel.friendRequest)
            }
        }
    }
}

#Preview {
    NavigationStack {
        NotificationScreen(factory: ViewModelFactory())
    }
    .withPreviewEnvironments()
}
