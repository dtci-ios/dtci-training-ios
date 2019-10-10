//
//  PwnAPI.swift
//  VideoStreaming
//
//  Created by Julian Llorensi on 09/10/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import Foundation
import Alamofire

enum PwnServiceAPIError: Error {
    case jsonError(Error)
    case alamofireError(Error)
    case urlError(Error)
    case unknownError(Error)
    
    var localizedDescription: String {
        switch self {
            case .jsonError(let jsonError): return jsonError.localizedDescription
            case .alamofireError(let afError): return afError.localizedDescription
            case .urlError(let urlError): return urlError.localizedDescription
            case .unknownError(let unknownError): return unknownError.localizedDescription
        }
    }
}

class PwnServiceAPI {
    var requestURL: String
    var streamer: String
    
    private enum Constants {
        static let twitchURL = "https://twitch.tv"
        static let serviceURL = "https://pwn.sh/tools/streamapi.py"
    }
    
    init?(forUser user: String) {
        streamer = user
        
        guard let twitchURL = URL(string: Constants.twitchURL) else { return nil }
        
        var componentsForTwitchURL = URLComponents(url: twitchURL, resolvingAgainstBaseURL: false)
        
        componentsForTwitchURL?.percentEncodedPath = "/\(streamer.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")"
        
        guard let serviceURL = URL(string: Constants.serviceURL) else { return nil }

        var componentsForServiceURL = URLComponents(url: serviceURL, resolvingAgainstBaseURL: false)
        
        componentsForServiceURL?.queryItems = [
            URLQueryItem(name: "url", value: componentsForTwitchURL?.url?.absoluteString ?? "")
        ]
        
        requestURL = componentsForServiceURL?.url?.absoluteString ?? ""
    }
    
    func fetchStreamingM3U8Urls(completion: @escaping (Swift.Result<PwnResponse.QualityUrls, PwnServiceAPIError>) -> Void) {
        Alamofire.request(requestURL, parameters: nil, headers: GameStreamsAPI.headers).responseJSON { (response) in
            guard let dataResponse = response.data else { return }
            
            let decoder = JSONDecoder()
            
            do {
                let pwnResponse = try decoder.decode(PwnResponse.self, from: dataResponse)
                completion(.success(pwnResponse.urls))
            } catch let error {
                completion(.failure(.jsonError(error)))
            }
        }
    }
}
