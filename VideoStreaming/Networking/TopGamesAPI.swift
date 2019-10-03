//
//  TopGamesAPI.swift
//  VideoStreaming
//
//  Created by Natalia Brasesco on 25/09/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import Foundation

protocol TopGamesAPIProtocol {
    func fetchTopGames(completion:  @escaping (Result<[Game],APIError>) -> Void)
}

class TopGamesAPI: NetworkManager, TopGamesAPIProtocol {
    var request = "https://api.twitch.tv/helix/games/top"
    // endpoint for errorAlert
//    var request = "https://api.twitch.tv/helix/games/sarasa"
 
    func fetchTopGames(completion:  @escaping (Result<[Game],APIError>) -> Void) {
        fetchData(request: request, completion: completion)
    }
}
