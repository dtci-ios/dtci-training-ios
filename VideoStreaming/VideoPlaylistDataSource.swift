//
//  VideoPlaylistDataSource.swift
//  VideoStreaming
//
//  Created by Natalia Brasesco on 10/10/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import Foundation

class VideoPlaylistDataSource {
    
    private var streams: [Stream] = []
    private var gameId: String?
    private let apiManager: GameStreamsAPIProtocol
    
    init(apiManager: GameStreamsAPIProtocol, gameId: String?) {
        self.apiManager = apiManager
        self.gameId = gameId
    }
    
    func load(completionForView: @escaping (APIError?) -> Void) {
        guard let gameId = gameId else {
            completionForView(.responseDataNil)
            return
        }
        
        apiManager.fetchGameStreams(ofGame: gameId) { result in
            switch result {
            case .success(let gameStreams):
                self.streams = gameStreams
                completionForView(nil)
            case .failure(let error):
                completionForView(error)
            }
        }
    }
    
    func clean() -> Bool {
        streams.removeAll()
        gameId = nil
        
        return (getStreamCount() == 0 && gameId == nil) ? true : false
    }
    
    func getStreamCount() -> Int {
        return streams.count
    }
    
    func getStream(withId streamId: String) -> Stream? {
        if let i = containsStream(withId: streamId) {
            return streams[i]
        } else { return nil }
    }
    
    func getStream(withRow indexRow: Int) -> Stream? {
        return indexRow < streams.count ? streams[indexRow] : nil
    }
    
    func containsStream(withId streamId: String?) -> Int? {
        return streams.firstIndex { $0.id == streamId }
    }
    
}
