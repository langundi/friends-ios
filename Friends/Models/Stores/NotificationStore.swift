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
    
    func loadNotificationsIfNeeded() async throws {
        if let lastFetchAt, Date().timeIntervalSince(lastFetchAt) < staleDuration {
            return
        }
        try await getNotifications()
    }
    
    func invalidateLastFetch() {
        lastFetchAt = nil
    }
    
    func getNotifications() async throws {
        notifications = try await notificationService.getNotifications() ?? []
        lastFetchAt = Date()
    }
}
