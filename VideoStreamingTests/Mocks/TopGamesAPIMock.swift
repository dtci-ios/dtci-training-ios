//
//  File.swift
//  VideoStreamingTests
//
//  Created by Rodrigo Cian Berrios on 14/10/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import Foundation
@testable import VideoStreaming

class TopGamesAPIMock: NetworkManager, TopGamesAPIProtocol {

    var request = ""

    var fetchDataResultOfCompletion: Swift.Result<[Game],APIError>

    init(_ fetchDataResultOfCompletion: Swift.Result<[Game],APIError>) {
        self.fetchDataResultOfCompletion = fetchDataResultOfCompletion
    }

    func fetchTopGames(completion: @escaping (Result<[Game],APIError>) -> Void) {
        DispatchQueue.main.async {
            completion(self.fetchDataResultOfCompletion)
        }
    }
}
