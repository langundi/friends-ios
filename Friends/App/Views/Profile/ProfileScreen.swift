//
//  ProfileScreen.swift
//  Friends
//
//  Created by Ziqa on 01/08/26.
//

import SwiftUI

struct ProfileScreen: View {
    @Environment(AppRouter.self) var router
    @State private var viewmodel = ProfileViewModel()
    
    var body: some View {
        VStack {
            Text("Profile Screen")
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    Task {
                        await viewmodel.signOutUser()
                    }
                } label: {
                    Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.forward")
                        .labelStyle(.iconOnly)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProfileScreen()
    }
    .withPreviewEnvironments()
}
