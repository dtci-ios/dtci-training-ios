//
//  StreamPlayerDataSource.swift
//  VideoStreaming
//
//  Created by Julian Llorensi on 21/10/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import Foundation

import Foundation

class StreamPlayerDataSource {
    private var relatedVideos: [Video] = []
    private var apiManager: VideosAPI
    private var videoTitle: String
    private var userId: String?

    var relatedVideosCount: Int {
        return relatedVideos.count
    }

    init(apiManager: VideosAPI, videoTitle: String, userId: String) {
        self.apiManager = apiManager
        self.videoTitle = videoTitle
        self.userId = userId
    }

    func loadData(completion: @escaping (APIError?) -> Void) {
        guard let userId = userId else {
            completion(.responseDataNil)
            return
        }

        apiManager.fetchVideos(by: userId) { result in
            switch result {
            case .success(let retrievedVideos):
                relatedVideos = retrievedVideos
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }

    func release() -> Bool {
        relatedVideos.removeAll()
        userId = nil
        return (relatedVideos.count == 0 && userId == nil) ? true : false
    }

    func getVideo(with videoId: String) -> Video? {
        let indexRow = containsVideo(with: videoId) ?? -1
        return getVideo(with: indexRow)
    }

    func containsVideo(with videoId: String) -> Int? {
        return relatedVideos.firstIndex { $0.id == videoId }
    }

    private func getVideo(with indexRow: Int) -> Video? {
        return indexRow >= 0 && indexRow < relatedVideos.count ? relatedVideos[indexRow] : nil
    }
}
