//
//  VideoTableViewCell.swift
//  VideoStreaming
//
//  Created by Natalia Brasesco on 18/09/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import UIKit


class VideoTableViewCell: UITableViewCell {

    enum Constants {
        static let nibName = "VideoTableViewCell"
        static let reuseIdentifier = "videoCell"
        static let placeholderImg = "Placeholder"
    }
    
    @IBOutlet private weak var vidImage: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    
    var video: Video? {
        didSet {
            if let video = video {
                if let image = UIImage(named: video.image) {
                    vidImage.image = image
                } else {
                    vidImage.image = UIImage(named: Constants.placeholderImg)
                }
                titleLabel.text = video.title
                durationLabel.text = video.duration
            }
        }
    }

    override func prepareForReuse() {
        vidImage.image = UIImage(named: Constants.placeholderImg)
        titleLabel.text = "-"
        durationLabel.text = "--:--:--"
    }
    
}
