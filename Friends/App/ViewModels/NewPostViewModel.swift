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
    private let postService: PostService
    
    init(postService: PostService) {
        self.postService = postService
    }
    
    var isLoading: Bool = false
    
    /// Upload a new post.
    /// - Parameters:
    ///   - image: Post image.
    ///   - caption: Post caption.
    ///   - completion: Completion closure.
    func uploadNewPost(image: UIImage, caption: String, completion: @escaping () -> Void) async {
        isLoading = true
        defer { isLoading = false }
        
        guard let imageData = compressImageAndConvertToJPEG(image: image) else {
            Logger.system.error("Error: Failed to compress image.")
            return
        }
        
        let filename = UUID().uuidString
        let request = UploadImageRequest(filename: filename, contentType: "image/jpeg")
        
        do {
            // Fetch presigned URL
            let presignedResponse = try await postService.getPresignedUrl(request: request)
            
            // Upload image to presigned URL
            try await postService.uploadImageToBucket(uploadUrl: presignedResponse.uploadURL, imageData: imageData)
            
            let newPostRequest = NewPostRequest(
                caption: caption,
                imageUrl: presignedResponse.publicURL,
                objectKey: presignedResponse.objectKey
            )
            
            // Upload post
            let newPost = try await postService.newPost(request: newPostRequest)
            
            // Delay to compensate for Kingfisher TLS error
            try? await Task.sleep(for: .seconds(2))
            
            // Insert new post to posts array in services
            postService.insert(newPost)
            
            Logger.network.info("New post created for id: \(newPost.id)")
            
            completion()
        } catch let networkError as NetworkError {
            AlertManager.shared.showAlert(title: "An error occured", message: networkError.message)
            Logger.network.error("Error uploading post: \(networkError)")
        } catch {
            AlertManager.shared.showAlert(title: "An error occured", message: error.localizedDescription)
            Logger.network.error("Error uploading post: \(error)")
        }
    }
    
    private func compressImageAndConvertToJPEG(image: UIImage) -> Data? {
        return image.jpegData(compressionQuality: 0.7)
    }
}
