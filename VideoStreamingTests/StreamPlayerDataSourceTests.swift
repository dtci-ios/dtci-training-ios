//
//  StreamPlayerDataSourceTests.swift
//  VideoStreamingTests
//
//  Created by Julian Llorensi on 23/10/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import XCTest
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

class StreamPlayerDataSourceTests: XCTestCase {
    private var apiManager: MockVideosAPI!
    private var dataSource: StreamPlayerDataSource!
    private var videos = [
        Video(id: "0129", userId: "7193", userName: "Someone", title: "Any Idea", description: "empty", duration: "2m33s",             publishedAt: "", url: "", thumbnailUrl: "", type: "", viewCount: 81),
        Video(id: "7723", userId: "5162", userName: "Anyone", title: "A better title", description: "put something eloquent here", duration: "7m15s", publishedAt: "", url: "", thumbnailUrl: "", type: "", viewCount: 15),
        Video(id: "1627", userId: "3711", userName: "The X Guy", title: "Inspiration", description: "...", duration: "15m45s", publishedAt: "", url: "", thumbnailUrl: "", type: "", viewCount: 142)
    ]

    func testDataSourceDidLoad() {
        // given
        apiManager = MockVideosAPI(fetchedResult: .success(videos))
        
        dataSource = StreamPlayerDataSource(apiManager: apiManager, url: URL(string: "https://dummy.com")!,
                                            videoTitle: "", userId: "")
        
        // when
        let expectation = self.expectation(description: "Loading Data")
        var completionError: APIError?
        
        dataSource?.loadData { error in
            completionError = error
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        // then
        XCTAssertEqual(dataSource?.relatedVideosCount, videos.count)
        XCTAssertNil(completionError)
    }
    
    func testDataSourceVideoTitle() {
        // given
        apiManager = MockVideosAPI(fetchedResult: .success(videos))
        
        dataSource = StreamPlayerDataSource(apiManager: apiManager, url: URL(string: "https://dummy.com")!,
                                            videoTitle: "Streaming Title", userId: "")
        
        // when
        let expectation = self.expectation(description: "Loading Data")
        
        dataSource?.loadData { _ in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        // then
        XCTAssertEqual(dataSource.videoTitle, "Streaming Title")
    }
    
    func testDataSourceDidNotLoadNilDataError() {
        // given
        apiManager = MockVideosAPI(fetchedResult: .failure(.responseDataNil))
                
        dataSource = StreamPlayerDataSource(apiManager: apiManager, url: URL(string: "https://dummy.com")!,
                                            videoTitle: "", userId: nil)
        
        // when
        let expectation = self.expectation(description: "Loading Data")
        var completionError: APIError?
        
        dataSource?.loadData { error in
            completionError = error
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        // then
        XCTAssertNotEqual(dataSource.relatedVideosCount, videos.count)
        XCTAssertNotNil(completionError)
        XCTAssert(completionError == APIError.responseDataNil)
        XCTAssert(completionError != APIError.emptyDataArray)
    }
    
    func testDataSourceContains() {
        // given
        apiManager = MockVideosAPI(fetchedResult: .success(videos))
        
        dataSource = StreamPlayerDataSource(apiManager: apiManager, url: URL(string: "https://dummy.com")!,
                                            videoTitle: "", userId: "")
        
        // when
        let expectation = self.expectation(description: "Loading Data")
        
        dataSource?.loadData { _ in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        // then
        guard let result = dataSource?.containsVideo(withId: "0129") else { return }
        
        XCTAssert(result)
    }

    func testDataSourceClean() {
        // given
        apiManager = MockVideosAPI(fetchedResult: .success(videos))
        
        dataSource = StreamPlayerDataSource(apiManager: apiManager, url: URL(string: "https://dummy.com")!,
                                            videoTitle: "", userId: "")
        
        // when
        let expectation = self.expectation(description: "Loading Data")
        
        dataSource?.loadData { _ in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        guard let isEmpty = dataSource?.release() else { return XCTFail() }
        
        // then
        XCTAssert(isEmpty)
        XCTAssertEqual(dataSource?.relatedVideosCount, 0)
    }
    
    func testDataSourceGetStreamWithRow() {
        // given
        apiManager = MockVideosAPI(fetchedResult: .success(videos))
        
        dataSource = StreamPlayerDataSource(apiManager: apiManager, url: URL(string: "https://dummy.com")!,
                                            videoTitle: "", userId: "")
        
        // when
        let expectation = self.expectation(description: "Loading Data")
        
        dataSource?.loadData { _ in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        let nilStream = dataSource?.getVideo(at: 3)
        let validStream = dataSource?.getVideo(at: 0)
        
        //then
        XCTAssertNil(nilStream)
        XCTAssertEqual(validStream?.id, "0129")
        XCTAssertEqual(validStream?.userId, "7193")
        XCTAssertNotEqual(validStream?.duration, "1m14s")
        XCTAssertNotEqual(validStream?.description, "some description")
    }
}
