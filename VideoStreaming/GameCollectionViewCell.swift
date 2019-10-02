//
//  GameCollectionViewCell.swift
//  VideoStreaming
//
//  Created by Rodrigo Cian Berrios on 24/09/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import UIKit
import SDWebImage

class GameCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var gameImageView: UIImageView!
    
    enum Constants {
        static let nibName = String(describing: GameCollectionViewCell.self)
        static let reuseIdentifier = String(describing: GameCollectionViewCell.self)
        static let noImage = "noImage"
    }
    
    var game: Game? {
        didSet {
            if let game = game {
                gameImageView.sd_setImage(with: URL(string: game.boxArtThumbnailUrl()),
                                          placeholderImage: UIImage(named: Constants.noImage))
            } else {
                gameImageView.image = UIImage(named: Constants.noImage)
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gameImageView.layer.cornerRadius = 10
    }
    
    override func prepareForReuse() {
        game = nil
    }

}
