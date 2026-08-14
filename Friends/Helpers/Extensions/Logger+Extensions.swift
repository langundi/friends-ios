//
//  Logger+Extensions.swift
//  Friends
//
//  Created by Ziqa on 14/08/26.
//

import Foundation
import OSLog

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!
    
    static let network = Logger(subsystem: subsystem, category: "network")
    static let system = Logger(subsystem: subsystem, category: "system")
    static let kingfisher = Logger(subsystem: subsystem, category: "kingfisher")
}
