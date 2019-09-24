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
    @IBOutlet private weak var videoStack: UIStackView!
    @IBOutlet private weak var videoTitle: UILabel!
    @IBOutlet private weak var videoDurationAndDate: UILabel!
    
    private let nibName = String(describing: VideoView.self)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }
    
    func configure(with video: Video) {
        videoImageView.image = UIImage(named: video.imageName)
        videoTitle.text = video.title
        videoDurationAndDate.text = video.durationAndDate
        videoImageView.translatesAutoresizingMaskIntoConstraints = true
        videoStack.translatesAutoresizingMaskIntoConstraints = true
        videoImageView.layer.masksToBounds = true
        videoImageView.layer.cornerRadius = 10
    }
    
    func reset() {
        videoImageView.image = nil
        videoTitle.text = nil
        videoDurationAndDate.text = nil
    }

    private func nibSetup() {
        guard let view = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?.first as? UIView else {
            return
        }
        
        addSubview(view)
    }
}
