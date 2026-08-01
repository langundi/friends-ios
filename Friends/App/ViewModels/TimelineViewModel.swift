//
//  HomeViewModel.swift
//  Friends
//
//  Created by Ziqa on 28/07/26.
//

import Foundation

@Observable
final class TimelineViewModel {
    private let authService = AuthService.shared
    private let timelineService = TimelineService.shared
    private let alertManager = AlertManager.shared
    private let defaults = UserDefaults.standard
    
    var posts: [PostResponse] = []
    var isLoading: Bool = false
    var isLoggedIn: Bool {
        get { defaults.bool(forKey: Constants.isUserLoggedIn) }
        set { defaults.set(newValue, forKey: Constants.isUserLoggedIn) }
    }
    
    func getTimeline() async {
        guard posts.isEmpty else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            posts = try await timelineService.getTimeline()
        } catch let networkError as NetworkError {
            alertManager.showAlert(
                title: "An error occured",
                message: networkError.message
            )
        } catch {
            alertManager.showAlert(
                title: "An error occured",
                message: error.localizedDescription
            )
        }
    }
}

extension TimelineViewModel {
    static var mock: TimelineViewModel {
        let vm = TimelineViewModel()
        vm.posts = [
            PostResponse(
                id: 1,
                userID: 1,
                caption: "Test 1",
                imageURL: "https://images.unsplash.com/photo-1784558473693-6b396480e729?q=80&w=1336&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                createdAt: Date()
            ),
            PostResponse(
                id: 2,
                userID: 1,
                caption: "Test 2",
                imageURL: "https://images.unsplash.com/photo-1784558473693-6b396480e729?q=80&w=1336&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                createdAt: Date().addingTimeInterval(3600)
            ),
            PostResponse(
                id: 3,
                userID: 1,
                caption: "Test 3",
                imageURL: "https://images.unsplash.com/photo-1784558473693-6b396480e729?q=80&w=1336&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                createdAt: Date().addingTimeInterval(7200)
            ),
        ]
        vm.isLoading = false
        return vm
    }
    
    static var mockEmpty: TimelineViewModel {
        let vm = TimelineViewModel()
        vm.posts = []
        vm.isLoading = false
        return vm
    }
    
    static var mockLoading: TimelineViewModel {
        let vm = TimelineViewModel()
        vm.isLoading = true
        return vm
    }
}
