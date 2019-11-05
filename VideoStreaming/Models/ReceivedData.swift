//
//  ReceivedData.swift
//  VideoStreaming
//
//  Created by Rodrigo Cian Berrios on 25/10/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import Foundation

struct ReceivedData<T:Codable>: Codable {
    var dataArray: [T]

    enum CodingKeys: String, CodingKey {
        case dataArray = "data"
    }
}
