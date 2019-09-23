//
//  GameTableViewCell.swift
//  VideoStreaming
//
//  Created by Natalia Brasesco on 23/09/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import UIKit

class GameTableViewCell: UITableViewCell {

    @IBOutlet private weak var gameLabel: UILabel!
    @IBOutlet private weak var idLabel: UILabel!
    
    var game: Game? {
        didSet {
            gameLabel.text = game?.name
            idLabel.text = "ID: \(String(game?.id ?? ""))"
        }
    }
    
    override func prepareForReuse() {
        gameLabel.text = "---"
        idLabel.text = "ID: "
    }

}
