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
    
    init(authService: AuthService, userService: UserService, postService: PostService) {
        self.authService = authService
        self.userService = userService
        self.postService = postService
        
        Task {
            await loadProfile()
        }
    }
    
    // ViewModel Properties
    var isLoading: Bool = false
    var username: String = ""
    var posts: [PostResponse] {
        postService.getPosts()
    }
    
    private var hasLoaded: Bool = false
    private var isLoggedIn: Bool {
        get { UserDefaults.standard.bool(forKey: Constants.isUserLoggedIn) }
        set { UserDefaults.standard.set(newValue, forKey: Constants.isUserLoggedIn) }
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
            
            _ = Keychain.delete(Constants.accessToken)
            _ = Keychain.delete(Constants.refreshToken)
            
            isLoggedIn = false
        } catch let networkError as NetworkError {
            AlertManager.shared.showAlert(
                title: "An error occured",
                message: networkError.message
            )
        } catch {
            AlertManager.shared.showAlert(
                title: "An error occured",
                message: error.localizedDescription
            )
        }
    }
    
    /// Load user profile and posts.
    func loadProfile() async {
        guard !hasLoaded else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        async let profile: () = getMyProfile()
        async let posts: () = getMyPosts()
        
        _ = await (profile, posts)
        
        hasLoaded = true
    }
    
    /// Re-fetches profile and posts.
    func refreshProfile() async {
        hasLoaded = false
        await loadProfile()
    }
    
    func deletePost(id: Int, objectKey: String) async {
        isLoading = true
        defer { isLoading = false }
        
        let request = DeletePostRequest(id: id, objectKey: objectKey)
        
        do {
            try await postService.deletePost(request: request)
            
            let posts = try await postService.getMyPosts()
            
            postService.setPosts(posts)
        } catch let networkError as NetworkError {
            switch networkError {
            case .noDataRecieved:
                Logger.network.warning("Profile Posts: \(networkError.message)")
                postService.setPosts([])
            default:
                AlertManager.shared.showAlert(
                    title: "An error occured",
                    message: networkError.message
                )
            }
        } catch {
            AlertManager.shared.showAlert(
                title: "An error occured",
                message: error.localizedDescription
            )
        }
    }
    
    /// Fetch user profile.
    private func getMyProfile() async {
        do {
            let user = try await userService.getMyProfile()
            username = user.username
        } catch let networkError as NetworkError {
            Logger.network.warning("Profile: \(networkError.message)")
            AlertManager.shared.showAlert(
                title: "An error occured",
                message: networkError.message
            )
        } catch {
            AlertManager.shared.showAlert(
                title: "An error occured",
                message: error.localizedDescription
            )
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
                AlertManager.shared.showAlert(
                    title: "An error occured",
                    message: networkError.message
                )
            }
        } catch {
            AlertManager.shared.showAlert(
                title: "An error occured",
                message: error.localizedDescription
            )
        }
    }
}
