//
//  VideoTableViewCell.swift
//  VideoStreaming
//
//  Created by Julian Llorensi on 18/09/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import UIKit

@IBDesignable class VideoTableViewCell: UITableViewCell {
    @IBOutlet private weak var videoView: VideoView!
    
    enum Constants {
        static let nibName = "VideoTableViewCell"
        static let reuseIdentifier = "videoCell"
        static let placeholderImg = "Placeholder"
    }
    
    func configure(with stream: Stream) {
        videoView.configure(with: stream)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isSelected = false 
        videoView.reset()
    }
}
