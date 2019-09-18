//
//  VideoView.swift
//  VideoStreaming
//
//  Created by Julian Llorensi on 17/09/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import UIKit

class VideoView: UIView {
    @IBOutlet private weak var videoImageView: UIImageView!
    @IBOutlet private weak var videoTitle: UILabel!
    @IBOutlet private weak var videoDurationAndDate: UILabel!
    
    init(frame: CGRect, video: Video) {
        super.init(frame: frame)
        configure(with: video)
        setUpImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with video: Video) {
        videoImageView.image = UIImage(named: video.imageName)
        videoTitle.text = video.title
        videoDurationAndDate.text = video.duration + "." + video.date.description(with: Locale.current)
    }
    
    private func setUpImageView() {
        videoImageView.layer.cornerRadius = 10
    }
}
