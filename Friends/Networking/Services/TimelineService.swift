//
//  TimelineService.swift
//  Friends
//
//  Created by Ziqa on 29/07/26.
//

import Foundation

final class TimelineService {
    private let client: APIClient
    
    init(client: APIClient) {
        self.client = client
    }
    
    func getTimeline() async throws -> [PostResponse] {
        let response: [PostResponse]
        response = try await client.request(endpoint: TimelineEndpoint.timeline)
        return response
    }
}
