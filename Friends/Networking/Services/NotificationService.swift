//
//  NotificationService.swift
//  Friends
//
//  Created by Ziqa on 06/09/26.
//

import Foundation

final class NotificationService {
    
    private let client: APIClient
    
    init(client: APIClient) {
        self.client = client
    }
    
    func getNotifications() async throws -> [NotificationResponse]? {
        try await client.requestOptional(endpoint: NotificationEndpoint.getAllNotifications)
    }
    
    func readNotifications() async throws {
        try await client.requestVoid(endpoint: NotificationEndpoint.readNotifications)
    }
}
