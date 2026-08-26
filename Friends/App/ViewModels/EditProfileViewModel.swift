//
//  EditProfileViewModel.swift
//  Friends
//
//  Created by Ziqa on 26/08/26.
//

import Foundation

@Observable
final class EditProfileViewModel {
    
    var username: String {
        userStore.username
    }
    
    var email: String {
        userStore.email
    }
    
    private let userStore: UserStore
    
    init(userStore: UserStore) {
        self.userStore = userStore
    }
}
