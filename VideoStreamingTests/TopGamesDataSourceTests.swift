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
    
    var collectionView: UICollectionView!
    let layout = UICollectionViewFlowLayout()
    var gamesMock: [Game]!
    var fetchDataResultOfCompletionMock: Swift.Result<[Game],APIError>!
    
    override func setUp() {
        gamesMock = [Game(id: "123", name: "456", boxArtUrl: "www.Aanypic.com"),
                     Game(id: "789", name: "012", boxArtUrl: "www.Banypic.com"),
                     Game(id: "345", name: "678", boxArtUrl: "www.Canypic.com")]
        
        fetchDataResultOfCompletionMock = .success(gamesMock)
        
        collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: layout)

        collectionView.register(UINib(nibName: GameCollectionViewCell.Constants.nibName, bundle: nil), forCellWithReuseIdentifier: GameCollectionViewCell.Constants.reuseIdentifier)
        
        sut = TopGamesDataSource(topGamesAPI: TopGamesAPIMock(fetchDataResultOfCompletionMock))

        collectionView.dataSource = sut
        
        sut.fetchDataSource{ error in return }        
    }
    
    override func tearDown() {
        gamesMock = nil
        fetchDataResultOfCompletionMock = nil
        collectionView = nil
        sut = nil
    }

    //testear que no sea nil luego de crear
    func testTopGamesDataSourceNotNil() {
        XCTAssertNotNil(sut)
    }

    //numberOfItemsInSection(compara cantidad de elementos con contidad de games de la api)
    func testNumberOfItemsInSection() {
        XCTAssertEqual(sut.collectionView(collectionView, numberOfItemsInSection: 0), gamesMock.count)
    }
    
    //cellForItemAt(comoparar tipo de la celda que retorna, compara .game de la celda con game de la API)
    func testcellForItemAtCellType() {
        let cell = sut.collectionView(collectionView, cellForItemAt: IndexPath(item: 0, section: 0))
        XCTAssert(cell is GameCollectionViewCell)
    }
 
    func testcellForItemAtCellItemGame() {
        let firstCell = sut.collectionView(collectionView, cellForItemAt: IndexPath(item: 0, section: 0)) as! GameCollectionViewCell
        XCTAssertEqual(firstCell.game, gamesMock.first)
        let lastCell = sut.collectionView(collectionView, cellForItemAt: IndexPath(item: gamesMock.count - 1 , section: 0)) as! GameCollectionViewCell
        XCTAssertEqual(lastCell.game, gamesMock.last)
    }
    
    //analizar fetchDataSource (tipos de retorno, .failure .success)
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
