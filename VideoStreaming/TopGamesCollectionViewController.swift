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

class TopGamesDataSource: NSObject {

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

class TopGamesCollectionViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!

    private var columsLayout = ColumsLayout(itemsWidthPercentage: 0.88, cellAspectRatio: CellAspectRatio(width: 3, height: 4))
    private var dataSource: TopGamesDataSource!

    static var nibName: String {
        return String(describing: self)
    }

    init(dataSource: TopGamesDataSource) {
        self.dataSource = dataSource
        super.init(nibName: TopGamesCollectionViewController.nibName, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Top Games"

        showHUD()

        collectionView.register(UINib(nibName: GameCollectionViewCell.Constants.nibName, bundle: nil), forCellWithReuseIdentifier: GameCollectionViewCell.Constants.reuseIdentifier)

        dataSource.fetchDataSource(completionForView: errorCompletionHandler(error:))

        collectionView.delegate = self
        collectionView.dataSource = self
    }

    func errorCompletionHandler(error: APIError?) {
        dismissHUD()
        if let error = error {
            let alert = UIAlertController(title: "ERROR", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
        } else {
            collectionView.reloadData()
            dismissHUD()
        }
    }
}

extension TopGamesCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = self.collectionView(collectionView, cellForItemAt: indexPath) as! GameCollectionViewCell

        guard let game = cell.game else { return }

        let videoPlaylistVC = VideoPlaylistViewController(with: game)

        navigationController?.pushViewController(videoPlaylistVC, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.getGames().count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewCell = collectionView.dequeueReusableCell(withReuseIdentifier: GameCollectionViewCell.Constants.reuseIdentifier, for: indexPath) as? GameCollectionViewCell else {
            return UICollectionViewCell()
        }

        viewCell.game = self.dataSource.getGames()[indexPath.row]

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
