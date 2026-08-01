//
//  FriendsApp.swift
//  Friends
//
//  Created by Ziqa on 28/07/26.
//

import SwiftUI

@main
struct FriendsApp: App {
    @State private var router = AppRouter()
    @State private var alert = AlertManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(router)
                .environment(alert)
        }
    }
}
