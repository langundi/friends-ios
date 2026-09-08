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
    var friends: [FriendsFriendResponse] = []
    
    var posts: [PostResponse] {
        postStore.friendPosts
    }
    
    var myUsername: String {
        userStore.username
    }
    
    private let userStore: UserStore
    private let postStore: PostStore
    private let friendService: FriendService
    
    init(userStore: UserStore, postStore: PostStore, friendService: FriendService) {
        self.userStore = userStore
        self.postStore = postStore
        self.friendService = friendService
    }
    
    func loadProfileAndPosts(id: Int) async {
        isLoading = true
        defer { isLoading = false }
        
        async let profile: () = getFriendProfile(id: id)
        async let posts: () = getFriendPosts(id: id)
        async let friends: () = getFriendList(id: id)
        _ = await (profile, posts, friends)
    }
    
    func getFriendProfile(id: Int) async {
        do {
            let result = try await userStore.getFriendProfile(userID: id)
            
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
            try await postStore.getFriendPosts(userID: id)
        } catch let networkError as NetworkError {
            AlertManager.shared.showAlert(title: "An error occured", message: networkError.message)
            Logger.network.error("Error fetching posts: \(networkError.message)")
        } catch {
            if error.isCancellation { return }
            AlertManager.shared.showAlert(title: "An error occured", message: error.localizedDescription)
            Logger.network.error("Error fetching posts: \(error)")
        }
    }
    
    func getFriendList(id: Int) async {
        do {
            friends = try await friendService.getFriendList(userID: id) ?? []
            
            if let index = friends.firstIndex(where: { $0.username == userStore.username }) {
                friends[index].friendsWithMe = true
            }
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
