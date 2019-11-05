//
//  GamesAPI.swift
//  VideoStreaming
//
//  Created by Julian Llorensi on 05/11/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import Foundation

protocol GamesAPIProtocol {
    func fetchGames(byId id: String, completion:  @escaping (Swift.Result<[Game],APIError>) -> Void)
}

class GamesAPI: NetworkManager, GamesAPIProtocol {
    var request: String = "https://api.twitch.tv/helix/games"
    
    func fetchGames(byId id: String, completion:  @escaping (Swift.Result<[Game],APIError>) -> Void) {
        let parameters: [String:String] = ["id":id]
        fetchData(request: request, parameters: parameters, completion: completion)
    }
}
