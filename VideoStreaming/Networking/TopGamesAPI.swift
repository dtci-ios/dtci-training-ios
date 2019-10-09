//
//  TopGamesAPI.swift
//  VideoStreaming
//
//  Created by Natalia Brasesco on 25/09/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import Foundation
import Alamofire

protocol TopGamesAPIProtocol {
    func fetchTopGames(completion:  @escaping (Swift.Result<[Game],APIError>) -> Void)
}

class TopGamesAPI: NetworkManager, TopGamesAPIProtocol {
//    var sessionManager: SessionManager
    var request = "https://api.twitch.tv/helix/games/top"
    
//    init(sessionManager: SessionManager = SessionManager.default) {
//        self.sessionManager = sessionManager
//    }
 
    func fetchTopGames(completion:  @escaping (Swift.Result<[Game],APIError>) -> Void) {
        fetchData(request: request, completion: completion)
    }
}
