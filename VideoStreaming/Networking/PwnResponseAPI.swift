//
//  PwnAPI.swift
//  VideoStreaming
//
//  Created by Julian Llorensi on 09/10/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import Foundation
import Alamofire

class PwnServiceAPI {
    private var requestURL: String?
    private var streamerName: String?
    
    private enum Constants {
        static let twitchURL = "https://twitch.tv"
        static let serviceURL = "https://pwn.sh/tools/streamapi.py"
    }
    
    init(userName name: String) {
        streamerName = name
    }
    
    func fetchStreamingM3U8Urls(completion: @escaping (Swift.Result<PwnResponse.QualityUrls, APIError>) -> Void) {
        guard let twitchURL = URL(string: Constants.twitchURL) else { return }
        
        var componentsForTwitchURL = URLComponents(url: twitchURL, resolvingAgainstBaseURL: false)
        
        componentsForTwitchURL?.path = "/\(streamerName ?? "")"
        
        guard let serviceURL = URL(string: Constants.serviceURL) else { return }

        var componentsForServiceURL = URLComponents(url: serviceURL, resolvingAgainstBaseURL: false)
        
        componentsForServiceURL?.queryItems = [
            URLQueryItem(name: "url", value: componentsForTwitchURL?.url?.absoluteString ?? "")
        ]
        
        requestURL = componentsForServiceURL?.url?.absoluteString ?? ""
        
        Alamofire.request(requestURL ?? "", parameters: nil, headers: GameStreamsAPI.headers).responseJSON { (response) in
            switch response.result {
            case .success:
                
                guard let dataResponse = response.data else { return }
                
                let decoder = JSONDecoder()
                
                do {
                    let pwnResponse = try decoder.decode(PwnResponse.self, from: dataResponse)
                    completion(.success(pwnResponse.urls))
                } catch let error {
                    completion(.failure(.jsonError(error)))
                }
                
            case .failure(let error):
                
                if let error = error as? AFError {
                    completion(.failure(.alamofireError(error)))
                    
                } else if let error = error as? URLError {
                    completion(.failure(.urlError(error)))
                    
                } else {
                    completion(.failure(.unknownError(error)))
                }
            }
        }
    }
}



