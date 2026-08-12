//
//  NewPostViewModel.swift
//  Friends
//
//  Created by Ziqa on 12/08/26.
//

import Foundation
import UIKit

@Observable
final class NewPostViewModel {
    private let postService: PostService
    
    var isLoading: Bool = false
    
    init(postService: PostService) {
        self.postService = postService
    }
    
    func uploadNewPost(image: UIImage, caption: String, completion: @escaping () -> Void) async {
        isLoading = true
        defer { isLoading = false }
        
        guard let imageData = compressImageAndConvertToJPEG(image: image) else {
            print("Failed to convert image to JPEG.")
            return
        }
        
        let filename = UUID().uuidString
        let request = UploadImageRequest(filename: filename, contentType: "image/jpeg")
        
        do {
            let presigned = try await postService.getPresignedUrl(request: request)
            
            try await postService.uploadImageToBucket(uploadUrl: presigned.uploadUrl, imageData: imageData)
            
            let newPost = NewPostRequest(caption: caption, imageUrl: presigned.publicUrl)
            
            // TODO: add to array in timeline viewmodel
            let _ = try await postService.newPost(request: newPost)
            
            completion()
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
    
    private func compressImageAndConvertToJPEG(image: UIImage) -> Data? {
        let resizedImage = image.aspectFittedToHeight(720)
        return resizedImage.jpegData(compressionQuality: 0.7)
    }
    
}
