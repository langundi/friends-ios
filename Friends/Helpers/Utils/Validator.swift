//
//  Validator.swift
//  Friends
//
//  Created by Ziqa on 27/08/26.
//

import Foundation

struct UsernameValidator {
    private static let validUsername = /^(?!.*[._]{2})[a-z0-9][a-z0-9._]{2,19}$/
    
    static func isValid(_ username: String) -> Bool {
        username.wholeMatch(of: validUsername) != nil
    }
}

struct EmailValidator {
    private static let validEmail = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/
    
    static func isValid(_ email: String) -> Bool {
        email.wholeMatch(of: validEmail) != nil
    }
}
