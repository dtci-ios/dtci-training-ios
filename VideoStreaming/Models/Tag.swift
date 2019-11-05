//
//  Tag.swift
//  VideoStreaming
//
//  Created by Julian Llorensi on 05/11/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import Foundation

struct Tag: Codable, Equatable {
    let tagId: String
    let localizationNames: [String:String]
    
    var localizatedName: String {
        return localizationNames["en-us"] ?? ""
    }
    
    enum CodingKeys: String, CodingKey {
        case tagId = "tag_id"
        case localizationNames = "localization_names"
    }
}
