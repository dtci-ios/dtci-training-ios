//
//  NetworkManager.swift
//  VideoStreaming
//
//  Created by Natalia Brasesco on 23/09/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
    
//    Get endpoint:
//    - https://api.twitch.tv/helix/games/top
//    - https://api.twitch.tv/helix/streams?game_id=21779
//    - https://api.twitch.tv/helix/videos?user_id=67955580
    
    private let requestTopGamesURL = "https://api.twitch.tv/helix/games/top"
    private let clientID = "xzpd1f4527fu8fct7p7own0pgi35v5"
    
    private let headers: HTTPHeaders = [
        "Client-ID": "xzpd1f4527fu8fct7p7own0pgi35v5"
    ]
    
    func getGames (completion:  @escaping (([Game?]?)->Void)) {
        let requestForAPI = "\(requestTopGamesURL)"
        
        
        getData(request: requestForAPI, completion: completion)
    }
    
    private func getData <T:Codable> (request: String, completion: @escaping (([T?]?)->Void)) {
        
        Alamofire.request(request, headers: headers).responseJSON { (response) in
            let jsonDecoder = JSONDecoder()
            guard let data = response.data else {
                completion(nil)
                return
            }
            let gamesResponse = try? jsonDecoder.decode(ReceivedData<T>.self, from: data)
            guard let arr = gamesResponse?.dataArr else {
                completion(nil)
                return
            }
            completion(arr)
        }
    }
    
}
