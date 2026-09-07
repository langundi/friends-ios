//
//  TimelineScreen.swift
//  Friends
//
//  Created by Ziqa on 28/07/26.
//

import SwiftUI
import Kingfisher
import OSLog

struct TimelineScreen: View {
    @Environment(AppRouter.self) var router
    @Environment(\.scenePhase) var scenePhase
    @State private var viewModel: TimelineViewModel
    @State private var notificationViewModel: NotificationViewModel
    init(factory: ViewModelFactory) {
        _viewModel = State(initialValue: factory.makeTimelineViewModel())
        _notificationViewModel = State(initialValue: factory.makeNotificationViewModel())
    }
    
    var body: some View {
        TimelineStackView(viewModel: viewModel)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        router.push(to: .notification)
                    } label: {
                        Label("Notifications", systemImage: "bell")
                            .labelStyle(.iconOnly)
                    }
                    .badge(notificationViewModel.notifications.count(where: { $0.isRead == false }))
                    
                    Button {
                        router.push(to: .newPost)
                    } label: {
                        Label("New Post", systemImage: "plus")
                            .labelStyle(.iconOnly)
                    }
                }
            }
            .overlay(alignment: .center) {
                if viewModel.isLoading {
                    LoadingOverlay()
                }
            }
            .task {
                await notificationViewModel.getNotifications() // load notification badge
                await viewModel.getTimeline()
            }
            .environment(viewModel)
    }
}

#Preview {
    NavigationStack {
        TimelineScreen(factory: ViewModelFactory())
    }
    .appPreviewEnvironments()
}

#Preview("With Posts") {
    NavigationStack {
        TimelineStackView(viewModel: TimelineViewModel.mockTimeline)
            .navigationTitle("Timeline")
            .navigationBarTitleDisplayMode(.inline)
    }
    .appPreviewEnvironments()
}
