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
    
    lazy var deviceService: DeviceService = {
        DeviceService(client: APIClient.shared)
    }()
    
    lazy var notificationService: NotificationService = {
        NotificationService(client: APIClient.shared)
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
    
    lazy var notificationStore: NotificationStore = {
        NotificationStore(notificationService: notificationService)
    }()
    
    // MARK: - ViewModels
    
    lazy var authViewModel: AuthViewModel = {
        return AuthViewModel(authService: authService, deviceService: deviceService)
    }()
    
    lazy var timelineViewModel: TimelineViewModel = {
        return TimelineViewModel(timelineStore: timelineStore, postStore: postStore, replyStore: replyStore, userStore: userStore)
    }()
    
    lazy var notificationViewModel: NotificationViewModel = {
        return NotificationViewModel(notificationStore: notificationStore, friendService: friendService)
    }()
    
    lazy var profileViewModel: ProfileViewModel = {
        return ProfileViewModel(userStore: userStore, postStore: postStore, friendStore: friendStore, timelineStore: timelineStore)
    }()
    
    lazy var friendProfileViewModel: FriendProfileViewModel = {
        return FriendProfileViewModel(userService: userService, postStore: postStore)
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
        notificationViewModel
    }
    
    func makeNewPostViewModel() -> NewPostViewModel {
        return NewPostViewModel(postStore: postStore, timelineStore: timelineStore, userStore: userStore)
    }
    
    // MARK: - Profile Tab ViewModels
    
    func makeProfileViewModel() -> ProfileViewModel {
        profileViewModel
    }
    
    func makeFriendProfileViewModel() -> FriendProfileViewModel {
        friendProfileViewModel
    }
    
    func makeSettingsViewModel() -> SettingsViewModel {
        return SettingsViewModel(authService: authService, deviceService: deviceService)
    }
    
    func makeEditProfileViewModel() -> EditProfileViewModel {
        return EditProfileViewModel(userStore: userStore)
    }
    
    func makeChangePasswordViewModel() -> ChangePasswordViewModel {
        return ChangePasswordViewModel(userStore: userStore)
    }
    
    func makeDeleteAccountViewModel() -> DeleteAccountViewModel {
        return DeleteAccountViewModel(userStore: userStore, postStore: postStore)
    }
    
    // MARK: - Search Tab ViewModels
    
    func makeSearchViewModel() -> SearchViewModel {
        searchViewModel
    }
}
