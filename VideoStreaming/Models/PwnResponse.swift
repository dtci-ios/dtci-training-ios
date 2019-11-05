//
//  PwnResponse.swift
//  VideoStreaming
//
//  Created by Natalia Brasesco on 23/09/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import Foundation

struct PwnResponse: Codable {
    typealias QualityUrls = [String:String]
    let urls: QualityUrls
}
