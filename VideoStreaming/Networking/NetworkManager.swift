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

enum APIError: Error {
    case responseDataNil
    case emptyDataArray
    case httpStatusCodeFailure(Int)
    
    var localizedDescription: String {
        switch self {
        case .responseDataNil: return "Data is nil"
        case .emptyDataArray: return "Data Array is empty"
        case .httpStatusCodeFailure(let statusCode): return "Status Code: \(statusCode)"
        }
    }
}

protocol NetworkManager {
    var request: String { get }
}

extension NetworkManager {
    
    static var headers: HTTPHeaders {
        return ["Client-ID": "xzpd1f4527fu8fct7p7own0pgi35v5"]
    }
    
    func fetchData <T:Codable> (request: String,
                                parameters: [String:Any] = [:],
                                completion: @escaping ((Bool, [T], Error?)->Void)) {
        
        Alamofire.request(request, parameters: parameters, headers: Self.headers)
            .validate(statusCode: 200..<300)
            .responseJSON { (response) in
                switch response.result {
                case .success:
                    let jsonDecoder = JSONDecoder()
                    guard let data = response.data else {
                        completion(false, [], APIError.responseDataNil)
                        return
                    }
                    do {
                        let dataResponse = try jsonDecoder.decode(ReceivedData<T>.self, from: data)
                        if dataResponse.dataArray.isEmpty {
                            completion(false, [], APIError.emptyDataArray)
                            return
                        } else { completion(true, dataResponse.dataArray, nil) }
                    } catch let jsonError {
                        completion(false, [], jsonError)
                    }
                case .failure(let error):
                    if let statusCode = response.response?.statusCode {
                        completion(false, [], APIError.httpStatusCodeFailure(statusCode))
                    } else {
                        completion(false, [], error)
                    }
                }
        }
    }
    
}
