//
//  DIContainer.swift
//  Friends
//
//  Created by Ziqa on 02/08/26.
//

import Foundation

final class ViewModelFactory {
    
    // MARK: - Lazy Services
    
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
    
    // MARK: - Lazy ViewModels
    
    lazy var timelineViewModel: TimelineViewModel = {
        return TimelineViewModel(postService: postService)
    }()
    
    lazy var profileViewModel: ProfileViewModel = {
        return ProfileViewModel(authService: authService, userService: userService, postService: postService)
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
    
    func makeFriendListViewModel() -> FriendListViewModel {
        return FriendListViewModel()
    }
    
    // MARK: - Search Tab ViewModels
    
    func makeSearchViewModel() -> SearchViewModel {
        searchViewModel
    }
}
