//
//  Router.swift
//  Friends
//
//  Created by Ziqa on 28/07/26.
//

import SwiftUI

enum ScreenEnum: Hashable {
    case signUp
    case signIn
    case timeline
    case notification
    case profile
    case friendList
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
    
    @ViewBuilder
    func build(_ screen: ScreenEnum) -> some View {
        switch screen {
        case .signUp:
            SignUpScreen()
        case .signIn:
            SignInScreen()
        case .timeline:
            TimelineScreen()
        case .notification:
            NotificationScreen()
        case .profile:
            ProfileScreen()
        case .friendList:
            FriendListScreen()
        }
    }
}
