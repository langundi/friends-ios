//
//  ProfileViewModel.swift
//  Friends
//
//  Created by Ziqa on 01/08/26.
//

import Foundation
import OSLog

@Observable
final class ProfileViewModel {
    
    var isLoading: Bool = false
    
    // ProfileScreen Properties
    var username: String {
        userStore.username
    }
    
    var posts: [PostResponse] {
        postStore.posts
    }
    
    private var hasLoadedProfile: Bool = false
    
    // FriendListScreen Properties
    var friends: [FriendResponse] = []
    private var hasLoadedFriends: Bool = false
    
    // Login State
    private var isLoggedIn: Bool {
        get { UserDefaults.standard.bool(forKey: Constants.isUserLoggedIn) }
        set { UserDefaults.standard.set(newValue, forKey: Constants.isUserLoggedIn) }
    }
    
    private let authService: AuthService
    private let friendService: FriendService
    private let postStore: PostStore
    private let userStore: UserStore
    
    init(authService: AuthService, friendService: FriendService, userStore: UserStore, postStore: PostStore) {
        self.authService = authService
        self.friendService = friendService
        self.userStore = userStore
        self.postStore = postStore
        
        Task {
            await loadProfileAndPosts()
        }
    }
    
    // MARK: - Profile and Posts
    
    /// Load user profile and posts.
    func loadProfileAndPosts() async {
        guard !hasLoadedProfile else { return }
        isLoading = true
        defer { isLoading = false }
        
        async let profile: () = getMyProfile()
        async let posts: () = getMyPosts()
        _ = await (profile, posts)
        
        hasLoadedProfile = true
    }
    
    /// Re-fetches profile and posts.
    func refreshProfileAndPosts() async {
        hasLoadedProfile = false
        await loadProfileAndPosts()
    }
    
    /// Fetch user profile.
    private func getMyProfile() async {
        do {
            try await userStore.getMyProfile()
        } catch let networkError as NetworkError {
            AlertManager.shared.showAlert(title: "An error occured", message: networkError.message)
            Logger.network.error("Error fetching profile: \(networkError.message)")
        } catch {
            AlertManager.shared.showAlert(title: "An error occured", message: error.localizedDescription)
            Logger.network.error("Error fetching profile: \(error)")
        }
    }
    
    /// Fetch user posts.
    private func getMyPosts() async  {
        do {
            try await postStore.getMyPosts()
        } catch let networkError as NetworkError {
            switch networkError {
            case .noDataRecieved:
                Logger.network.warning("Profile posts: \(networkError.message)")
            default:
                AlertManager.shared.showAlert(title: "An error occured", message: networkError.message)
                Logger.network.error("Error fetching posts: \(networkError.message)")
            }
        } catch {
            AlertManager.shared.showAlert(title: "An error occured", message: error.localizedDescription)
            Logger.network.error("Error fetching posts: \(error)")
        }
    }
    
    /// Delete a post.
    /// - Parameters:
    ///   - id: Post ID.
    ///   - objectKey: Image path.
    func deletePost(id: Int, objectKey: String) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let request = DeletePostRequest(id: id, objectKey: objectKey)
            try await postStore.deletePost(request: request)
        } catch let networkError as NetworkError {
            AlertManager.shared.showAlert(title: "An error occured", message: networkError.message)
            Logger.network.error("Error deleting post: \(networkError.message)")
        } catch {
            AlertManager.shared.showAlert(title: "An error occured", message: error.localizedDescription)
            Logger.network.error("Error deleting post: \(error)")
        }
    }
    
    // MARK: - Friend List
    
    /// Fetch friend list.
    func getFriendList() async {
        guard !hasLoadedFriends else { return }
        isLoading = true
        defer { isLoading = false }
        
        do {
            let result = try await friendService.getFriendList()
            friends = result
            hasLoadedFriends = true
        } catch let networkError as NetworkError {
            switch networkError {
            case .noDataRecieved:
                friends = []
                Logger.network.warning("Friend list: \(networkError.message)")
            default:
                AlertManager.shared.showAlert(title: "An error occured", message: networkError.message)
                Logger.network.error("Error fetching friend list: \(networkError.message)")
            }
        } catch {
            AlertManager.shared.showAlert(title: "An error occured", message: error.localizedDescription)
            Logger.network.error("Error fetching friend list: \(error)")
        }
    }
    
    /// Re-fetches friend list.
    func refreshFriendList() async {
        hasLoadedFriends = false
        await getFriendList()
    }
    
    /// Remove a friend from friend list.
    /// - Parameter id: Friendship ID.
    func unfriend(id: Int) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await friendService.unfriend(id: id)
            friends.removeAll { $0.id == id }
        } catch let networkError as NetworkError {
            AlertManager.shared.showAlert(title: "An error occured", message: networkError.message)
            Logger.network.error("Error fetching friend list: \(networkError.message)")
        } catch {
            AlertManager.shared.showAlert(title: "An error occured", message: error.localizedDescription)
            Logger.network.error("Error fetching friend list: \(error)")
        }
    }
    
    // MARK: - Settings
    
    /// Sign out user and delete access and refresh tokens from keychain.
    func signOutUser() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            guard let refreshToken: String = try? Keychain.get(Constants.refreshToken) else {
                isLoggedIn = false
                throw NetworkError.sessionExpired
            }
            
            let refresh = RefreshRequest(refreshToken: refreshToken)
            try await authService.logoutUser(refresh: refresh)
            
            deleteTokensFromKeychain()
            
            isLoggedIn = false
        } catch let networkError as NetworkError {
            AlertManager.shared.showAlert(title: "An error occured", message: networkError.message)
            Logger.network.error("Error signing out: \(networkError.message)")
        } catch {
            AlertManager.shared.showAlert(title: "An error occured", message: error.localizedDescription)
            Logger.network.error("Error signing out: \(error)")
        }
    }
    
    private func deleteTokensFromKeychain() {
        _ = Keychain.delete(Constants.accessToken)
        _ = Keychain.delete(Constants.refreshToken)
    }
}
