//
//  JSONResponse.swift
//  Friends
//
//  Created by Ziqa on 28/07/26.
//

import Foundation

struct JSONResponse<T:Decodable>: Decodable {
    let success: Bool
    let data: T?
    let error: APIError?
}

struct APIError: Decodable, Error {
    let status: Int
    let message: String
}

struct NoData: Decodable {}
