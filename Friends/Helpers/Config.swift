//
//  Config.swift
//  Friends
//
//  Created by Ziqa on 09/09/26.
//

import Foundation

enum Config {
    static let apiBaseURL: String = {
        guard let url = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String else {
            fatalError("API_BASE_URL not set in Info.plist")
        }
        return url
    }()
}
