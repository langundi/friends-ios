//
//  Error+Extensions.swift
//  Friends
//
//  Created by Ziqa on 20/08/26.
//

import Foundation

extension Error {
    var isCancellation: Bool {
        if self is CancellationError { return true }
        if let urlError = self as? URLError, urlError.code == .cancelled { return true }
        return false
    }
}
