//
//  MockVideosAPI.swift
//  VideoStreamingTests
//
//  Created by Rodrigo Cian Berrios on 25/10/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import Foundation
@testable import VideoStreaming

class MockVideosAPI: VideosAPIProtocol {
    private var fetchedResult: Swift.Result<[Video], APIError>

    init(fetchedResult: Swift.Result<[Video], APIError>) {
        self.fetchedResult = fetchedResult
    }

    func fetchVideoList(byGameId gameId: String, completion: @escaping (Result<[Video], APIError>) -> Void) {
        DispatchQueue.main.async {
            completion(self.fetchedResult)
        }
    }

    func fetchVideoList(byUserId userId: String, completion: @escaping (Result<[Video], APIError>) -> Void) {
        DispatchQueue.main.async {
            completion(self.fetchedResult)
        }
    }
}
