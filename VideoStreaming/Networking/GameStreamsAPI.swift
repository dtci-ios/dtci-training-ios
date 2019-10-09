//
//  GameStreamsAPI.swift
//  VideoStreaming
//
//  Created by Natalia Brasesco on 25/09/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import Foundation
import Alamofire

protocol GameStreamsAPIProtocol {
    func fetchGameStreams(ofGame gameId: String, completion: @escaping (Swift.Result<[Stream],APIError>) -> Void)
}

class GameStreamsAPI: NetworkManager, GameStreamsAPIProtocol {
   
    var manager: SessionManager

    init(manager: SessionManager = SessionManager.default) {
        self.manager = manager
    }

    var request = "https://api.twitch.tv/helix/streams"
    
    func fetchGameStreams(ofGame gameId: String, completion: @escaping (Swift.Result<[Stream],APIError>) -> Void) {
        let params: [String:Any] = ["game_id":gameId]
        fetchData(request: request, parameters: params, completion: completion)
    }
}
