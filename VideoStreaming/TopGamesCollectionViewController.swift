//
//  TopGamesCollectionViewController.swift
//  VideoStreaming
//
//  Created by Rodrigo Cian Berrios on 24/09/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import UIKit

struct ColumsLayout {
    let columns: Int = 2
    let padding: CGFloat = 20
    let cellAspectRatio = CellAspectRatio()
    
    func cellSize(frameWidth: CGFloat) -> CGSize {
        let itemWidth = (frameWidth - CGFloat(columns + 1) * padding) / CGFloat(columns)
        return CGSize(width: itemWidth, height: itemWidth * CGFloat(cellAspectRatio.heightRatioFactor))
        
    }
    
}

struct CellAspectRatio {
    // Portrait mode => 4:3 is 4 heigth and 3 width
    var width: Int
    var height: Int
    
    init(width: Int = 3, height: Int = 4) {
        self.width = width
        self.height = height
    }
        
    var heightRatioFactor: Float {
        return Float(height) / Float(width)
        
    }
    
    var widthRatioFactor: Float {
        return Float(width) / Float(height)
        
    }
    
}

class TopGamesCollectionViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!

    var games : [Game?] = []

    let columsLayout = ColumsLayout()
    
    private var topGamesAPI : TopGamesAPIProtocol?
    
    static var nibName: String {
        return String(describing: TopGamesCollectionViewController.self)

    }
    
    init(topGamesAPI: TopGamesAPIProtocol) {
        super.init(nibName: TopGamesCollectionViewController.nibName, bundle: nil)
        self.topGamesAPI = topGamesAPI

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showHUD()

        topGamesAPI?.fetchTopGames { (retrievedTopGames) in
            self.games = retrievedTopGames ?? []
            self.collectionView.reloadData()
            self.dismissHUD(isAnimated: true)
        }
        
        collectionView.register(UINib(nibName: GameCollectionViewCell.Constants.nibName, bundle: nil), forCellWithReuseIdentifier: GameCollectionViewCell.Constants.reuseIdentifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
}

extension TopGamesCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return games.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let viewCell = collectionView.dequeueReusableCell(withReuseIdentifier: GameCollectionViewCell.Constants.reuseIdentifier, for: indexPath) as? GameCollectionViewCell else {
            return UICollectionViewCell()
            
        }
        viewCell.game = games[indexPath.row]
        return viewCell
        
    }
    
}

extension TopGamesCollectionViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return columsLayout.cellSize(frameWidth: collectionView.frame.size.width)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: columsLayout.padding, left: columsLayout.padding, bottom: columsLayout.padding, right: columsLayout.padding)
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return columsLayout.padding
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return columsLayout.padding
        
    }
}
