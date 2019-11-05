//
//  MockGameStreamsAPI.swift
//  VideoStreamingTests
//
//  Created by Rodrigo Cian Berrios on 25/10/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import Foundation
@testable import VideoStreaming

class MockGameStreamsAPI: GameStreamsAPIProtocol {
    var fetchCompletionResult: Swift.Result<[VideoStreaming.Stream],APIError>

    init(result: Swift.Result<[VideoStreaming.Stream],APIError>) {
        self.fetchCompletionResult = result
    }

    func fetchGameStreams(ofGame gameId: String, completion: @escaping (Result<[VideoStreaming.Stream], APIError>) -> Void) {
        DispatchQueue.main.async {
            completion(self.fetchCompletionResult)
        }
    }
}
