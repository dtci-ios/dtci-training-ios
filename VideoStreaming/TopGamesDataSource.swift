//
//  TopGamesDataSource.swift
//  VideoStreaming
//
//  Created by Rodrigo Cian Berrios on 14/10/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import UIKit

class TopGamesDataSource: NSObject, UICollectionViewDataSource {

    private var topGamesAPI: TopGamesAPIProtocol
    private var games: [Game] = []

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
    
    //UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewCell = collectionView.dequeueReusableCell(withReuseIdentifier: GameCollectionViewCell.Constants.reuseIdentifier, for: indexPath) as? GameCollectionViewCell else {
            return UICollectionViewCell()
        }

        viewCell.game = games[indexPath.row]

        return viewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? games.count : 0
    }
}

