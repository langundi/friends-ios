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
    
    lazy var timelineStore: TimelineStore = {
        TimelineStore(postService: postService)
    }()
    
    lazy var postStore: PostStore = {
        PostStore(postService: postService)
    }()
    
    lazy var userStore: UserStore = {
        UserStore(userService: userService)
    }()
    
    lazy var friendStore: FriendStore = {
        FriendStore(friendService: friendService)
    }()
    
    lazy var replyStore: ReplyStore = {
        ReplyStore(postService: postService)
    }()
    
    // MARK: - ViewModels
    
    lazy var authViewModel: AuthViewModel = {
        return AuthViewModel(authService: authService)
    }()
    
    lazy var timelineViewModel: TimelineViewModel = {
        return TimelineViewModel(timelineStore: timelineStore, replyStore: replyStore, userStore: userStore)
    }()
    
    lazy var profileViewModel: ProfileViewModel = {
        return ProfileViewModel(authService: authService, userStore: userStore, postStore: postStore, friendStore: friendStore)
    }()
    
    lazy var searchViewModel: SearchViewModel = {
        return SearchViewModel(userStore: userStore, friendService: friendService)
    }()
    
    // MARK: - Auth ViewModels
    
    func makeAuthViewModel() -> AuthViewModel {
        authViewModel
    }
    
    // MARK: - Timeline Tab ViewModels
    
    func makeTimelineViewModel() -> TimelineViewModel {
        timelineViewModel
    }
    
    func makeNotificationViewModel() -> NotificationViewModel {
        return NotificationViewModel()
    }
    
    func makeNewPostViewModel() -> NewPostViewModel {
        return NewPostViewModel(postStore: postStore, timelineStore: timelineStore)
    }
    
    func makeFriendRequestViewModel() -> FriendRequestViewModel {
        return FriendRequestViewModel(friendService: friendService)
    }
    
    func makeReplyViewModel() -> ReplyViewModel {
        return ReplyViewModel()
    }
    
    // MARK: - Profile Tab ViewModels
    
    func makeProfileViewModel() -> ProfileViewModel {
        profileViewModel
    }
    
    func makeSettingsViewModel() -> SettingsViewModel {
        return SettingsViewModel(authService: authService)
    }
    
    func makeEditProfileViewModel() -> EditProfileViewModel {
        return EditProfileViewModel(userStore: userStore)
    }
    
    func makeChangePasswordViewModel() -> ChangePasswordViewModel {
        return ChangePasswordViewModel(userStore: userStore)
    }
    
    func makeDeleteAccountViewModel() -> DeleteAccountViewModel {
        return DeleteAccountViewModel(userStore: userStore)
    }
    
    // MARK: - Search Tab ViewModels
    
    func makeSearchViewModel() -> SearchViewModel {
        searchViewModel
    }
}
