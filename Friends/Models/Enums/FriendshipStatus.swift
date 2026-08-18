//
//  FriendshipStatus.swift
//  Friends
//
//  Created by Ziqa on 18/08/26.
//

import Foundation

enum FriendshipStatus: String, Decodable {
    case notAdded = "NOT_ADDED"
    case sent = "SENT"
    case received = "RECEIVED"
    case friends = "FRIENDS"
}
