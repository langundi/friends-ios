//
//  DeviceService.swift
//  Friends
//
//  Created by Ziqa on 04/09/26.
//

import Foundation

final class DeviceService {
    
    private let client: APIClient
    
    init(client: APIClient) {
        self.client = client
    }
    
    func registerDeviceToken(request: DeviceTokenRequest) async throws {
        try await client.requestVoid(endpoint: DeviceTokenEndpoint.register(request: request))
    }
    
    func deleteDeviceToken(request: DeviceTokenRequest) async throws {
        try await client.requestVoid(endpoint: DeviceTokenEndpoint.delete(request: request))
    }
}
