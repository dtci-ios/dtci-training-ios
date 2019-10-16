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
    var streams = [VideoStreaming.Stream(id: "111", userId: "aaa", userName: "AAA", gameId: "g111", type: "",
                                         title: "ajgfei", viewerCount: 2, startedAt: "", language: "en", thumbnailUrl: "",
                                         tagIds: nil),
                   VideoStreaming.Stream(id: "222", userId: "bbb", userName: "BBB", gameId: "g222", type: "live",
                                         title: "lalala", viewerCount: 6, startedAt: "", language: "en", thumbnailUrl: "",
                                         tagIds: nil),
                   VideoStreaming.Stream(id: "333", userId: "ccc", userName: "CCC", gameId: "g333", type: "",
                                         title: "saraasas", viewerCount: 5, startedAt: "", language: "en", thumbnailUrl: "",
                                         tagIds: nil)]
    
    func fetchGameStreams(ofGame gameId: String, completion: @escaping (Result<[VideoStreaming.Stream], APIError>) -> Void) {
        completion(.success(streams))
    }
}

class VideoPlaylistDataSourceTests: XCTestCase {
    
    let apiManager = MockGameStreamsAPI()
    var dataSource: VideoPlaylistDataSource?
    var tableView: UITableView!

    override func setUp() {
        dataSource = VideoPlaylistDataSource(apiManager: apiManager, gameId: "")
        tableView = UITableView()
        
        tableView.dataSource = dataSource
        dataSource?.load { error in return }
        
        tableView.register(UINib(nibName: VideoTableViewCell.Constants.nibName, bundle: nil),
                           forCellReuseIdentifier: VideoTableViewCell.Constants.reuseIdentifier)
    }

    override func tearDown() {
        dataSource = nil
        tableView = nil
    }
    
    func testDataSourceNumberOfSections() {
        XCTAssertEqual(dataSource?.numberOfSections(in: tableView), 1)
    }

    func testDataSourceNumbreOfRows() {
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 3)
    }
    
    func testDataSourceTypeOfCell() {
        let i = Int.random(in: 0..<3)
        let cell = dataSource?.tableView(tableView, cellForRowAt: IndexPath(row: i, section: 0))

        XCTAssert(cell is VideoTableViewCell)
    }
    
    func testDataSourceCellContent() {
        let i = Int.random(in: 0..<3)
        let cell = dataSource?.tableView(tableView, cellForRowAt: IndexPath(row: i, section: 0)) as! VideoTableViewCell
        
        XCTAssertEqual(cell.videoId, apiManager.streams[i].id)
    }
    
    func testDataSourceClean() {
        XCTAssert((dataSource?.clean())!)
    }
    
    func testDataSourceContains() {
        XCTAssertEqual(dataSource?.containsStream(withId: "notValidId"), nil)
        XCTAssertEqual(dataSource?.containsStream(withId: "222"), 1)
    }
    
    func testDataSourceAdd() {
        let countBeforeAdd = dataSource?.getStreamCount()
        let countAfterAdd = dataSource?.add(stream: VideoStreaming.Stream(id: "444", userId: "ddd",
                                                                          userName: "DDD", gameId: "g444",
                                                                          type: "", title: "asdads",
                                                                          viewerCount: 7, startedAt: "",
                                                                          language: "sp", thumbnailUrl: "",
                                                                          tagIds: nil))
        
        XCTAssertEqual(countAfterAdd, countBeforeAdd! + 1)
        XCTAssertEqual(dataSource?.getStreamCount(), dataSource?.add(stream: nil))
    }
    
    func testDataSourceRemove() {
        let countBeforeRemove = dataSource?.getStreamCount()
        let countAfterRemove = dataSource?.removeStream(withId: "333")

        XCTAssertEqual(countAfterRemove, countBeforeRemove! - 1)
        XCTAssertEqual(dataSource?.getStreamCount(), dataSource?.removeStream(withId: "notValidId"))
    }
    
}
