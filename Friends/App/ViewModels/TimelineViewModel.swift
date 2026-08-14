//
//  HomeViewModel.swift
//  Friends
//
//  Created by Ziqa on 28/07/26.
//

import Foundation
import UIKit
import OSLog

@Observable
final class TimelineViewModel {
    private let postService: PostService
    
    init(postService: PostService) {
        self.postService = postService
    }
    
    var isLoading: Bool = false
    var posts: [PostResponse] = []
    private var hasLoaded: Bool = false
    
    func getTimeline() async {
        guard !hasLoaded else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            posts = try await postService.getTimeline()
            hasLoaded = true
        } catch let networkError as NetworkError {
            switch networkError {
            case .noDataRecieved:
                Logger.network.warning("Timeline Posts: \(networkError.message)")
                hasLoaded = true
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
    
    func refreshTimeline() async {
        hasLoaded = false
        await getTimeline()
    }
    
    func uploadNewPost(image: UIImage, caption: String, completion: @escaping () -> Void) async {
        isLoading = true
        defer { isLoading = false }
        
        // Compress image
        guard let imageData = compressImageAndConvertToJPEG(image: image) else {
            Logger.system.error("Unexpected Error: Failed to compress image.")
            return
        }
        
        let filename = UUID().uuidString
        let request = UploadImageRequest(filename: filename, contentType: "image/jpeg")
        
        do {
            // Get presigned URL
            let presigned = try await postService.getPresignedUrl(request: request)
            
            // Upload image to presigned URL
            try await postService.uploadImageToBucket(uploadUrl: presigned.uploadURL, imageData: imageData)
            
            let newPostRequest = NewPostRequest(caption: caption, imageUrl: presigned.publicURL, objectKey: presigned.objectKey)
            
            // Upload post to server
            let newPost = try await postService.newPost(request: newPostRequest)
            
            Logger.network.info("New post created for id: \(newPost.id, align: .left(columns: 15))")
            
            // Delay to compensate for Kingfisher TLS error
            try? await Task.sleep(for: .seconds(2))
            
            // Refresh timeline
            posts = try await postService.getTimeline()
            
            // Insert new post to posts array in services
            postService.insert(newPost)
            
            completion()
        } catch let networkError as NetworkError {
            Logger.network.error("Upload New Post: \(networkError)")
            
            AlertManager.shared.showAlert(
                title: "An error occured",
                message: networkError.message
            )
        } catch {
            Logger.network.error("Upload New Post: \(error)")
            
            AlertManager.shared.showAlert(
                title: "An error occured",
                message: error.localizedDescription
            )
        }
    }
    
    private func compressImageAndConvertToJPEG(image: UIImage) -> Data? {
        return image.jpegData(compressionQuality: 0.7)
    }
}

extension TimelineViewModel {
    static var mock: TimelineViewModel {
        let vm = TimelineViewModel(postService: PostService(client: APIClient.shared))
        vm.posts = [
            PostResponse(
                id: 1,
                userID: 1,
                caption: "Test 1",
                imageURL: "https://images.unsplash.com/photo-1784558473693-6b396480e729?q=80&w=1336&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                objectKey: "posts/1/image.jpeg",
                createdAt: Date()
            ),
            PostResponse(
                id: 2,
                userID: 1,
                caption: "Test 2",
                imageURL: "https://images.unsplash.com/photo-1784558473693-6b396480e729?q=80&w=1336&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                objectKey: "posts/1/image.jpeg",
                createdAt: Date().addingTimeInterval(3600)
            ),
            PostResponse(
                id: 3,
                userID: 1,
                caption: "Test 3",
                imageURL: "https://images.unsplash.com/photo-1784558473693-6b396480e729?q=80&w=1336&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                objectKey: "posts/1/image.jpeg",
                createdAt: Date().addingTimeInterval(7200)
            ),
        ]
        vm.isLoading = false
        return vm
    }
    
    static var mockEmpty: TimelineViewModel {
        let vm = TimelineViewModel(postService: PostService(client: APIClient.shared))
        vm.posts = []
        vm.isLoading = false
        return vm
    }
    
    static var mockLoading: TimelineViewModel {
        let vm = TimelineViewModel(postService: PostService(client: APIClient.shared))
        vm.isLoading = true
        return vm
    }
}
