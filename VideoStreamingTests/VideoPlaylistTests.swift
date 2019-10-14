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
    let streams: [VideoStreaming.Stream] = [VideoStreaming.Stream(id: "111", userId: "aaa", userName: "AAA", gameId: "g111",
                                                                  type: "", title: "ajgfei", viewerCount: 2, startedAt: "",
                                                                  language: "en", thumbnailUrl: "", tagIds: nil),
                                            VideoStreaming.Stream(id: "222", userId: "bbb", userName: "BBB", gameId: "g222",
                                                                  type: "live", title: "lalala", viewerCount: 6, startedAt: "",
                                                                  language: "en", thumbnailUrl: "", tagIds: nil),
                                            VideoStreaming.Stream(id: "333", userId: "ccc", userName: "CCC", gameId: "g333",
                                                                  type: "", title: "saraasas", viewerCount: 5, startedAt: "",
                                                                  language: "en", thumbnailUrl: "", tagIds: nil)]
    
    func fetchGameStreams(ofGame gameId: String, completion: @escaping (Result<[VideoStreaming.Stream], APIError>) -> Void) {
        completion(.success(streams))
    }
}

class VideoPlaylistTests: XCTestCase {
    
    var dataSource: VideoPlaylistDataSource?
    var tableView: UITableView!

    override func setUp() {
        dataSource = VideoPlaylistDataSource(apiManager: MockGameStreamsAPI(), gameId: "")
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
        XCTAssertEqual(dataSource?.tableView(tableView, numberOfRowsInSection: 0), 3)
    }
    
    func testDataSourceCellForRowAt() {
        let cell = dataSource?.tableView(tableView, cellForRowAt: IndexPath(row: 1, section: 0))

        XCTAssert(cell is VideoTableViewCell)
        
        let videoCell = cell as! VideoTableViewCell
        let stream = videoCell.getVideoView().getStream()
        
        XCTAssertEqual(stream.id, "222")
        XCTAssertEqual(stream.type, "live")
    }

}
