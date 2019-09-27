//
//  TopGamesCollectionViewController.swift
//  VideoStreaming
//
//  Created by Rodrigo Cian Berrios on 24/09/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import UIKit

class TopGamesCollectionViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!

    var games : [Game?] = []

    let columsLayout = ColumsLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        TopGamesAPI().fetchTopGames { (retrievedTopGames) in
            if let unRetrivedTopGames = retrievedTopGames?.compactMap({ $0 }) {
                self.games.append(contentsOf: unRetrivedTopGames)
            }
            self.collectionView.reloadData()
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
        
        let itemWidth = (collectionView.frame.size.width - CGFloat(columsLayout.columns + 1) * columsLayout.padding) / CGFloat(columsLayout.columns)
        
        return CGSize(width: itemWidth, height: itemWidth * columsLayout.cellAspectRatio.heightRatioFactor)
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

struct ColumsLayout {
    let columns: Int = 2
    let padding: CGFloat = 20
    let cellAspectRatio = CellAspectRatio(width: 3, height: 4)
}

struct CellAspectRatio {
    // Portrait mode => 4:3 is 4 heigth and 3 width
    var width: Float
    var height: Float
    
    var heightRatioFactor: CGFloat {
        return CGFloat(height / width)
    }
    
    var widthRatioFactor: CGFloat {
        return CGFloat(width / height)
    }
}
