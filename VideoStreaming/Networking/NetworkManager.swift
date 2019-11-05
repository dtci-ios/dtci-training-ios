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

enum APIError: Error, Equatable {
    case responseDataNil
    case emptyDataArray
    case wrongAPI
    case jsonError(Error)
    case alamofireError(Error)
    case urlError(Error)
    case unknownError(Error)
    
    var localizedDescription: String {
        switch self {
            case .responseDataNil: return "Data is nil"
            case .emptyDataArray: return "Data Array is empty"
            case .wrongAPI: return "Wrong API"
            case .jsonError(let jsonError): return jsonError.localizedDescription
            case .alamofireError(let afError): return afError.localizedDescription
            case .urlError(let urlError): return urlError.localizedDescription
            case .unknownError(let unknownError): return unknownError.localizedDescription
        }
    }
    
    static func == (lhs: APIError, rhs: APIError) -> Bool {
        return lhs.localizedDescription == rhs.localizedDescription
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
                                completion: @escaping ((Swift.Result<[T],APIError>)->Void)) {
        
        Alamofire.request(request, parameters: parameters, headers: Self.headers)
            .validate(statusCode: 200 ..< 300)
            .responseJSON { (response) in
                switch response.result {
                case .success:
                    guard let data = response.data else {
                        completion(.failure(APIError.responseDataNil))
                        return
                    }

                    do {
                        let dataResponse = try JSONDecoder().decode(ReceivedData<T>.self, from: data)
                        if dataResponse.dataArray.isEmpty {
                            completion(.failure(APIError.emptyDataArray))
                        } else { completion(.success(dataResponse.dataArray)) }
                    } catch let jsonError { completion(.failure(APIError.jsonError(jsonError))) }
                    
                case .failure(let error):
                    if let error = error as? AFError {
                        completion(.failure(APIError.alamofireError(error)))
                    } else if let error = error as? URLError {
                        completion(.failure(APIError.urlError(error)))
                    } else { completion(.failure(APIError.unknownError(error))) }
                }
        }
    }
}
