//
//  PostRequests.swift
//  Friends
//
//  Created by Ziqa on 11/08/26.
//

import Foundation

struct NewPostRequest: Encodable {
    let caption: String
    let imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case caption
        case imageUrl = "image_url"
    }
}

struct UploadImageRequest: Encodable {
    let filename: String
    let contentType: String
    
    enum CodingKeys: String, CodingKey {
        case filename
        case contentType = "content_type"
    }
}
