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
    
    func fetchData <T:Codable> (request: String,
                                parameters: [String:Any] = [:],
                                completion: @escaping ((Bool, [T]?, String?)->Void)) {
        
        Alamofire.request(request, parameters: parameters, headers: Self.headers)
            .validate(statusCode: 200..<300)
            .responseJSON { (response) in
                switch response.result {
                    case .success:
                        let jsonDecoder = JSONDecoder()
                        guard let data = response.data else {
                            completion(false, nil, "Data is nil")
                            return
                        }
                        do {
                            let dataResponse = try jsonDecoder.decode(ReceivedData<T>.self, from: data)
                            guard let array = dataResponse.dataArray else {
                                completion(false, nil, "Empty dataArray")
                                return
                            }
                            completion(true, array, nil)
                        } catch let jsonError {
                            completion(false, nil, jsonError.localizedDescription)
                        }
                    case .failure(let error):
                        if let httpStatusCode = response.response?.statusCode {
                            completion(false, nil, " Status Code: \(httpStatusCode) ")
                        } else {
                            completion(false, nil, error.localizedDescription)
                        }
                }
        }
    }
    
}
