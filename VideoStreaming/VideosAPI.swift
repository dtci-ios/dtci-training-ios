//
//  VideosAPI.swift
//  VideoStreaming
//
//  Created by Julian Llorensi on 26/09/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

//import Foundation
//
//protocol VideosAPIProtocol {
//    func fetchVideoList(byGameId gameId: String, completion: @escaping (Result<[Video],APIError>) -> Void)
//    func fetchVideoList(byUserId userId: String, completion: @escaping (Result<[Video],APIError>) -> Void)
//}
//
//class VideosAPI : NetworkManager, VideosAPIProtocol {
//    var request = "https://api.twitch.tv/helix/videos"
//    
//    func fetchVideoList(byGameId gameId: String, completion: @escaping (Result<[Video],APIError>) -> Void) {
//        let parameters: QueryString = ["game_id":gameId]
//        fetchData(request: request, parameters: parameters, completion: completion)
//    }
//    
//    func fetchVideoList(byUserId userId: String, completion: @escaping (Result<[Video],APIError>) -> Void) {
//        let parameters: QueryString = ["user_id":userId]
//        fetchData(request: request, parameters: parameters, completion: completion)
//    }
//}
