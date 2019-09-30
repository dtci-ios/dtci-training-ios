//
//  StreamPlayerViewController.swift
//  VideoStreaming
//
//  Created by Julian Llorensi on 30/09/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import UIKit
import AVKit

class StreamPlayerViewController: UIViewController {
    private var streamingUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func set(streamingUrl url: String?) {
        streamingUrl = url
    }
    
    func play() {
        let playerViewController = AVPlayerViewController()
        
        if let url = streamingUrl {
            playerViewController.player = AVPlayer(url: URL(fileURLWithPath: url))
        }
        
        present(playerViewController, animated: true) {
            playerViewController.player?.play()
        }
    }
}
