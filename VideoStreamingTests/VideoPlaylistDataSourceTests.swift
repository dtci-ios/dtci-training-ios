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
    var streams: [VideoStreaming.Stream]
    
    init(streams: [VideoStreaming.Stream]) {
        self.streams = streams
    }
    
    func fetchGameStreams(ofGame gameId: String, completion: @escaping (Result<[VideoStreaming.Stream], APIError>) -> Void) {
        streams.isEmpty ? completion(.failure(.emptyDataArray)) : completion(.success(streams))
    }
}

class VideoPlaylistDataSourceTests: XCTestCase {
    
    var apiManager: MockGameStreamsAPI?
    var dataSource: VideoPlaylistDataSource?
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
        apiManager = MockGameStreamsAPI(streams: streams)
        dataSource = VideoPlaylistDataSource(apiManager: apiManager!, gameId: "")
        
        // where
        let expectation = self.expectation(description: "Loading Data")
        var completionError: APIError?
        dataSource?.load { error in
            completionError = error
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        // then
        XCTAssertEqual(dataSource?.getStreamCount(), streams.count)
        XCTAssertNil(completionError)
    }
    
    func testDataSourceDidNotLoadNilDataError() {
        // given
        apiManager = MockGameStreamsAPI(streams: streams)
        dataSource = VideoPlaylistDataSource(apiManager: apiManager!, gameId: nil)
        
        // where
        let expectation = self.expectation(description: "Loading Data")
        var completionError: APIError?
        dataSource?.load { error in
            completionError = error
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        // then
        XCTAssertNotEqual(dataSource?.getStreamCount(), streams.count)
        XCTAssertNotNil(completionError)
        XCTAssert(completionError == APIError.responseDataNil)
        XCTAssert(completionError != APIError.emptyDataArray)
    }
    
    func testDataSourceDidNotLoadEmptyArrayError() {
        // given
        apiManager = MockGameStreamsAPI(streams: [])
        dataSource = VideoPlaylistDataSource(apiManager: apiManager!, gameId: "")
        
        // where
        let expectation = self.expectation(description: "Loading Data")
        var completionError: APIError?
        dataSource?.load { error in
            completionError = error
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        // then
        XCTAssertNotEqual(dataSource?.getStreamCount(), streams.count)
        XCTAssertNotNil(completionError)
        XCTAssert(completionError == APIError.emptyDataArray)
        XCTAssert(completionError != APIError.wrongAPI)
    }
    
    func testDataSourceGetStreamCount() {
        // given
        apiManager = MockGameStreamsAPI(streams: streams)
        dataSource = VideoPlaylistDataSource(apiManager: apiManager!, gameId: "")
        dataSource?.load { _ in }
        
        // where
        let firstCount = dataSource?.getStreamCount()
        
        // and given
        apiManager = MockGameStreamsAPI(streams: [streams[1]])
        dataSource = VideoPlaylistDataSource(apiManager: apiManager!, gameId: "")
        dataSource?.load { _ in }
        
        // where
        let secondCount = dataSource?.getStreamCount()
        
        // then
        XCTAssertNotEqual(firstCount, secondCount)
        XCTAssertEqual(firstCount, 3)
        XCTAssertEqual(secondCount, 1)
    }
    
    func testDataSourceClean() {
        // given
        apiManager = MockGameStreamsAPI(streams: streams)
        dataSource = VideoPlaylistDataSource(apiManager: apiManager!, gameId: "")
        
        // where
        dataSource?.load { _ in }
        guard let isEmpty = dataSource?.clean() else { return XCTFail() }
        
        // then
        XCTAssert(isEmpty)
        XCTAssertEqual(dataSource?.getStreamCount(), 0)
    }
    
    func testDataSourceContains() {
        // given
        apiManager = MockGameStreamsAPI(streams: streams)
        dataSource = VideoPlaylistDataSource(apiManager: apiManager!, gameId: "")
        
        // where
        dataSource?.load { _ in }
        let nilStreamIndex = dataSource?.containsStream(withId: "notValidId")
        let validStreamIndex = dataSource?.containsStream(withId: "222")
        
        // then
        XCTAssertNil(nilStreamIndex)
        XCTAssertEqual(validStreamIndex, 1)
        XCTAssertNotEqual(validStreamIndex, 0)
    }
    
    func testDataSourceGetStreamWithId() {
        // given
        apiManager = MockGameStreamsAPI(streams: streams)
        dataSource = VideoPlaylistDataSource(apiManager: apiManager!, gameId: "")
        
        // where
        dataSource?.load { _ in }
        let nilStream = dataSource?.getStream(withId: "notValidId")
        let validStream = dataSource?.getStream(withId: "333")
        
        //then
        XCTAssertNil(nilStream)
        XCTAssertEqual(validStream?.id, "333")
        XCTAssertEqual(validStream?.userId, "ccc")
        XCTAssertNotEqual(validStream?.language, "sp")
    }
    
    func testDataSourceGetStreamWithRow() {
        // given
        apiManager = MockGameStreamsAPI(streams: streams)
        dataSource = VideoPlaylistDataSource(apiManager: apiManager!, gameId: "")
        
        // where
        dataSource?.load { _ in }
        let nilStream = dataSource?.getStream(withRow: 4)
        let validStream = dataSource?.getStream(withRow: 0)
        
        //then
        XCTAssertNil(nilStream)
        XCTAssertEqual(validStream?.id, "111")
        XCTAssertEqual(validStream?.userId, "aaa")
        XCTAssertNotEqual(validStream?.language, "sp")
    }
}
