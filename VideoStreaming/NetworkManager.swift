//
//  NetworkManager.swift
//  VideoStreaming
//
//  Created by Natalia Brasesco on 23/09/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import Foundation
import Alamofire

//    Get endpoints:
//    - https://api.twitch.tv/helix/games/top
//    - https://api.twitch.tv/helix/streams?game_id=21779
//    - https://api.twitch.tv/helix/videos?user_id=67955580

protocol NetworkManager {
    
    var request: String { get }

}

extension NetworkManager {
    
    static var headers: HTTPHeaders {
        return ["Client-ID": "xzpd1f4527fu8fct7p7own0pgi35v5"]
    }
    
    func fetchData <T:Codable> (request: String, parameters: [String:Any] = [:], completion: @escaping (([T?]?)->Void)) {
        
        Alamofire.request(request, parameters: parameters, headers: Self.headers).responseJSON { (response) in
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
