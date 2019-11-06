//
//  GameStreamsAPI.swift
//  VideoStreaming
//
//  Created by Natalia Brasesco on 25/09/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import Foundation

protocol StreamsAPIProtocol {
    func fetchStreams(completion: @escaping (Result<[Stream],APIError>) -> Void)
    func fetchStreams(ofGame gameId: String, completion: @escaping (Result<[Stream],APIError>) -> Void)
}

class StreamsAPI: NetworkManager, StreamsAPIProtocol {
    var request = "https://api.twitch.tv/helix/streams"
    
    func fetchStreams(completion: @escaping (Result<[Stream], APIError>) -> Void) {
        let parameters: [String:Any] = ["first":100]
        fetchData(request: request, parameters: parameters, completion: completion)
    }
    
    func fetchStreams(ofGame gameId: String, completion: @escaping (Result<[Stream],APIError>) -> Void) {
        let params: [String:Any] = ["game_id":gameId]
        fetchData(request: request, parameters: params, completion: completion)
    }

}
