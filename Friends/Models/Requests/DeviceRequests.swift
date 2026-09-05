//
//  DeviceRequests.swift
//  Friends
//
//  Created by Ziqa on 04/09/26.
//

import Foundation

struct DeviceTokenRequest: Encodable {
    let deviceToken: String
    
    enum CodingKeys: String, CodingKey {
        case deviceToken = "device_token"
    }
}
