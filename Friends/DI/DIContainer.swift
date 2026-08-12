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
    
    lazy var timelineService: TimelineService = {
        TimelineService(client: APIClient.shared)
    }()
    
    lazy var userService: UserService = {
        UserService(client: APIClient.shared)
    }()
    
    lazy var postService: PostService = {
        PostService(client: APIClient.shared)
    }()
    
    // MARK: - Lazy ViewModels
    
    lazy var timelineViewModel: TimelineViewModel = {
       TimelineViewModel(timelineService: timelineService)
    }()
    
    lazy var profileViewModel: ProfileViewModel = {
       ProfileViewModel(authService: authService, userService: userService, postService: postService)
    }()
    
    // MARK: - Make ViewModels
    
    func makeAuthViewModel() -> AuthViewModel {
        return AuthViewModel(authService: authService)
    }
    
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
        return FriendRequestViewModel()
    }
    
    func makeProfileViewModel() -> ProfileViewModel {
        profileViewModel
    }
    
    func makeFriendListViewModel() -> FriendListViewModel {
        return FriendListViewModel()
    }
}
