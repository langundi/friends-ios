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
    
    func uploadNewPost(image: UIImage, caption: String, completion: @escaping () -> Void) async {
        isLoading = true
        defer { isLoading = false }
        
        // Compress image
        guard let imageData = compressImageAndConvertToJPEG(image: image) else {
            Logger.system.error("Error: Failed to compress image.")
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
            
            Logger.network.info("New post created for id: \(newPost.id)")
            
            // Delay to compensate for Kingfisher TLS error
            try? await Task.sleep(for: .seconds(2))
            
            // Insert new post to posts array in services
            postService.insert(newPost)
            
            completion()
        } catch let networkError as NetworkError {
            Logger.network.error("Error uploading post: \(networkError)")
            
            AlertManager.shared.showAlert(
                title: "An error occured",
                message: networkError.message
            )
        } catch {
            Logger.network.error("Error uploading post: \(error)")
            
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
