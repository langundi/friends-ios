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
    case likePost(id: Int)
    case getPost(id: Int)
    case getTimeline
    case deletePost(request: DeletePostRequest)
    case unlikePost(id: Int)
    
    var headers: [String : String]? {
        switch self {
        default:
            return ["Content-Type": "application/json"]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .newPost, .getPresignedUrl, .likePost:
            return .post
        case .getPost, .getTimeline:
            return .get
        case .deletePost, .unlikePost:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .newPost, .deletePost:
            return "/post"
        case .getPost(let id):
            return "/post/\(id)"
        case .getPresignedUrl:
            return "/post/upload-image"
        case .getTimeline:
            return "/post/timeline"
        case .likePost(let id):
            return "/post/like/\(id)"
        case .unlikePost(let id):
            return "/post/unlike/\(id)"
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
        case .deletePost(let post):
            return post
        default:
            return nil
        }
    }
}
