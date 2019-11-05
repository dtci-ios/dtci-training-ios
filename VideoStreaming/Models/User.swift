//
//  User.swift
//  VideoStreaming
//
//  Created by Rodrigo Cian Berrios on 25/10/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import Foundation

struct User: Codable {
    let id: String
    let login: String
    let displayName: String
    let type: String
    let description: String

    enum CodingKeys: String, CodingKey {
        case id
        case login
        case displayName = "display_name"
        case type
        case description
    }
}
