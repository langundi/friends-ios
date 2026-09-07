//
//  NotificationStore.swift
//  Friends
//
//  Created by Ziqa on 07/09/26.
//

import Foundation

final class NotificationStore {
    
    private(set) var notifications: [NotificationResponse] = []
    private var lastFetchAt: Date?
    private let staleDuration: TimeInterval = 500
    
    private let notificationService: NotificationService
    
    init(notificationService: NotificationService) {
        self.notificationService = notificationService
    }
    
    /// Load notifications with stale duration.
    func loadNotificationsIfNeeded() async throws {
        if let lastFetchAt, Date().timeIntervalSince(lastFetchAt) < staleDuration {
            return
        }
        try await getNotifications()
    }
    
    func invalidateLastFetch() {
        lastFetchAt = nil
    }
    
    /// Fetch all notification.
    func getNotifications() async throws {
        notifications = try await notificationService.getNotifications() ?? []
        lastFetchAt = Date()
    }
    
    /// Read unread notifications.
    func readNotifications() async throws {
        guard notifications.contains(where: { $0.isRead == false }) else {
            return
        }
        
        try await notificationService.readNotifications()
        for index in notifications.indices {
            notifications[index].isRead = true
        }
    }
}
