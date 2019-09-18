//
//  VideoTableViewCell.swift
//  VideoStreaming
//
//  Created by Natalia Brasesco on 18/09/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import UIKit

class VideoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var vidImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    var video: Video? {
        didSet {
            if let video = video {
                if let image = UIImage(named: video.image) {
                    vidImage.image = image
                } else {
                    vidImage.image = UIImage(named: "Placeholder")
                }
                titleLabel.text = video.title
                durationLabel.text = video.duration
            }
        }
    }

    override func prepareForReuse() {
        vidImage.image = UIImage(named: "Placeholder")
        titleLabel.text = "-"
        durationLabel.text = "--:--:--"
    }
    
}
