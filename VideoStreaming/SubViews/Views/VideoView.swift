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
    
    init(frame: CGRect, video: Video) {
        super.init(frame: frame)
        setViewInfoWith(video)
        setUpImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func resetViewInfoWith(_ video: Video) {
        videoImageView.image = UIImage(named: video.imageName)
        videoTitle.text = video.title
        videoDurationAndDate.text = video.duration + "." + video.date.description(with: Locale.current)
    }
    
    private func setViewInfoWith(_ video: Video) {
        videoImageView.image = UIImage(named: video.imageName)
        videoTitle.text = video.title
        videoDurationAndDate.text = video.duration + "." + video.date.description(with: Locale.current)
    }
    
    private func setUpImageView() {
        videoImageView.layer.cornerRadius = 10
    }
}
