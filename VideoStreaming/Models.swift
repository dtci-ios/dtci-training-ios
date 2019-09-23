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

struct ReceivedData<T:Codable>: Codable {
    var dataArr: [T?]?
    
    enum CodingKeys: String, CodingKey {
        case dataArr = "data"
    }
}
