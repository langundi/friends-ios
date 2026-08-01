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
    
    private var posts = 17
    private var columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 3)
    
    var body: some View {
        ScrollView {
            HStack(spacing: 24) {
                Circle()
                    .frame(maxWidth: 60, maxHeight: 60)
                
                HStack(alignment: .center, spacing: 16) {
                    Text("\(posts) Posts")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("5 Friends")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                
                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity)
            .padding()
            
            LazyVGrid(
                columns: columns,
                alignment: .center,
                spacing: 12
            ) {
                ForEach(0..<posts, id: \.self) { column in
                    Rectangle()
                        .frame(maxWidth: .infinity)
                        .aspectRatio(1.0, contentMode: .fit)
                        .foregroundStyle(.gray.opacity(0.15))
                }
            }
            .padding([.leading, .trailing])
            .padding(.bottom, 16)
        }
        .scrollIndicators(.hidden)
        .navigationTitle("@username")
        .toolbarTitleDisplayMode(.inlineLarge)
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
