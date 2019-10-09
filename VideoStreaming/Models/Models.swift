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
    
    func boxArtThumbnailUrl (width: Int? = nil, height: Int? = nil) -> String {
        guard let unBoxArtUrl = boxArtUrl else {
            return ""
        }
        guard let unWidth = width, let unHeight = height else {
            //for full size image.
            return unBoxArtUrl.replacingOccurrences(of: "{width}x{height}", with: "x")
        }
        return unBoxArtUrl.replacingOccurrences(of: "{width}x{height}", with: "\(unWidth)x\(unHeight)")
    }
    
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
    
    var durationAndDate: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        guard let startedAtDate = dateFormatter.date(from: startedAt ?? "") else {
            return "- • --"
        }
        
        dateFormatter.dateFormat = "HH:mm • E, MM/dd"
        let startedAtFormatted = dateFormatter.string(from: startedAtDate)
        
        return startedAtFormatted
    }

    var imageURL: URL? {
        let thumbnailUrlWithWidthAndHeight = thumbnailUrl?.replacingOccurrences(of: "{width}", with: "")
                                                          .replacingOccurrences(of: "{height}", with: "")
        let url = URL(string: thumbnailUrlWithWidthAndHeight ?? "")
        return url
    }
    
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

struct QualityUrls: Codable {
    let quality160p: String?
    let quality360p: String?
    let quality480p: String?
    let quality720p: String?
    let quality720p60: String?
    let quality1080p60: String?
    
    enum CodingKeys: String, CodingKey {
        case quality160p = "160p"
        case quality360p = "360p"
        case quality480p = "480p"
        case quality720p = "720p"
        case quality720p60 = "720p60"
        case quality1080p60 = "1080p60"
    }
}

struct PwnResponse: Codable {
    let urls: QualityUrls
}

struct ReceivedData<T:Codable>: Codable {
    var dataArray: [T]
    
    enum CodingKeys: String, CodingKey {
        case dataArray = "data"
    }
}
