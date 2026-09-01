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
    case getMoreTimeline(request: MoreTimelineRequest)
    case deletePost(request: DeletePostRequest)
    case unlikePost(id: Int)
    case getReplies(id: Int)
    case replyPost(id: Int, request: ReplyRequest)
    case deleteReply(id: Int)
    case deleteAllImage(request: DeleteAllImageRequest)
    
    var headers: [String : String]? {
        switch self {
        default:
            return ["Content-Type": "application/json"]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .newPost, .getPresignedUrl, .likePost, .replyPost, .getMoreTimeline:
            return .post
        case .getPost, .getTimeline, .getReplies:
            return .get
        case .deletePost, .unlikePost, .deleteReply, .deleteAllImage:
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
        case .getMoreTimeline:
            return "/post/timeline/more"
        case .likePost(let id):
            return "/post/like/\(id)"
        case .unlikePost(let id):
            return "/post/unlike/\(id)"
        case .getReplies(let id):
            return "/post/reply/\(id)"
        case .replyPost(let id, _):
            return "/post/reply/\(id)"
        case .deleteReply(let id):
            return "/post/reply/\(id)"
        case .deleteAllImage:
            return "/post/image/all"
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
        case .getMoreTimeline(let createdAt):
            return createdAt
        case .deletePost(let post):
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
