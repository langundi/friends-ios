//
//  ProfileScreen.swift
//  Friends
//
//  Created by Ziqa on 01/08/26.
//

import SwiftUI
import Kingfisher
import OSLog

struct ProfileScreen: View {
    @AppStorage(Constants.isUserLoggedIn) var isLoggedIn: Bool = true
    @Environment(AppRouter.self) var router
    @State private var viewModel: ProfileViewModel
    @State private var timelineViewModel: TimelineViewModel
    @State private var showDeleteButton = false
    
    private var columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 3)
    
    init(factory: ViewModelFactory) {
        _viewModel = State(initialValue: factory.makeProfileViewModel())
        
        timelineViewModel = factory.timelineViewModel
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
                        .onFailure { error in
                            Logger.kingfisher.error("KF Error: \(error)")
                        }
                        .frame(maxWidth: .infinity)
                        .aspectRatio(1.0, contentMode: .fit)
                        .contextMenu {
                            Button(role: .destructive) {
                                Task {
                                    await viewModel.deletePost(id: post.id, objectKey: post.objectKey)
                                    await timelineViewModel.refreshTimeline()
                                }
                            } label: {
                                Label("Delete Post", systemImage: "trash")
                            }
                            
                        }
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
                    AlertManager.shared.showAlert(
                        title: "Sign Out",
                        message: "Are you sure you want to sign out?",
                        primaryAction: .init(title: "Yes", action: {
                            Task {
                                await viewModel.signOutUser()
                            }
                        }), secondaryAction: .init(title: "Cancel"))
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
