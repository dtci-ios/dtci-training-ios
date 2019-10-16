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

    var sut: TopGamesDataSource!

    var gamesMock: [Game]!
    var fetchDataResultOfCompletionMock: Swift.Result<[Game],APIError>!
    
    override func setUp() {
        gamesMock = [Game(id: "123", name: "456", boxArtUrl: "www.Aanypic.com"),
                     Game(id: "789", name: "012", boxArtUrl: "www.Banypic.com"),
                     Game(id: "345", name: "678", boxArtUrl: "www.Canypic.com")]
        fetchDataResultOfCompletionMock = .success(gamesMock)
        
        sut = TopGamesDataSource(topGamesAPI: TopGamesAPIMock(fetchDataResultOfCompletionMock))

        sut.fetchDataSource{ error in return }        
    }
    
    override func tearDown() {
        gamesMock = nil
        fetchDataResultOfCompletionMock = nil
        sut = nil
    }

    func testSutNotNil() {
        XCTAssertNotNil(sut)
    }

    func testHasAnyGame() {
        XCTAssertEqual(sut.hasAnyGame(), true)
        sut.clearGames()
        XCTAssertEqual(sut.hasAnyGame(), false)
    }

    func testIsGamesEmpty() {
        XCTAssertEqual(sut.isGamesEmpty(), false)
        sut.clearGames()
        XCTAssertEqual(sut.isGamesEmpty(), true)
    }

    func testGetGamesCount() {
        XCTAssertEqual(sut.getGamesCount(), gamesMock.count)

        sut.addGameAt(Game(), position: Int.random(in: 0..<gamesMock.count - 1))
        XCTAssertEqual(sut.getGamesCount(), gamesMock.count + 1)

        sut.removeGameAt(Int.random(in: 0..<gamesMock.count))
        XCTAssertEqual(sut.getGamesCount(), gamesMock.count)

        sut.clearGames()
        XCTAssertEqual(sut.getGamesCount(), 0)
    }

    func testGetGameAt() {
        let randomPosition = Int.random(in: 0..<gamesMock.count - 1)
        XCTAssertEqual(sut.getGameAt(randomPosition), gamesMock[randomPosition])
    }

    func testGetFirstGame() {
        XCTAssertEqual(sut.getFirstGame(), gamesMock[0])
    }

    func testGetLastGame() {
        XCTAssertEqual(sut.getLastGame(), gamesMock[2])
    }

    func testClearGames() {
        XCTAssertEqual(sut.isGamesEmpty(), false)
        sut.clearGames()
        XCTAssertEqual(sut.isGamesEmpty(), true)
    }

    func testAddFirstGame() {
        let firstGame = Game(id: "1", name: "first", boxArtUrl: "www.first.com")
        XCTAssertNotEqual(sut.getFirstGame(), firstGame)
        sut.addFirstGame(firstGame)
        XCTAssertEqual(sut.getFirstGame(), firstGame)
    }

    func testAddLastGame() {
        let lastGame = Game(id: "999", name: "last", boxArtUrl: "www.last.com")
        XCTAssertNotEqual(sut.getLastGame(), lastGame)
        sut.addLastGame(lastGame)
        XCTAssertEqual(sut.getLastGame(), lastGame)
    }

    func testAddGameAt() {
        let aGame = Game(id: "357", name: "a Game", boxArtUrl: "www.agame.com")
        let randomPosition = Int.random(in: 0..<gamesMock.count - 1)

        XCTAssertNotEqual(sut.getGameAt(randomPosition), aGame)
        sut.addGameAt(aGame, position: randomPosition)
        XCTAssertEqual(sut.getGameAt(randomPosition), aGame)
    }

    func testContainsGame() {
        let containedGame = gamesMock[1]
        let notContainedGame = Game(id: "365412", name: "not contained game", boxArtUrl: "www.not.com")

        XCTAssertEqual(sut.containsGame(containedGame), true)
        XCTAssertEqual(sut.containsGame(notContainedGame), false)
    }

    func testRemoveFirstGame() {
        let firstGame = sut.getGameAt(0)
        let secondGame = sut.getGameAt(1)

        sut.removeFirstGame()
        XCTAssertNotEqual(sut.getFirstGame(), firstGame)
        XCTAssertEqual(sut.getFirstGame(), secondGame)
    }


    func testRemoveLastGame() {
        let lastGame = sut.getGameAt(sut.getGamesCount() - 1)
        let gameBeforeLast = sut.getGameAt(sut.getGamesCount() - 2)

        sut.removeLastGame()
        XCTAssertNotEqual(sut.getLastGame(), lastGame)
        XCTAssertEqual(sut.getLastGame(), gameBeforeLast)
    }

    func testRemoveGameAt() {
        let randomPosition = Int.random(in: 0..<gamesMock.count - 1)
        let randomGame = sut.getGameAt(randomPosition)

        sut.removeGameAt(randomPosition)
        XCTAssertNotEqual(sut.getGameAt(randomPosition), randomGame)
    }

    func testRemoveGame() {
        let randomPosition = Int.random(in: 0..<gamesMock.count - 1)
        let randomGame = sut.getGameAt(randomPosition)!

        XCTAssertEqual(sut.containsGame(randomGame), true)
        sut.removeGame(randomGame)
        XCTAssertEqual(sut.containsGame(randomGame), false)
    }
}
