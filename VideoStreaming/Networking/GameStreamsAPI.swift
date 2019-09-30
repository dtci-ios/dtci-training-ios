//
//  GameStreamsAPI.swift
//  VideoStreaming
//
//  Created by Natalia Brasesco on 25/09/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import Foundation

class GameStreamsAPI: NetworkManager {
    var request = "https://api.twitch.tv/helix/streams"
 
    func fetchGameStreams(ofGame gameId: String = "21779", completion: @escaping ([Stream]?) -> Void) {
        let parameters: QueryString = ["game_id":gameId]
        fetchData(request: request, parameters: parameters, completion: completion)
    }
}
