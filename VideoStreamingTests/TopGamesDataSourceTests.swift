//
//  TopGamesDataSourceTests.swift
//  VideoStreamingTests
//
//  Created by Rodrigo Cian Berrios on 14/10/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import XCTest
@testable import VideoStreaming

class TopGamesDataSourceTests: XCTestCase {

    var gamesMock: [Game]!
    var fetchDataResultOfCompletionMock: Swift.Result<[Game],APIError>!

    var sut: TopGamesDataSource!

    func testSutNotNil() {
        // 1. given
        gamesMock = []
        fetchDataResultOfCompletionMock = .success(gamesMock)
        sut = TopGamesDataSource(topGamesAPI: TopGamesAPIMock(fetchDataResultOfCompletionMock))

        // 2. when
        sut.fetchDataSource{ error in return }

        // 3. then
        XCTAssertNotNil(sut)
    }

    func testGetGamesCountEqualCero() {
        // 1. given
        gamesMock = []
        fetchDataResultOfCompletionMock = .success(gamesMock)
        sut = TopGamesDataSource(topGamesAPI: TopGamesAPIMock(fetchDataResultOfCompletionMock))

        // 2. when
        sut.fetchDataSource{ error in return }

        // 3. then
        XCTAssertEqual(sut.topGamesCount, 0)
    }

    func testGetGamesCountNotEqualCero() {
        // 1. given
        gamesMock = [Game(id: "123", name: "456", boxArtUrl: "www.Aanypic.com"),
                     Game(id: "789", name: "012", boxArtUrl: "www.Banypic.com"),
                     Game(id: "345", name: "678", boxArtUrl: "www.Canypic.com")]
        fetchDataResultOfCompletionMock = .success(gamesMock)
        sut = TopGamesDataSource(topGamesAPI: TopGamesAPIMock(fetchDataResultOfCompletionMock))

        // 2. when
        sut.fetchDataSource{ error in return }

        // 3. then
        XCTAssertEqual(sut.topGamesCount, 3)
    }

    func testGetGameAtReturnsNil() {
        // 1. given
        gamesMock = []
        fetchDataResultOfCompletionMock = .success(gamesMock)
        sut = TopGamesDataSource(topGamesAPI: TopGamesAPIMock(fetchDataResultOfCompletionMock))

        // 2. when
        sut.fetchDataSource{ error in return }

        // 3. then
        XCTAssertNil(sut.getGameAt(999))
    }

    func testGetGameAtReturnsAGame() {
        // 1. given
        gamesMock = [Game(id: "123", name: "456", boxArtUrl: "www.Aanypic.com"),
                     Game(id: "789", name: "012", boxArtUrl: "www.Banypic.com"),
                     Game(id: "345", name: "678", boxArtUrl: "www.Canypic.com")]
        fetchDataResultOfCompletionMock = .success(gamesMock)
        sut = TopGamesDataSource(topGamesAPI: TopGamesAPIMock(fetchDataResultOfCompletionMock))

        // 2. when
        sut.fetchDataSource{ error in return }
        let secondGame = sut.getGameAt(1)

        // 3. then
        XCTAssertNotEqual(secondGame, gamesMock[0])
        XCTAssertEqual(secondGame, gamesMock[1])
        XCTAssertNotEqual(secondGame, gamesMock[2])
    }

    func testFetchDataSourceSuccess() {
        // 1. given
        gamesMock = [Game(id: "123", name: "456", boxArtUrl: "www.Aanypic.com"),
                     Game(id: "789", name: "012", boxArtUrl: "www.Banypic.com"),
                     Game(id: "345", name: "678", boxArtUrl: "www.Canypic.com")]
        fetchDataResultOfCompletionMock = .success(gamesMock)
        sut = TopGamesDataSource(topGamesAPI: TopGamesAPIMock(fetchDataResultOfCompletionMock))

        // 2. when
        let expectation = self.expectation(description: "Loading Data")
        var completionError: APIError?
        sut.fetchDataSource{ error in
            completionError = error
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)

        // 3. then
        XCTAssertEqual(sut.topGamesCount, gamesMock.count)
        XCTAssertNil(completionError)
    }

    func testFetchDataSourceFail() {
        // 1. given
        gamesMock = []
        fetchDataResultOfCompletionMock = .failure(APIError.emptyDataArray)
        sut = TopGamesDataSource(topGamesAPI: TopGamesAPIMock(fetchDataResultOfCompletionMock))

        // 2. when
        let expectation = self.expectation(description: "Fails Load Data")
        var completionError: APIError?
        sut.fetchDataSource{ error in
            completionError = error
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)

        // 3. then
        XCTAssertEqual(sut.topGamesCount, 0)
        XCTAssertEqual(completionError, APIError.emptyDataArray)
    }
}
