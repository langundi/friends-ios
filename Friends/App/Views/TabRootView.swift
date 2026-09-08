//
//  TabRootView.swift
//  Friends
//
//  Created by Ziqa on 01/08/26.
//

import SwiftUI

struct TabRootView: View {
    @State private var timelineRouter = AppRouter.shared
    @State private var profileRouter = AppRouter()
    @State private var searchRouter = AppRouter()
    
    let factory: ViewModelFactory
    
    init(factory: ViewModelFactory) {
        self.factory = factory
        
        // Create Tabs ViewModels
        _ = factory.makeTimelineViewModel()
        _ = factory.makeProfileViewModel()
        _ = factory.makeSearchViewModel()
    }
    
    var body: some View {
        TabView {
            Tab("", systemImage: "house") {
                NavigationStack(path: $timelineRouter.path) {
                    ScreenEnum.timeline.build(factory: factory)
                        .navigationDestination(for: ScreenEnum.self) { screen in
                            screen.build(factory: factory)
                        }
                }
                .environment(timelineRouter)
            }
            
            Tab("", systemImage: "person") {
                NavigationStack(path: $profileRouter.path) {
                    ScreenEnum.profile.build(factory: factory)
                        .navigationDestination(for: ScreenEnum.self) { screen in
                            screen.build(factory: factory)
                        }
                }
                .environment(profileRouter)
            }
            
            Tab(role: .search) {
                NavigationStack(path: $searchRouter.path) {
                    ScreenEnum.search(username: nil).build(factory: factory)
                        .navigationDestination(for: ScreenEnum.self) { screen in
                            screen.build(factory: factory)
                        }
                }
                .environment(searchRouter)
            }
        }
    }
}

#Preview {
    TabRootView(factory: ViewModelFactory())
        .appPreviewEnvironments()
}
