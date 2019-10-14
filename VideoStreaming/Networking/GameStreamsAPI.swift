//
//  GameStreamsAPI.swift
//  VideoStreaming
//
//  Created by Natalia Brasesco on 25/09/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import Foundation

protocol GameStreamsAPIProtocol {
    func fetchGameStreams(ofGame gameId: String, completion: @escaping (Result<[Stream],APIError>) -> Void)
}

class GameStreamsAPI: NetworkManager, GameStreamsAPIProtocol {
    var request = "https://api.twitch.tv/helix/streams"
//    //to force error alert:
//    var request = "https://api.twitch.tv/helix/sarasaaa"
    
    func fetchGameStreams(ofGame gameId: String, completion: @escaping (Result<[Stream],APIError>) -> Void) {
        let params: [String:Any] = ["game_id":gameId]
        fetchData(request: request, parameters: params, completion: completion)
    }
}
