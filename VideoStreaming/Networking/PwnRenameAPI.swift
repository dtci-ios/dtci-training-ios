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
    let streamer: String
    
    init(forUser user: String) {
        streamer = user
    }
    
    private enum Constants {
        static let serviceURL = "https://pwn.sh/tools/streamapi.py?url="
    }
    
    func fetchStreamingM3U8Urls(completion: @escaping (QualityUrls) -> Void) {
        Alamofire.request(Constants.serviceURL + createEncodedURL(userName: streamer), parameters: nil, headers: GameStreamsAPI.headers).responseJSON { (response) in
            
            guard let dataResponse = response.data else { return }
            
            let decoder = JSONDecoder()
            
            do {
                let pwnResponse = try decoder.decode(PwnResponse.self, from: dataResponse)
                completion(pwnResponse.urls)
            } catch let error {
                print("Error when decode JSON \(error.localizedDescription)")
            }
        }
    }
    
    private func createEncodedURL(userName: String) -> String {
        var urlComponents = URLComponents()
        
        urlComponents.scheme = "https"
        urlComponents.host = "twitch.tv"
        urlComponents.path = userName

        return urlComponents.url?.absoluteString ?? ""
    }
}
