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
    private let authService: AuthService
    private let userService: UserService
    private let postService: PostService
    private let friendService: FriendService
    
    var isLoading: Bool = false
    
    // Profile ViewModel Properties
    var username: String = ""
    var posts: [PostResponse] { postService.getPosts() }
    private var hasLoadedProfile: Bool = false
    
    // FriendList ViewModel Properties
    var friends: [FriendResponse] = []
    private var hasLoadedFriends: Bool = false
    
    private var isLoggedIn: Bool {
        get { UserDefaults.standard.bool(forKey: Constants.isUserLoggedIn) }
        set { UserDefaults.standard.set(newValue, forKey: Constants.isUserLoggedIn) }
    }
    
    init(authService: AuthService, userService: UserService, postService: PostService, friendService: FriendService) {
        self.authService = authService
        self.userService = userService
        self.postService = postService
        self.friendService = friendService
        
        Task {
            await loadProfile()
        }
    }
    
    /// Sign out user and delete access and refresh tokens from keychain.
    func signOutUser() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            // Signs out user automatically when keychain is empty
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
    
    /// Load user profile and posts.
    func loadProfile() async {
        guard !hasLoadedProfile else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        async let profile: () = getMyProfile()
        async let posts: () = getMyPosts()
        
        _ = await (profile, posts)
        
        hasLoadedProfile = true
    }
    
    /// Re-fetches profile and posts.
    func refreshProfile() async {
        hasLoadedProfile = false
        await loadProfile()
    }
    
    func deletePost(id: Int, objectKey: String) async {
        isLoading = true
        defer { isLoading = false }
        
        let request = DeletePostRequest(id: id, objectKey: objectKey)
        
        do {
            try await postService.deletePost(request: request)
            
            // Refresh posts after delete
            await getMyPosts()
        } catch let networkError as NetworkError {
            switch networkError {
            case .noDataRecieved:
                postService.setPosts([])
                Logger.network.warning("Profile Posts: \(networkError.message)")
            default:
                AlertManager.shared.showAlert(title: "An error occured", message: networkError.message)
                Logger.network.error("Error deleting post: \(networkError.message)")
            }
        } catch {
            AlertManager.shared.showAlert(title: "An error occured", message: error.localizedDescription)
            Logger.network.error("Error deleting post: \(error)")
        }
    }
    
    /// Fetch user profile.
    private func getMyProfile() async {
        do {
            let user = try await userService.getMyProfile()
            username = user.username
        } catch let networkError as NetworkError {
            AlertManager.shared.showAlert(title: "An error occured", message: networkError.message)
            Logger.network.error("Error fetching profile: \(networkError.message)")
        } catch {
            AlertManager.shared.showAlert(title: "An error occured", message: error.localizedDescription)
            Logger.network.error("Error fetching profile: \(error)")
        }
    }
    
    /// Fetch user posts.
    private func getMyPosts() async {
        do {
            let posts = try await postService.getMyPosts()
            postService.setPosts(posts)
        } catch let networkError as NetworkError {
            switch networkError {
            case .noDataRecieved:
                Logger.network.warning("Profile Posts: \(networkError.message)")
            default:
                AlertManager.shared.showAlert(title: "An error occured", message: networkError.message)
                Logger.network.error("Error fetching posts: \(networkError.message)")
            }
        } catch {
            AlertManager.shared.showAlert(title: "An error occured", message: error.localizedDescription)
            Logger.network.error("Error fetching posts: \(error)")
        }
    }
    
    // MARK: - Friend List
    
    func getFriendList() async {
        guard !hasLoadedFriends else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response = try await friendService.getFriendList()
            friends = response
            hasLoadedFriends = true
        } catch let networkError as NetworkError {
            switch networkError {
            case .noDataRecieved:
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
    
    func refreshFriendList() async {
        hasLoadedFriends = false
        await getFriendList()
    }
    
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
}
