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
    var fetchDataResultOfCompletion: Swift.Result<[Game],APIError>!
    var games: [Game]!
    
    override func setUp() {
        games = [Game(id: "123", name: "456", boxArtUrl: "www.anypic.com")]
        fetchDataResultOfCompletion = .success(games)
        sut = TopGamesDataSource(topGamesAPI: TopGamesAPIMock(fetchDataResultOfCompletion))

        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        sut = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func getGamesCountTest() {
        XCTAssert(sut.getGames().count == games.count)
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}


/*
 class TopGamesDataSource: NSObject {

 [Game(id: "123", name: "456", boxArtUrl: "www.anypic.com")]
     private var topGamesAPI: TopGamesAPIProtocol
     private var games: [Game] = []

     func getGames() -> [Game] {
         return games
     }

     init(topGamesAPI: TopGamesAPIProtocol){
         self.topGamesAPI = topGamesAPI
     }

     func fetchDataSource(completionForView: @escaping (APIError?) -> Void) {
         topGamesAPI.fetchTopGames { result in
             switch result {
             case .success(let topGames):
                 self.games = topGames
                 completionForView(nil)
             case .failure(let error):
                 self.games = []
                 completionForView(error)
             }
         }
     }
 }
*/

