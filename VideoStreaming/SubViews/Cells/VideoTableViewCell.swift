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
    
    func configure(with video: Video) {
        videoView.configure(with: video)
    }
}
