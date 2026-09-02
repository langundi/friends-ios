//
//  NewPostViewModel.swift
//  Friends
//
//  Created by Ziqa on 14/08/26.
//

import Foundation
import UIKit
import OSLog

@Observable
final class NewPostViewModel {
    
    var isLoading: Bool = false
    
    private let postStore: PostStore
    private let timelineStore: TimelineStore
    private let userStore: UserStore
    
    init(postStore: PostStore, timelineStore: TimelineStore, userStore: UserStore) {
        self.postStore = postStore
        self.timelineStore = timelineStore
        self.userStore = userStore
    }
    
    /// Upload a new post.
    /// - Parameters:
    ///   - image: Post image.
    ///   - caption: Post caption.
    ///   - completion: Completion handler.
    func uploadNewPost(image: UIImage, caption: String, completion: @escaping () -> Void) async {
        isLoading = true
        defer { isLoading = false }
        
        guard let imageData = compressImageAndConvertToJPEG(image: image) else {
            Logger.system.error("Error: Failed to compress image.")
            return
        }
        
        do {
            // Upload image to presigned URL
            let filename = UUID().uuidString
            let uploadImageRequest = UploadImageRequest(filename: filename, contentType: "image/jpeg")
            let presignedResult = try await postStore.getPresignedURL(request: uploadImageRequest)
            try await postStore.uploadImage(uploadURL: presignedResult.uploadURL, imageData: imageData)
            
            // Upload post
            let newPostRequest = NewPostRequest(caption: caption, imageUrl: presignedResult.publicURL, objectKey: presignedResult.objectKey)
            var postResult = try await postStore.newPost(request: newPostRequest)
            postResult.username = userStore.username
            postResult.profilePicture = userStore.profilePicture
            
            // Insert to post and timeline store
            postStore.insert(postResult)
            timelineStore.insert(postResult)

            completion()
        } catch let networkError as NetworkError {
            AlertManager.shared.showAlert(title: "An error occured", message: networkError.message)
            Logger.network.error("Error uploading post: \(networkError)")
        } catch {
            if error.isCancellation { return }
            AlertManager.shared.showAlert(title: "An error occured", message: error.localizedDescription)
            Logger.network.error("Error uploading post: \(error)")
        }
    }
}
