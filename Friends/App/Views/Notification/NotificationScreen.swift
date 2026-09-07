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
        List {
            ForEach(viewModel.notifications) { notification in
                HStack(spacing: 16) {
                    ProfilePictureView(imageURL: notification.profilePicture, size: .small)
                    
                    VStack(alignment: .leading) {
                        Text(notification.message)
                        
                        Text(formatDate(date: notification.createdAt))
                            .foregroundStyle(.secondary)
                    }
                }
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
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
                //                .badge(viewModel.friendRequest)
            }
        }
        .overlay(alignment: .center) {
            if viewModel.isLoading {
                LoadingOverlay()
            }
        }
        .task {
            await viewModel.getAllNotification()
        }
        .refreshable {
            await viewModel.refreshNotifications()
        }
    }
}

#Preview {
    NavigationStack {
        NotificationScreen(factory: ViewModelFactory())
    }
    .appPreviewEnvironments()
}
