//
//  AuthRootView.swift
//  Friends
//
//  Created by Ziqa on 02/08/26.
//

import SwiftUI

struct AuthRootView: View {
    @Environment(AuthRouter.self) var router
    @State private var authViewModel: AuthViewModel
    
    private let factory: ViewModelFactory
    
    init(factory: ViewModelFactory) {
        self.factory = factory
        self.authViewModel = factory.makeAuthViewModel()
    }
    
    var body: some View {
        @Bindable var router = router
        
        NavigationStack(path: $router.path) {
            ScreenEnum.signIn.build(factory: factory)
                .navigationDestination(for: ScreenEnum.self) { screen in
                    screen.build(factory: factory)
                }
        }
        .environment(authViewModel)
    }
}

#Preview {
    AuthRootView(factory: ViewModelFactory())
        .withPreviewEnvironments()
}
