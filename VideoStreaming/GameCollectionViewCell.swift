//
//  GameCollectionViewCell.swift
//  VideoStreaming
//
//  Created by Rodrigo Cian Berrios on 24/09/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import UIKit


class GameCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var gameImageView: UIImageView!
    
    enum Constants {
        static let nibName = "GameCollectionViewCell"
        static let reuseIdentifier = "gameCell"
        static let noImage = "noImage"
    }
    
    var game: Game? {
        didSet {
            if let game = game {
                if let image = UIImage(named: game.image) {
                    gameImageView.image = image
                } else {
                    gameImageView.image = UIImage(named: Constants.noImage)
                }
            }
        }
    }

    override func prepareForReuse() {
        gameImageView.image = UIImage(named: Constants.noImage)
    }
    
}
