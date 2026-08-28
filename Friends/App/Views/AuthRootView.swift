//
//  AuthRootView.swift
//  Friends
//
//  Created by Ziqa on 02/08/26.
//

import SwiftUI

struct AuthRootView: View {
    @Environment(AuthRouter.self) var router
    
    private let factory: ViewModelFactory
    
    init(factory: ViewModelFactory) {
        self.factory = factory
    }
    
    var body: some View {
        @Bindable var router = router
        
        NavigationStack(path: $router.path) {
            ScreenEnum.signIn.build(factory: factory)
                .navigationDestination(for: ScreenEnum.self) { screen in
                    screen.build(factory: factory)
                }
        }
    }
}

#Preview {
    AuthRootView(factory: ViewModelFactory())
        .appPreviewEnvironments()
}
