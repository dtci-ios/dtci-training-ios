//
//  VideoPlaylistDataSource.swift
//  VideoStreaming
//
//  Created by Natalia Brasesco on 10/10/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import UIKit

class VideoPlaylistDataSource: NSObject, UITableViewDataSource {
    
    private var streams: [Stream] = []
    private var gameId: String?
    private let apiManager: GameStreamsAPIProtocol
    
    init(apiManager: GameStreamsAPIProtocol, gameId: String) {
        self.apiManager = apiManager
        self.gameId = gameId
        super.init()
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
    
    // MARK: DataSourceProtocol functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? streams.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VideoTableViewCell.Constants.reuseIdentifier,
                                                       for: indexPath) as? VideoTableViewCell else { return VideoTableViewCell() }
        
        cell.configure(with: streams[indexPath.row])
        
        return cell
    }
    
    // MARK: CRUD functions
    
    func clean() -> Bool {
        streams.removeAll()
        gameId = nil
        
        return (getStreamCount() == 0 && gameId == nil) ? true : false
    }
    
    func getStreamCount() -> Int {
        return streams.count
    }
    
    func add(stream: Stream?) -> Int {
        if let stream = stream {
            guard let _ = containsStream(withId: stream.id) else {
                streams.append(stream)
                return getStreamCount()
            }
        }
        return getStreamCount()
    }
    
    func containsStream(withId streamId: String?) -> Int? {
        return streams.firstIndex { $0.id == streamId }
    }
    
    func removeStream(withId streamId: String?) -> Int {
        if let i = containsStream(withId: streamId) {
            streams.remove(at: i)
        }
        return getStreamCount()
    }
    
}
