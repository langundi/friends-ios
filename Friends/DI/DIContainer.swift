//
//  DIContainer.swift
//  Friends
//
//  Created by Ziqa on 02/08/26.
//

import Foundation

final class ViewModelFactory {
    
    // MARK: - Services
    
    lazy var authService: AuthService = {
        AuthService(client: APIClient.shared)
    }()
    
    lazy var userService: UserService = {
        UserService(client: APIClient.shared)
    }()
    
    lazy var postService: PostService = {
        PostService(client: APIClient.shared)
    }()
    
    lazy var friendService: FriendService = {
        FriendService(client: APIClient.shared)
    }()
    
    // MARK: - Stores
    
    lazy var postStore: PostStore = {
        PostStore(service: postService)
    }()
    
    lazy var userStore: UserStore = {
        UserStore(service: userService)
    }()
    
    // MARK: - ViewModels
    
    lazy var timelineViewModel: TimelineViewModel = {
        return TimelineViewModel(postService: postService)
    }()
    
    lazy var profileViewModel: ProfileViewModel = {
        return ProfileViewModel(authService: authService, friendService: friendService, userStore: userStore, postStore: postStore)
    }()
    
    lazy var searchViewModel: SearchViewModel = {
        return SearchViewModel(userService: userService, friendService: friendService)
    }()
    
    lazy var notificationViewModel: NotificationViewModel = {
        return NotificationViewModel()
    }()
    
    // MARK: - Auth Flow ViewModels
    
    func makeAuthViewModel() -> AuthViewModel {
        return AuthViewModel(authService: authService)
    }
    
    // MARK: - Timeline Tab ViewModels
    
    func makeTimelineViewModel() -> TimelineViewModel {
        timelineViewModel
    }
    
    func makeNotificationViewModel() -> NotificationViewModel {
        return NotificationViewModel()
    }
    
    func makeNewPostViewModel() -> NewPostViewModel {
        return NewPostViewModel(postService: postService)
    }
    
    func makeFriendRequestViewModel() -> FriendRequestViewModel {
        return FriendRequestViewModel(friendService: friendService)
    }
    
    // MARK: - Profile Tab ViewModels
    
    func makeProfileViewModel() -> ProfileViewModel {
        profileViewModel
    }
    
    // MARK: - Search Tab ViewModels
    
    func makeSearchViewModel() -> SearchViewModel {
        searchViewModel
    }
}
