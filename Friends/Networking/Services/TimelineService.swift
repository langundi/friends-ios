//
//  TimelineService.swift
//  Friends
//
//  Created by Ziqa on 29/07/26.
//

import Foundation

final class TimelineService {
    static let shared = TimelineService()
    private let client = APIClient.shared
    
    private init() { }
    
    func getTimeline() async throws -> [PostResponse] {
        let response: [PostResponse]
        response = try await client.request(endpoint: TimelineEndpoint.timeline)
        return response
    }
}
