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

    // mock data
    private var mockGames = [Game(image: "apex"),
                             Game(image: "civilization"),
                             Game(image: "doom"),
                             Game(image: "grandTheftAuto"),
                             Game(image: "minicraft"),
                             Game(image: "rdrII"),
                             Game(image: "skyrim"),
                             Game(image: "spiderman"),
                             Game(image: "stardew-valley"),
                             Game(image: "super-mario-boxart-2"),
                             Game(image: "tetris"),
                             Game(image: "wow"),
                             Game(image: "zelda")]
    
    var games : [Game?] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        games.append(contentsOf: Array(mockGames))

        collectionView.register(UINib(nibName: GameCollectionViewCell.Constants.nibName, bundle: nil), forCellWithReuseIdentifier: GameCollectionViewCell.Constants.reuseIdentifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self

    }
}

extension TopGamesCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        //flowayout?.minimumLineSpacing = 20
        //flowayout?.minimumInteritemSpacing = 25
        flowayout?.itemSize = CGSize(width: 100, height: 100)
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (collectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height: 250)
    }

}
