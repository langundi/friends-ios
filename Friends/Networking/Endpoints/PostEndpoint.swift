//
//  PostEndpoint.swift
//  Friends
//
//  Created by Ziqa on 11/08/26.
//

import Foundation

enum PostEndpoint: Endpoint {
    case newPost(request: NewPostRequest)
    case getPresignedUrl(request: UploadImageRequest)
    case getPost(Id: Int)
    case getMyPosts
    case getUsersPosts(userId: Int)
    case deletePost(Id: Int)
    
    var headers: [String : String]? {
        switch self {
        default:
            return ["Content-Type": "application/json"]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .newPost, .getPresignedUrl:
            return .post
        case .getPost, .getMyPosts, .getUsersPosts:
            return .get
        case .deletePost:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .newPost:
            return "/post"
        case .getPost(let id), .deletePost(let id):
            return "/post/\(id)"
        case .getMyPosts:
            return"/post/user/me"
        case .getUsersPosts(let userId):
            return "/post/user/\(userId)"
        case .getPresignedUrl:
            return "/post/upload"
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
        case .newPost(let post):
            return post
        case .getPresignedUrl(let file):
            return file
        default:
            return nil
        }
    }
}
