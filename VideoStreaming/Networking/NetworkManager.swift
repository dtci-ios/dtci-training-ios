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
//    case httpStatusCodeFailure(Int)
    case jsonError(DecodingError)
    case afError(Error)
    case urlError(Error)
    case unknownError(Error)
    
    var localizedDescription: String {
        switch self {
            case .responseDataNil: return "Data is nil"
            case .emptyDataArray: return "Data Array is empty"
//            case .httpStatusCodeFailure(let statusCode): return "Status Code: \(statusCode)"
            case .jsonError(let jsonError): return jsonError.localizedDescription
            case .afError(let afError): return afError.localizedDescription
            case .urlError(let urlError): return urlError.localizedDescription
            case .unknownError(let unknownError): return unknownError.localizedDescription
        }
    }
}

protocol NetworkManager {
    typealias QueryString = [String:Any]
    var request: String { get }
}

extension NetworkManager {
    static var headers: HTTPHeaders {
        return ["Client-ID": "xzpd1f4527fu8fct7p7own0pgi35v5"]
    }
    
    func fetchData <T:Codable> (request: String,
                                parameters: QueryString = [:],
                                completion: @escaping ((Bool, [T], APIError?)->Void)) {
        
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
                        completion(false, [], APIError.jsonError(jsonError as! DecodingError))
                    }
                case .failure(let error):
                    if let error = error as? AFError {
                        completion(false, [], APIError.afError(error))
                    } else if let error = error as? URLError {
                        completion(false, [], APIError.urlError(error))
                    } else {
                        completion(false, [], APIError.unknownError(error))
                    }
                }
        }
    }
}
