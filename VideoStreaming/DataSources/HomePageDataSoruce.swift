//
//  HomePageDataSoruce.swift
//  VideoStreaming
//
//  Created by Julian Llorensi on 06/11/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import Foundation

class HomePageDataSource {
    private var streamsAPIManager: StreamsAPIProtocol
    private var videosAPIManager: VideosAPIProtocol
    private var streams: [Stream] = []
    private var relatedVideos: [Video] = []
    private var userIds: [String] = []
    
    var relatedVideosCount: Int {
        return relatedVideos.count
    }
    
    init(streamsAPIManager: StreamsAPIProtocol, videosAPIManager: VideosAPIProtocol) {
        self.streamsAPIManager = streamsAPIManager
        self.videosAPIManager = videosAPIManager
    }
    
    public func load(completion: @escaping (APIError?) -> Void) {
        loadStreams(completion: completion)
    }
    
    public func getStream(at indexRow: Int) -> Stream? {
        return indexRow >= 0 && indexRow < streams.count ? streams[indexRow] : nil
    }
    
    public func getVideo(at indexRow: Int) -> Video? {
        return indexRow >= 0 && indexRow < relatedVideos.count ? relatedVideos[indexRow] : nil
    }
    
    private func loadStreams(completion: @escaping (APIError?) -> Void) {
        streamsAPIManager.fetchStreams() { result in
            switch result {
            case .success(let retrievedStreams):
                self.streams = retrievedStreams
                self.loadRelatedVideos(userIds: retrievedStreams.compactMap { $0.userId }, completion: completion)
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    private func loadRelatedVideos(userIds: [String], completion: @escaping (APIError?) -> Void) {
        userIds.forEach { userId in
            videosAPIManager.fetchVideoList(byUserId: userId) { result in
                switch result {
                case .success(let retrievedVideos):
                    self.relatedVideos = retrievedVideos
                    completion(nil)
                case .failure(let error):
                    completion(error)
                }
            }
        }
    }
}
