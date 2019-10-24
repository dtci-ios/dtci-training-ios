//
//  VideoPlaylistTests.swift
//  VideoStreamingTests
//
//  Created by Natalia Brasesco on 14/10/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import XCTest
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

class VideoPlaylistDataSourceTests: XCTestCase {
    
    var apiManager: MockGameStreamsAPI!
    var dataSource: VideoPlaylistDataSource!
    var streams = [VideoStreaming.Stream(id: "111", userId: "aaa", userName: "AAA", gameId: "g111",
                          type: "", title: "ajgfei", viewerCount: 2, startedAt: "", language: "en",
                          thumbnailUrl: "", tagIds: nil),
                   VideoStreaming.Stream(id: "222", userId: "bbb", userName: "BBB", gameId: "g222",
                          type: "live", title: "lalala", viewerCount: 6, startedAt: "", language: "en",
                          thumbnailUrl: "", tagIds: nil),
                   VideoStreaming.Stream(id: "333", userId: "ccc", userName: "CCC", gameId: "g333",
                          type: "", title: "saraasas", viewerCount: 5, startedAt: "", language: "en",
                          thumbnailUrl: "", tagIds: nil)]
    
    func testDataSourceDidLoad() {
        // given
        apiManager = MockGameStreamsAPI(result: .success(streams))
        dataSource = VideoPlaylistDataSource(apiManager: apiManager, gameId: "")
        
        // when
        let expectation = self.expectation(description: "Loading Data")
        var completionError: APIError?
        dataSource?.load { error in
            completionError = error
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        // then
        XCTAssertEqual(dataSource?.streamCount, streams.count)
        XCTAssertNil(completionError)
    }
    
    func testDataSourceDidNotLoadNilDataError() {
        // given
        apiManager = MockGameStreamsAPI(result: .success(streams))
        dataSource = VideoPlaylistDataSource(apiManager: apiManager!, gameId: nil)
        
        // when
        let expectation = self.expectation(description: "Loading Data")
        var completionError: APIError?
        dataSource?.load { error in
            completionError = error
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        // then
        XCTAssertNotEqual(dataSource?.streamCount, streams.count)
        XCTAssertNotNil(completionError)
        XCTAssert(completionError == APIError.responseDataNil)
        XCTAssert(completionError != APIError.emptyDataArray)
    }
    
    func testDataSourceDidNotLoadEmptyArrayError() {
        // given
        apiManager = MockGameStreamsAPI(result: .failure(.emptyDataArray))
        dataSource = VideoPlaylistDataSource(apiManager: apiManager!, gameId: "")
        
        // when
        let expectation = self.expectation(description: "Loading Data")
        var completionError: APIError?
        dataSource?.load { error in
            completionError = error
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        // then
        XCTAssertNotEqual(dataSource?.streamCount, streams.count)
        XCTAssertNotNil(completionError)
        XCTAssert(completionError == APIError.emptyDataArray)
        XCTAssert(completionError != APIError.wrongAPI)
    }
    
    func testDataSourceGetStreamCount() {
        // given
        apiManager = MockGameStreamsAPI(result: .success(streams))
        dataSource = VideoPlaylistDataSource(apiManager: apiManager!, gameId: "")
        let firstExpectation = self.expectation(description: "Loading Data")
        dataSource?.load { _ in
            firstExpectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        // when
        let firstCount = dataSource?.streamCount
        
        // and given
        apiManager = MockGameStreamsAPI(result: .success([streams[1]]))
        dataSource = VideoPlaylistDataSource(apiManager: apiManager!, gameId: "")
        
        let secondExpectation = self.expectation(description: "Loading Data")
        dataSource?.load { _ in
            secondExpectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        // when
        let secondCount = dataSource?.streamCount
        
        // then
        XCTAssertNotEqual(firstCount, secondCount)
        XCTAssertEqual(firstCount, 3)
        XCTAssertEqual(secondCount, 1)
    }
    
    func testDataSourceClean() {
        // given
        apiManager = MockGameStreamsAPI(result: .success(streams))
        dataSource = VideoPlaylistDataSource(apiManager: apiManager!, gameId: "")
        
        // when
        let expectation = self.expectation(description: "Loading Data")
        dataSource?.load { _ in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        guard let isEmpty = dataSource?.clean() else { return XCTFail() }
        
        // then
        XCTAssert(isEmpty)
        XCTAssertEqual(dataSource?.streamCount, 0)
    }
    
    func testDataSourceContains() {
        // given
        apiManager = MockGameStreamsAPI(result: .success(streams))
        dataSource = VideoPlaylistDataSource(apiManager: apiManager!, gameId: "")
        
        // when
        let expectation = self.expectation(description: "Loading Data")
        dataSource?.load { _ in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        let nilStreamIndex = dataSource?.indexOfStream(withId: "notValidId")
        let validStreamIndex = dataSource?.indexOfStream(withId: "222")
        
        // then
        XCTAssertNil(nilStreamIndex)
        XCTAssertEqual(validStreamIndex, 1)
        XCTAssertNotEqual(validStreamIndex, 0)
    }
    
    func testDataSourceGetStreamWithRow() {
        // given
        apiManager = MockGameStreamsAPI(result: .success(streams))
        dataSource = VideoPlaylistDataSource(apiManager: apiManager!, gameId: "")
        
        // when
        let expectation = self.expectation(description: "Loading Data")
        dataSource?.load { _ in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        let nilStream = dataSource?.getStream(withRow: 4)
        let validStream = dataSource?.getStream(withRow: 0)
        
        //then
        XCTAssertNil(nilStream)
        XCTAssertEqual(validStream?.id, "111")
        XCTAssertEqual(validStream?.userId, "aaa")
        XCTAssertNotEqual(validStream?.language, "sp")
    }
}
