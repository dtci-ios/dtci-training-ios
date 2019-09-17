//
//  VideoView.swift
//  VideoStreaming
//
//  Created by Julian Llorensi on 17/09/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import UIKit

class VideoView: UIView {
    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var videoTitle: UILabel!
    @IBOutlet weak var videoDurationAndDate: UILabel!
    
    init(frame: CGRect, videoModel: Video) {
        super.init(frame: frame)
        videoImageView.image = videoModel.image
        videoTitle.text = videoModel.title
        videoDurationAndDate.text = videoModel.duration + "." + videoModel.date.description(with: Locale.current)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}
