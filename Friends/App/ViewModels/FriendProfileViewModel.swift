//
//  FriendProfileViewModel.swift
//  Friends
//
//  Created by Ziqa on 03/09/26.
//

import Foundation
import OSLog

@Observable
final class FriendProfileViewModel {
    
    var isLoading: Bool = false
    var profilePicture: String?
    var posts: [PostResponse] = []
    
    private let userService: UserService
    private let postService: PostService
    
    init(userService: UserService, postService: PostService) {
        self.userService = userService
        self.postService = postService
    }
    
    // MARK: - TODO: Add fetch ttl
    
    func loadProfileAndPosts(id: Int) async {
        isLoading = true
        defer { isLoading = false }
        
        async let profile: () = getFriendProfile(id: id)
        async let posts: () = getFriendPosts(id: id)
        _ = await (profile, posts)
    }
    
    func getFriendProfile(id: Int) async {
        do {
            let result = try await userService.getFriendProfile(userID: id)
            
            if let profilePicture = result.profilePicture {
                self.profilePicture = profilePicture
            }
        } catch let networkError as NetworkError {
            AlertManager.shared.showAlert(title: "An error occured", message: networkError.message)
            Logger.network.error("Error fetching profile: \(networkError.message)")
        } catch {
            if error.isCancellation { return }
            AlertManager.shared.showAlert(title: "An error occured", message: error.localizedDescription)
            Logger.network.error("Error fetching profile: \(error)")
        }
    }
    
    func getFriendPosts(id: Int) async {
        do {
            posts = try await postService.getFriendPosts(userID: id) ?? []
        } catch let networkError as NetworkError {
            AlertManager.shared.showAlert(title: "An error occured", message: networkError.message)
            Logger.network.error("Error fetching posts: \(networkError.message)")
        } catch {
            if error.isCancellation { return }
            AlertManager.shared.showAlert(title: "An error occured", message: error.localizedDescription)
            Logger.network.error("Error fetching posts: \(error)")
        }
    }
}
