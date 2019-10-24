//
//  StreamPlayerDataSource.swift
//  VideoStreaming
//
//  Created by Julian Llorensi on 21/10/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import Foundation

class StreamPlayerDataSource {
    private var relatedVideos: [Video] = [Video]()
    private var apiManager: VideosAPIProtocol
    private var userId: String?
    
    var url: URL
    var videoTitle: String

    var relatedVideosCount: Int {
        return relatedVideos.count
    }

    init(apiManager: VideosAPIProtocol, url: URL, videoTitle: String, userId: String?) {
        self.apiManager = apiManager
        self.url = url
        self.userId = userId
        self.videoTitle = videoTitle
    }

    func loadData(completion: @escaping (APIError?) -> Void) {
        guard let userId = userId else {
            completion(nil)
            return
        }
        
        apiManager.fetchVideoList(byUserId: userId) { result in
            switch result {
            case .success(let relatedVideos):
                self.relatedVideos = relatedVideos
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
        
    }

    func release() -> Bool {
        relatedVideos.removeAll()
        return relatedVideos.count == 0 ? true : false
    }

    func containsVideo(withId id: String) -> Bool {
        return relatedVideos.contains { $0.id == id }
    }

    func getVideo(at indexRow: Int) -> Video? {
        return indexRow >= 0 && indexRow < relatedVideos.count ? relatedVideos[indexRow] : nil
    }
}
