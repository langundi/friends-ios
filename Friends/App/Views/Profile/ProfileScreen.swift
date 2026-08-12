//
//  ProfileScreen.swift
//  Friends
//
//  Created by Ziqa on 01/08/26.
//

import SwiftUI
import Kingfisher

struct ProfileScreen: View {
    @Environment(AppRouter.self) var router
    @State private var viewModel: ProfileViewModel
    
    private var columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 3)
    
    init(factory: ViewModelFactory) {
        _viewModel = State(initialValue: factory.makeProfileViewModel())
    }
    
    var body: some View {
        ScrollView {
            HStack(spacing: 24) {
                Circle()
                    .frame(maxWidth: 60, maxHeight: 60)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(viewModel.username)
                        .font(.title3)
                        .fontWeight(.medium)
                    
                    HStack(alignment: .center, spacing: 32) {
                        Text("\(viewModel.posts.count) Posts")
                            .font(.title3)
                        
                        Button {
                            router.push(to: .friendList)
                        } label: {
                            Text("5 Friends")
                                .font(.title3)
                        }
                        .buttonStyle(.plain)
                    }
                }
                
                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity)
            .padding()
            
            LazyVGrid(
                columns: columns,
                alignment: .center,
                spacing: 8
            ) {
                ForEach(viewModel.posts) { post in
                    KFImage(URL(string: post.imageURL))
                        .resizable()
                        .onSuccess { result in
                            print("Image loaded from cache: \(result.cacheType)")
                        }
                        .onFailure { error in
                            print("KF error: \(error)")
                        }
                        .frame(maxWidth: .infinity)
                        .aspectRatio(1.0, contentMode: .fit)
                }
            }
            .padding([.leading, .trailing], 8)
            .padding(.bottom, 16)
        }
        .scrollIndicators(.hidden)
        .toolbarTitleDisplayMode(.inlineLarge)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    Task {
                        await viewModel.signOutUser()
                    }
                } label: {
                    Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.forward")
                        .labelStyle(.iconOnly)
                }
            }
        }
        .overlay(alignment: .center) {
            if viewModel.isLoading {
                LoadingOverlay()
            }
        }
        .task {
            await viewModel.loadProfile()
        }
        .refreshable {
            await viewModel.refreshProfile()
        }
    }
}

#Preview {
    NavigationStack {
        ProfileScreen(factory: ViewModelFactory())
    }
    .withPreviewEnvironments()
}
