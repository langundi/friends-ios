//
//  ContentView.swift
//  Friends
//
//  Created by Ziqa on 28/07/26.
//

import SwiftUI

struct ContentView: View {
    @AppStorage(Constants.isUserLoggedIn) var isLoggedIn: Bool = false
    @Environment(AppRouter.self) var router
    @Environment(AlertManager.self) var alert
    
    var body: some View {
        @Bindable var router = router
        @Bindable var alert = alert
        
        Group {
            if isLoggedIn {
                TabRootView()
                .transition(.opacity)
            } else {
                NavigationStack(path: $router.path) {
                    router.build(.signIn)
                        .navigationDestination(for: ScreenEnum.self) { screen in
                            router.build(screen)
                        }
                }
                .transition(.opacity)
            }
        }
        .alert(alert.alertTitle, isPresented: $alert.isShowingAlert) {
            if let primary = alert.primaryAction {
                Button(primary.title) {
                    primary.action?()
                }
                .keyboardShortcut(.defaultAction)
            }
            
            if let secondary = alert.secondaryAction {
                Button(secondary.title) {
                    secondary.action?()
                }
            }
        } message: {
            Text(alert.alertMessage)
        }
        .onChange(of: isLoggedIn) {
            router.popToRoot()
        }
        .animation(.snappy(duration: 0.25), value: isLoggedIn)
    }
}

#Preview {
    ContentView()
        .withPreviewEnvironments()
}
