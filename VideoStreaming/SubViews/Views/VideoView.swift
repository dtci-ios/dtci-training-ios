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
        setViewInfoWith(videoModel)
        setUpImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setViewInfoWith(_ video: Video) {
        videoImageView.image = video.image
        videoTitle.text = video.title
        videoDurationAndDate.text = video.duration + "." + video.date.description(with: Locale.current)
    }
    
    private func setUpImageView() {
        videoImageView.layer.cornerRadius = 15
        videoImageView.layer.shadowOffset = CGSize(width: videoImageView.frame.width,
                                                   height: videoImageView.frame.height)
        videoImageView.layer.shadowColor = UIColor.black.cgColor
        videoImageView.layer.opacity = 5
        videoImageView.layer.shadowRadius = -10
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}
