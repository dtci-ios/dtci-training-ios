//
//  StreamPlayerViewController.swift
//  VideoStreaming
//
//  Created by Julian Llorensi on 30/09/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class StreamPlayerViewController: UIViewController {
    private var avPlayer: AVPlayer!
    
    private var streamUrl: URL?
    
    static var nibName: String {
        return String(describing: self)
    }
    
    init(streamingUrl url: URL) {
        super.init(nibName: StreamPlayerViewController.nibName, bundle: nil)
        streamUrl = url
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func play() {
        let playerViewController = AVPlayerViewController()
        
        if let url = streamUrl {
            avPlayer = AVPlayer(url: url)
            playerViewController.player = avPlayer
            
            present(playerViewController, animated: true) {
                playerViewController.player?.play()
            }
        }
    }
}

