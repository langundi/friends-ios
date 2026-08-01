//
//  TabRootView.swift
//  Friends
//
//  Created by Ziqa on 01/08/26.
//

import SwiftUI

struct TabRootView: View {
    @Environment(AppRouter.self) var router
    
    var body: some View {
        @Bindable var router = router
        
        TabView {
            Tab("", systemImage: "house") {
                NavigationStack(path: $router.path) {
                    router.build(.timeline)
                        .navigationDestination(for: ScreenEnum.self) { screen in
                            router.build(screen)
                        }
                }
            }
            
            Tab("", systemImage: "person") {
                NavigationStack(path: $router.path) {
                    router.build(.profile)
                        .navigationDestination(for: ScreenEnum.self) { screen in
                            router.build(screen)
                        }
                }
            }
        }
    }
}

#Preview {
    TabRootView()
        .withPreviewEnvironments()
}
