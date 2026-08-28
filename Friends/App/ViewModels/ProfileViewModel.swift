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
    
    var username: String {
        userStore.username
    }
    
    var posts: [PostResponse] {
        postStore.posts
    }
    
    var friends: [FriendResponse] {
        friendStore.friends
    }
    
    private let authService: AuthService
    private let postStore: PostStore
    private let userStore: UserStore
    private let friendStore: FriendStore
    
    init(authService: AuthService, userStore: UserStore, postStore: PostStore, friendStore: FriendStore) {
        self.authService = authService
        self.userStore = userStore
        self.postStore = postStore
        self.friendStore = friendStore
        
        Task {
            await loadProfileData()
        }
    }
    
    /// Load user profile, posts, and friends.
    func loadProfileData() async {
        isLoading = true
        defer { isLoading = false }
        
        async let profile: () = getMyProfile()
        async let posts: () = getMyPosts()
        async let friends: () = getFriendList()
        _ = await (profile, posts, friends)
    }
    
    /// Re-fetches profile, posts, and friends.
    func refreshProfileData() async {
        userStore.invalidateLastFetch()
        postStore.invalidateLastFetch()
        friendStore.invalidateLastFetch()
        await loadProfileData()
    }
    
    // MARK: - User's Profile
    
    /// Fetch user profile.
    private func getMyProfile() async {
        do {
            try await userStore.loadProfileIfNeeded()
        } catch let networkError as NetworkError {
            AlertManager.shared.showAlert(title: "An error occured", message: networkError.message)
            Logger.network.error("Error fetching profile: \(networkError.message)")
        } catch {
            if error.isCancellation { return }
            AlertManager.shared.showAlert(title: "An error occured", message: error.localizedDescription)
            Logger.network.error("Error fetching profile: \(error)")
        }
    }
    
    // MARK: - User's Posts
    
    /// Fetch user posts.
    func getMyPosts() async  {
        do {
            try await postStore.loadPostIfNeeded()
        } catch let networkError as NetworkError {
            AlertManager.shared.showAlert(title: "An error occured", message: networkError.message)
            Logger.network.error("Error fetching posts: \(networkError.message)")
        } catch {
            if error.isCancellation { return }
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
            if error.isCancellation { return }
            AlertManager.shared.showAlert(title: "An error occured", message: error.localizedDescription)
            Logger.network.error("Error deleting post: \(error)")
        }
    }
    
    // MARK: - User's Friend List
    
    /// Fetch friend list.
    func getFriendList() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await friendStore.loadDataIfNeeded()
        } catch let networkError as NetworkError {
            AlertManager.shared.showAlert(title: "An error occured", message: networkError.message)
            Logger.network.error("Error fetching friend list: \(networkError.message)")
        } catch {
            if error.isCancellation { return }
            AlertManager.shared.showAlert(title: "An error occured", message: error.localizedDescription)
            Logger.network.error("Error fetching friend list: \(error)")
        }
    }
    
    /// Re-fetches friend list.
    func refreshFriendList() async {
        friendStore.invalidateLastFetch()
        await getFriendList()
    }
    
    /// Remove a friend from friend list.
    /// - Parameter id: Friendship ID.
    func unfriend(id: Int) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await friendStore.unfriend(id: id)
        } catch let networkError as NetworkError {
            AlertManager.shared.showAlert(title: "An error occured", message: networkError.message)
            Logger.network.error("Error fetching friend list: \(networkError.message)")
        } catch {
            if error.isCancellation { return }
            AlertManager.shared.showAlert(title: "An error occured", message: error.localizedDescription)
            Logger.network.error("Error fetching friend list: \(error)")
        }
    }
}
