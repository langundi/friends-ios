//
//  EditProfileViewModel.swift
//  Friends
//
//  Created by Ziqa on 26/08/26.
//

import Foundation
import OSLog
import UIKit

@Observable
final class EditProfileViewModel {
    
    var isLoading: Bool = false
    
    var profilePicture: String? {
        userStore.profilePicture
    }
    
    var username: String {
        userStore.username
    }
    
    var email: String {
        userStore.email
    }
    
    private let userStore: UserStore
    
    init(userStore: UserStore) {
        self.userStore = userStore
    }
    
    /// Set new profile picture.
    /// - Parameters:
    ///   - image: Profile picture.
    ///   - completion: Completion handler.
    func setProfilePicture(image: UIImage, completion: @escaping () -> Void) async {
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
            let presignedResult = try await userStore.getPresignedURL(request: uploadImageRequest)
            try await userStore.uploadImage(uploadURL: presignedResult.uploadURL, imageData: imageData)
            
            // Remove old profile picture from object storage
            if let objectKey = userStore.objectKey {
                let removeRequest = DeleteProfilePictureRequest(objectKey: objectKey)
                try await userStore.removeProfilePicture(request: removeRequest)
            }
            
            // Set profile picture
            let request = SetProfilePictureRequest(imageURL: presignedResult.publicURL, objectKey: presignedResult.objectKey)
            let result = try await userStore.setProfilePicture(request: request)
            userStore.setProfilePicture(result.profilePicture)
            userStore.setObjectKey(result.objectKey)
            
            completion()
        } catch let networkError as NetworkError {
            AlertManager.shared.showAlert(title: "An error occured", message: networkError.message)
            Logger.network.error("Error profile picture setup: \(networkError)")
        } catch {
            if error.isCancellation { return }
            AlertManager.shared.showAlert(title: "An error occured", message: error.localizedDescription)
            Logger.network.error("Error profile picture setup: \(error)")
        }
    }
    
    /// Delete profile picture.
    func deleteProfilePicture() async {
        guard let objectKey = userStore.objectKey else {
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let request = DeleteProfilePictureRequest(objectKey: objectKey)
            try await userStore.deleteProfilePicture(request: request)
        } catch let networkError as NetworkError {
            AlertManager.shared.showAlert(title: "An error occured", message: networkError.message)
            Logger.network.error("Error profile picture setup: \(networkError)")
        } catch {
            if error.isCancellation { return }
            AlertManager.shared.showAlert(title: "An error occured", message: error.localizedDescription)
            Logger.network.error("Error profile picture setup: \(error)")
        }
    }
    
    /// Change current user's username.
    /// - Parameter username: New username.
    /// - Parameter completion: Completion handler.
    func changeUsername(username: String, completion: @escaping () -> Void) async {
        guard username != self.username else {
            AlertManager.shared.showAlert(title: "An error occured", message: "New username must be different from old username.")
            return
        }
        
        guard UsernameValidator.isValid(username) else {
            AlertManager.shared.showAlert(title: "An error occured", message: "Please enter a valid username format.")
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let request = ChangeUsernameRequest(username: username)
            try await userStore.changeUsername(request: request)
            completion()
        } catch let networkError as NetworkError {
            AlertManager.shared.showAlert(title: "An error occured", message: networkError.message)
            Logger.network.error("Error updating username: \(networkError)")
        } catch {
            if error.isCancellation { return }
            AlertManager.shared.showAlert(title: "An error occured", message: error.localizedDescription)
            Logger.network.error("Error updating username: \(error)")
        }
    }
    
    /// Change current user's email.
    /// - Parameters:
    ///   - email: New email address.
    ///   - completion: Completion handler.
    func changeEmail(email: String, completion: @escaping () -> Void) async {
        guard email != self.email else {
            AlertManager.shared.showAlert(title: "An error occured", message: "New email must be different from old email.")
            return
        }
        
        guard EmailValidator.isValid(email) else {
            AlertManager.shared.showAlert(title: "An error occured", message: "Please enter a valid email format.")
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let request = ChangeEmailRequest(email: email)
            try await userStore.changeEmail(request: request)
            completion()
        } catch let networkError as NetworkError {
            AlertManager.shared.showAlert(title: "An error occured", message: networkError.message)
            Logger.network.error("Error updating email: \(networkError)")
        } catch {
            if error.isCancellation { return }
            AlertManager.shared.showAlert(title: "An error occured", message: error.localizedDescription)
            Logger.network.error("Error updating email: \(error)")
        }
    }
    
}

extension EditProfileViewModel {
    
    static var mockVM: EditProfileViewModel {
        let userService = UserService(client: APIClient.shared)
        let userStore = UserStore(userService: userService)
        let vm = EditProfileViewModel(userStore: userStore)
        return vm
    }
    
}
