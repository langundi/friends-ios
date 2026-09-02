//
//  PostEndpoint.swift
//  Friends
//
//  Created by Ziqa on 11/08/26.
//

import Foundation

enum PostEndpoint: Endpoint {
    case newPost(request: NewPostRequest)
    case uploadImage(request: UploadImageRequest)
    case deletePost(id: Int, request: DeletePostRequest)
    case deleteAllImage(request: DeleteAllImageRequest)
    case getTimeline
    case getMoreTimeline(request: MoreTimelineRequest)
    case getPost(id: Int)
    case getPostReplies(id: Int)
    case likePost(id: Int)
    case replyPost(id: Int, request: ReplyRequest)
    case unlikePost(id: Int)
    case deleteReply(id: Int)
    
    var headers: [String : String]? {
        switch self {
        default:
            return ["Content-Type": "application/json"]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .newPost:
            return .post
        case .uploadImage:
            return .post
            
        case .deletePost:
            return .delete
        case .deleteAllImage:
            return .delete
            
        case .getTimeline:
            return .get
        case .getMoreTimeline:
            return .post
            
        case .getPost:
            return .get
        case .getPostReplies:
            return .get
            
        case .likePost:
            return .post
        case .replyPost:
            return .post
            
        case .unlikePost:
            return .delete
        case .deleteReply:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .newPost:
            return "/post"
        case .uploadImage:
            return "/post/upload-image"
            
        case .deleteAllImage:
            return "/post/image/all"
            
        case .getTimeline:
            return "/post/timeline"
        case .getMoreTimeline:
            return "/post/timeline/more"
            
        case .getPost(let id):
            return "/post/\(id)"
        case .getPostReplies(let id):
            return "/post/\(id)/replies"
        case .likePost(let id):
            return "/post/\(id)/like"
        case .deletePost(let id, _):
            return "/post/\(id)"
        case .replyPost(let id, _):
            return "/post/\(id)/reply"
        case .unlikePost(let id):
            return "/post/\(id)/unlike"
        case .deleteReply(let id):
            return "/post/\(id)/reply"
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
        case .uploadImage(let file):
            return file
        case .getMoreTimeline(let createdAt):
            return createdAt
        case .deletePost(_, let post):
            return post
        case .replyPost(_, let reply):
            return reply
        case .deleteAllImage(let images):
            return images
        default:
            return nil
        }
    }
}
