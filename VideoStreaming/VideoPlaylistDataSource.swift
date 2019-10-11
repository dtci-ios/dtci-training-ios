//
//  VideoPlaylistDataSource.swift
//  VideoStreaming
//
//  Created by Natalia Brasesco on 10/10/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import UIKit

class VideoPlaylistDataSource: NSObject, UITableViewDataSource {
    
    private var streams: [Stream?] = []
    private var gameId: String
    private let apiManager: GameStreamsAPIProtocol!
    
    init(apiManager: GameStreamsAPIProtocol, gameId: String) {
        self.apiManager = apiManager
        self.gameId = gameId
        super.init()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return streams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VideoTableViewCell.Constants.reuseIdentifier,
                                                       for: indexPath) as? VideoTableViewCell else { return VideoTableViewCell() }
        
        guard let video = streams[indexPath.row] else { return VideoTableViewCell() }
        
        cell.configure(with: video)
        
        return cell
    }
    
    func load(completionForView: @escaping (APIError?) -> Void) {
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
    
//    func fetchCompletionHandler(result: Result<[Stream], APIError>) {
//        switch result {
//        case .success(let gameStreams):
//            streams = gameStreams
//        case .failure(let error):
//            apiError = error
//        }
//    }
    
    
    
}
