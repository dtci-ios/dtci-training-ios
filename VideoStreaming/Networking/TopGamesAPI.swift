//
//  TopGamesAPI.swift
//  VideoStreaming
//
//  Created by Natalia Brasesco on 25/09/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import Foundation

class TopGamesAPI: NetworkManager {
    var request = "https://api.twitch.tv/helix/games/top"
 
    func fetchTopGames(completion:  @escaping ([Game]?) -> Void) {
        fetchData(request: request, completion: completion)
    }
}
