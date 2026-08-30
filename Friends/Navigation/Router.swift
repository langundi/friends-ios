//
//  Router.swift
//  Friends
//
//  Created by Ziqa on 28/07/26.
//

import SwiftUI

enum ScreenEnum: Hashable {
    case signIn
    case signUp
    case timeline
    case newPost
    case notification
    case friendRequest
    case profile
    case friendList
    case settings
    case editProfile
    case changePassword
    case deleteAccount
    case search
    
    @ViewBuilder
    func build(factory: ViewModelFactory) -> some View {
        switch self {
        case .signIn:
            SignInScreen(factory: factory)
        case .signUp:
            SignUpScreen(factory: factory)
        case .timeline:
            TimelineScreen(factory: factory)
        case .newPost:
            NewPostScreen(factory: factory)
        case .notification:
            NotificationScreen(factory: factory)
        case .friendRequest:
            FriendRequestScreen(factory: factory)
        case .profile:
            ProfileScreen(factory: factory)
        case .friendList:
            FriendListScreen(factory: factory)
        case .settings:
            SettingsScreen(factory: factory)
        case .editProfile:
            EditProfileScreen(factory: factory)
        case .changePassword:
            ChangePasswordScreen(factory: factory)
        case .deleteAccount:
            DeleteAccountScreen(factory: factory)
        case .search:
            SearchFriendScreen(factory: factory)
        }
    }
}

protocol Router {
    var path: NavigationPath { get set }
    func push(to screen: ScreenEnum)
    func pop()
    func popToRoot()
}

@Observable
final class AppRouter: Router {
    var path = NavigationPath()
    
    func push(to screen: ScreenEnum) {
        path.append(screen)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
}

@Observable
final class AuthRouter: Router {
    var path = NavigationPath()
    
    func push(to screen: ScreenEnum) {
        path.append(screen)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
}
