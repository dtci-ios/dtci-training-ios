//
//  PlayerViewController.swift
//  VideoStreaming
//
//  Created by Julian Llorensi on 27/09/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import UIKit
import AVKit

class PlayerViewController: UIViewController {
    @IBOutlet weak var player: AVPlayer
    private weak var playerViewControllerPresenter: PlayerViewControllerPresenter?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func set(videoToPlay video: Video, completion: @escaping () -> Void) {
        playerViewControllerPresenter?.set(withViewController: self, andVideo: video)
        completion()
    }
    
    func playVideo() {
    
    }
}
