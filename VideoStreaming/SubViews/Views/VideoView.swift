//
//  VideoView.swift
//  VideoStreaming
//
//  Created by Julian Llorensi on 17/09/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import UIKit

class VideoView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet private weak var videoImageView: UIImageView!
    @IBOutlet private weak var videoTitle: UILabel!
    @IBOutlet private weak var videoDurationAndDate: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(with video: Video) {
        nibSetup()
        videoImageView?.image = UIImage(named: video.imageName)
        videoTitle?.text = video.title
        videoDurationAndDate?.text = video.duration + "." + video.date.description(with: Locale.current)
        videoImageView?.layer.cornerRadius = 10
    }
    
    private func nibSetup() {
        Bundle.main.loadNibNamed(String(describing: VideoView.self), owner: self, options: nil)
        guard let contentView = contentView else { return }
        self.addSubview(contentView)
    }
}
