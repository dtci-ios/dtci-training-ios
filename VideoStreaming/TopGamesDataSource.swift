//
//  TopGamesDataSource.swift
//  VideoStreaming
//
//  Created by Rodrigo Cian Berrios on 14/10/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import UIKit

class TopGamesDataSource: NSObject {

    private var topGamesAPI: TopGamesAPIProtocol
    private var games: [Game] = []

    init(topGamesAPI: TopGamesAPIProtocol){
        self.topGamesAPI = topGamesAPI
    }

    func getGamesCount() -> Int {
        return games.count
    }

    func getGameAt(_ position: Int) -> Game? {
        return (0 <= position && position <= games.count - 1) ? self.games[position] : nil
    }

    func fetchDataSource(completion: @escaping (APIError?) -> Void) {
        topGamesAPI.fetchTopGames { result in
            switch result {
            case .success(let topGames):
                self.games = topGames
                completion(nil)
            case .failure(let error):
                self.games = []
                completion(error)
            }
        }
    }
}

