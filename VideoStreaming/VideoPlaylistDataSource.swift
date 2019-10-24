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
    
    var streamCount: Int {
        return streams.count
    }
    
    init(apiManager: GameStreamsAPIProtocol, gameId: String?) {
        self.apiManager = apiManager
        self.gameId = gameId
    }
    
    func load(completion: @escaping (APIError?) -> Void) {
        guard let gameId = gameId else {
            completion(.responseDataNil)
            return
        }
        
        apiManager.fetchGameStreams(ofGame: gameId) { result in
            switch result {
            case .success(let gameStreams):
                self.streams = gameStreams
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    func clean() -> Bool {
        streams.removeAll()
        gameId = nil
        
        return streamCount == 0 && gameId == nil
    }
    
    func getStream(withRow indexRow: Int) -> Stream? {
        return indexRow < streams.count ? streams[indexRow] : nil
    }
    
    func indexOfStream(withId streamId: String?) -> Int? {
        return streams.firstIndex { $0.id == streamId }
    }
    
}
