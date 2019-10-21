//
//  StreamPlayerDataSource.swift
//  VideoStreaming
//
//  Created by Julian Llorensi on 21/10/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import Foundation

class StreamPlayerDataSource {
    private var relatedVideos: [Video]
    private var videoTitle: String
    private var userId: String
    
    func getStream(withRow indexRow: Int) -> Video? {
        return indexRow >= 0 && indexRow < relatedVideos.count ? relatedVideos[indexRow] : nil
    }
}
