//
//  Stream.swift
//  VideoStreaming
//
//  Created by Rodrigo Cian Berrios on 25/10/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import Foundation

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
    var tagIds: [String?]? {
        willSet {
            streamCategories = tagIds?.compactMap { Category(rawValue: $0 ?? "") }
        }
    }

    var streamCategories: [Category]?
    
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
