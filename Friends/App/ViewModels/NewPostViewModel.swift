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
    
    init(postStore: PostStore, timelineStore: TimelineStore) {
        self.postStore = postStore
        self.timelineStore = timelineStore
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
            let postResult = try await postStore.newPost(request: newPostRequest)
            postStore.insert(postResult)
            
            // Refresh Timeline
            try await timelineStore.refreshTimeline()
            
            // Delay to compensate for Kingfisher TLS error
            try? await Task.sleep(for: .seconds(2))
            
            // Insert new post to post store
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
    
    private func compressImageAndConvertToJPEG(image: UIImage) -> Data? {
        return image.jpegData(compressionQuality: 0.7)
    }
}
