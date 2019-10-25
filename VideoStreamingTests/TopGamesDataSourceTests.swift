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
        // given
        gamesMock = []
        fetchDataResultOfCompletionMock = .success(gamesMock)
        sut = TopGamesDataSource(topGamesAPI: TopGamesAPIMock(fetchDataResultOfCompletionMock))

        // when
        sut.fetchDataSource { _ in return }

        // then
        XCTAssertNotNil(sut)
    }

    func testGetGamesCountEqualCero() {
        // given
        gamesMock = []
        fetchDataResultOfCompletionMock = .success(gamesMock)
        sut = TopGamesDataSource(topGamesAPI: TopGamesAPIMock(fetchDataResultOfCompletionMock))

        // when
        sut.fetchDataSource { _ in return }

        // then
        XCTAssertEqual(sut.topGamesCount, 0)
    }

    func testGetGamesCountNotEqualCero() {
        // given
        gamesMock = [Game(id: "123", name: "456", boxArtUrl: "www.Aanypic.com"),
                     Game(id: "789", name: "012", boxArtUrl: "www.Banypic.com"),
                     Game(id: "345", name: "678", boxArtUrl: "www.Canypic.com")]
        fetchDataResultOfCompletionMock = .success(gamesMock)
        sut = TopGamesDataSource(topGamesAPI: TopGamesAPIMock(fetchDataResultOfCompletionMock))

        // when
        let expectation = self.expectation(description: "Fetch")
        sut.fetchDataSource { _ in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)

        // then
        XCTAssertEqual(sut.topGamesCount, 3)
    }

    func testGetGameAtReturnsNil() {
        // given
        gamesMock = []
        fetchDataResultOfCompletionMock = .success(gamesMock)
        sut = TopGamesDataSource(topGamesAPI: TopGamesAPIMock(fetchDataResultOfCompletionMock))

        // when
        sut.fetchDataSource { _ in return }

        // then
        XCTAssertNil(sut.getGameAt(999))
    }

    func testGetGameAtReturnsAGame() {
        // given
        gamesMock = [Game(id: "123", name: "456", boxArtUrl: "www.Aanypic.com"),
                     Game(id: "789", name: "012", boxArtUrl: "www.Banypic.com"),
                     Game(id: "345", name: "678", boxArtUrl: "www.Canypic.com")]
        fetchDataResultOfCompletionMock = .success(gamesMock)
        sut = TopGamesDataSource(topGamesAPI: TopGamesAPIMock(fetchDataResultOfCompletionMock))

        // when
        let expectation = self.expectation(description: "Fetch")
        sut.fetchDataSource { _ in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)

        let secondGame = sut.getGameAt(1)

        // then
        XCTAssertNotEqual(secondGame, gamesMock[0])
        XCTAssertEqual(secondGame, gamesMock[1])
        XCTAssertNotEqual(secondGame, gamesMock[2])
    }

    func testFetchDataSourceSuccess() {
        // given
        gamesMock = [Game(id: "123", name: "456", boxArtUrl: "www.Aanypic.com"),
                     Game(id: "789", name: "012", boxArtUrl: "www.Banypic.com"),
                     Game(id: "345", name: "678", boxArtUrl: "www.Canypic.com")]
        fetchDataResultOfCompletionMock = .success(gamesMock)
        sut = TopGamesDataSource(topGamesAPI: TopGamesAPIMock(fetchDataResultOfCompletionMock))

        // when
        let expectation = self.expectation(description: "Loading Data")
        var completionError: APIError?
        sut.fetchDataSource { error in
            completionError = error
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)

        // then
        XCTAssertEqual(sut.topGamesCount, gamesMock.count)
        XCTAssertNil(completionError)
    }

    func testFetchDataSourceFail() {
        // given
        gamesMock = []
        fetchDataResultOfCompletionMock = .failure(APIError.emptyDataArray)
        sut = TopGamesDataSource(topGamesAPI: TopGamesAPIMock(fetchDataResultOfCompletionMock))

        // when
        let expectation = self.expectation(description: "Fails Load Data")
        var completionError: APIError?
        sut.fetchDataSource { error in
            completionError = error
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)

        // then
        XCTAssertEqual(sut.topGamesCount, 0)
        XCTAssertEqual(completionError, APIError.emptyDataArray)
    }
}
