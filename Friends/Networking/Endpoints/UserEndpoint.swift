//
//  UserEndpoint.swift
//  Friends
//
//  Created by Ziqa on 11/08/26.
//

import Foundation

enum UserEndpoint: Endpoint {
    case profileImageURL(request: UploadImageRequest)
    case getMyProfile
    case getFriendProfile(id: Int)
    case getMyPosts
    case getFriendPosts(id: Int)
    case searchUsername(username: String)
    case setProfilePicture(request: SetProfilePictureRequest)
    case changeUsername(request: ChangeUsernameRequest)
    case changeEmail(request: ChangeEmailRequest)
    case changePassword(request: ChangePasswordRequest)
    case deleteAccount
    case deleteProfilePicture(request: DeleteProfilePictureRequest)
    case removeProfilePicture(request: DeleteProfilePictureRequest)
    
    var method: HTTPMethod {
        switch self {
        case .profileImageURL:
            return .post
        case .getMyProfile:
            return .get
        case .getFriendProfile:
            return .get
        case .getMyPosts:
            return .get
        case .getFriendPosts:
            return .get
        case .searchUsername:
            return .get
        case .setProfilePicture:
            return .patch
        case .changeUsername:
            return .patch
        case .changeEmail:
            return .patch
        case .changePassword:
            return .patch
        case .deleteAccount:
            return .delete
        case .deleteProfilePicture:
            return .delete
        case .removeProfilePicture:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .profileImageURL:
            return "/user/upload-image"
        case .getMyProfile:
            return "/user"
        case .getFriendProfile(let id):
            return "/user/\(id)"
        case .getMyPosts:
            return "/user/post/me"
        case .getFriendPosts(let id):
            return"/user/post/\(id)"
        case .searchUsername(let username):
            return "/user/search/\(username)"
        case .setProfilePicture:
            return "/user/profile-picture"
        case .changeUsername:
            return "/user/change/username"
        case .changeEmail:
            return "/user/change/email"
        case .changePassword:
            return "/user/change/password"
        case .deleteAccount:
            return "/user/delete"
        case .deleteProfilePicture:
            return "/user/profile-picture"
        case .removeProfilePicture:
            return "/user/profile-picture/remove"
        }
    }
    
    var protected: Bool {
        switch self {
        default:
            return true
        }
    }
    
    var body: (any Encodable)? {
        switch self {
        case .profileImageURL(let image):
            return image
        case .setProfilePicture(let image):
            return image
        case .changeUsername(let username):
            return username
        case .changeEmail(let email):
            return email
        case .changePassword(let password):
            return password
        case .deleteProfilePicture(let image):
            return image
        case .removeProfilePicture(let image):
            return image
        default:
            return nil
        }
    }
}
