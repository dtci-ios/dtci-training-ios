//
//  Models.swift
//  VideoStreaming
//
//  Created by Natalia Brasesco on 23/09/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import Foundation

struct Game: Codable {
    var id: String?
    var name: String?
    var boxArtUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case boxArtUrl = "box_art_url"
    }
}

struct Stream: Codable {
    let id: String?
    let userId: String?
    let userName: String?
    let gameId: String?
    let type: String?
    let title: String?
    var viewerCount: Int?
    let startedAt: String?
    let language: String?
    let thumbnailUrl: String?
    let tagIds: [String?]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case userName = "user_name"
        case gameId = "game_id"
        case type
        case title
        case viewerCount = "viewer_count"
        case startedAt = "started_at"
        case language
        case thumbnailUrl = "thumbnail_url"
        case tagIds = "tag_ids"
    }
}

struct ReceivedData<T:Codable>: Codable {
    var dataArray: [T?]?
    
    enum CodingKeys: String, CodingKey {
        case dataArray = "data"
    }
}
