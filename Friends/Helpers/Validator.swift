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

struct PasswordRule {    
    let description: String
    let regex: Regex<Substring>
}

enum PasswordValidator {
    static let rules: [PasswordRule] = [
        PasswordRule(description: "At least 8 charactets", regex: /.{8,}/),
        PasswordRule(description: "One special character (!@#$%^&*)", regex: /[!@#$%^&*]/),
        PasswordRule(description: "One digit", regex: /\d/),
    ]
    
    static func unmetRules(for password: String) -> [PasswordRule] {
        rules.filter { password.firstMatch(of: $0.regex) == nil }
    }
    
    static func isStrong(_ password: String) -> Bool {
        unmetRules(for: password).isEmpty
    }
}
