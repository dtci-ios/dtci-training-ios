//
//  Game.swift
//  VideoStreaming
//
//  Created by Rodrigo Cian Berrios on 25/10/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import Foundation

struct Game: Codable, Equatable {
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
