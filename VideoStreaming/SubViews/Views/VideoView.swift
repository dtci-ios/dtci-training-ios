//
//  VideoView.swift
//  VideoStreaming
//
//  Created by Julian Llorensi on 17/09/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import UIKit
import SDWebImage
 
class VideoView: UIView, NibLoadable {
    @IBOutlet private weak var videoImageView: UIImageView!
    @IBOutlet private weak var videoStack: UIStackView!
    @IBOutlet private weak var videoTitle: UILabel!
    @IBOutlet private weak var videoDurationAndDate: UILabel!
    @IBOutlet private weak var liveLabel: UILabel!
    
    private enum Constants {
        static let nibName = String(describing: VideoView.self)
        static let placeholderImageName = "noImage"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }
    
    func configure(with stream: Stream) {
        videoImageView.sd_setImage(with: stream.imageURL, placeholderImage: UIImage(named: Constants.placeholderImageName), options: .continueInBackground, context: nil)
        videoDurationAndDate.text = stream.durationAndDate
        if stream.type == "live" { liveLabel.isHidden = false }
        videoTitle.text = stream.title
        videoTitle.numberOfLines = 2
        videoTitle.translatesAutoresizingMaskIntoConstraints = false
        videoStack.alignment = .leading
        videoStack.translatesAutoresizingMaskIntoConstraints = false
        videoImageView.translatesAutoresizingMaskIntoConstraints = true
        videoImageView.layer.masksToBounds = true
        videoImageView.layer.cornerRadius = 10
    }
    
    func configure(with video: Video) {
        videoImageView.sd_setImage(with: video.imageUrl, placeholderImage: UIImage(named: Constants.placeholderImageName), options: .continueInBackground, context: nil)
        videoDurationAndDate.text = video.durationAndDate
        if video.type == "live" { liveLabel.isHidden = false }
        videoTitle.text = video.title
        videoTitle.numberOfLines = 2
        videoTitle.translatesAutoresizingMaskIntoConstraints = false
        videoStack.alignment = .leading
        videoStack.translatesAutoresizingMaskIntoConstraints = false
        videoImageView.translatesAutoresizingMaskIntoConstraints = true
        videoImageView.layer.masksToBounds = true
        videoImageView.layer.cornerRadius = 10
    }
    
    func reset() {
        videoImageView.image = UIImage(named: Constants.placeholderImageName)
        videoTitle.text = nil
        videoDurationAndDate.text = nil
        liveLabel.isHidden = true
    }
    
}
