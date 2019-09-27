//
//  VideoModel.swift
//  VideoStreaming
//
//  Created by Julian Llorensi on 17/09/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import Foundation

struct Video: Codable {
    let id: String
    let userId: String
    let userName: String
    let title: String
    let description: String
    let duration: String
    let publishedAt: String
    let url: String
    let thumbnailUrl: String
    let viewCount: Int
    
    var durationAndDate: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let publishedAtDate = dateFormatter.date(from: publishedAt) else {
            return "- • --"
        }
        dateFormatter.dateFormat = "HH:mm • E, MM/dd"
        let publishedDateFormatted = dateFormatter.string(from: publishedAtDate)
        return publishedDateFormatted
    }
    
    var imageUrl: URL? {
        let thumbnailUrlWithWidthAndHeight = thumbnailUrl.replacingOccurrences(of: "%{width}", with: "680")
                                                         .replacingOccurrences(of: "%{height}", with: "540")
        let url = URL(string: thumbnailUrlWithWidthAndHeight)
        return url
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case userName = "user_name"
        case title
        case description
        case duration
        case publishedAt = "published_at"
        case url
        case thumbnailUrl = "thumbnail_url"
        case viewCount = "view_count"
    }
}

