//
//  ContentView.swift
//  Friends
//
//  Created by Ziqa on 28/07/26.
//

import SwiftUI

struct ContentView: View {
    @AppStorage(Constants.isUserLoggedIn) var isLoggedIn: Bool = false
    @State private var alert = AlertManager.shared
    @State private var authRouter = AuthRouter()
    @State private var factory = ViewModelFactory()
    
    var body: some View {
        @Bindable var router = authRouter
        @Bindable var alert = alert
        
        Group {
            if isLoggedIn {
                TabRootView(factory: factory)
                .transition(.opacity)
            } else {
                AuthRootView(factory: factory)
                .transition(.opacity)
                .environment(authRouter)
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
            factory = ViewModelFactory()
            router.popToRoot()
        }
        .animation(.snappy(duration: 0.25), value: isLoggedIn)
    }
}

#Preview {
    ContentView()
        .appPreviewEnvironments()
}
