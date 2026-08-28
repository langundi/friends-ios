//
//  ChangePasswordViewModel.swift
//  Friends
//
//  Created by Ziqa on 28/08/26.
//

import Foundation

@Observable
final class ChangePasswordViewModel {
    
    var currentPassword = ""
    var newPassword = ""
    var confirmPassword = ""
    
    var unmetPasswordRules: [PasswordRule] {
        PasswordValidator.unmetRules(for: newPassword)
    }
    
    var passwordsMatch: Bool {
        confirmPassword.isEmpty || newPassword == confirmPassword
    }
    
    var canSubmit: Bool {
        unmetPasswordRules.isEmpty
        && !confirmPassword.isEmpty
        && newPassword == confirmPassword
    }
    
    private let userService: UserService
    
    init(userService: UserService) {
        self.userService = userService
    }
    
}
