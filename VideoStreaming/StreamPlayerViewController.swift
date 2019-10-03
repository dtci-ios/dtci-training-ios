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
    private var playerViewController: AVPlayerViewController!
    private var player: AVPlayer!
    
    private var streamUrl: URL = URL(fileURLWithPath: "")
    
    static var nibName: String {
        return String(describing: self)
    }
    
    init(streamingUrl url: URL) {
        super.init(nibName: StreamPlayerViewController.nibName, bundle: nil)
        
        streamUrl = url
        setupPlayerViewController()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func play() {
        player = AVPlayer(url: streamUrl)
        playerViewController.player = player
        playerViewController.player?.play()
    }
    
    private func setupPlayerViewController() {
        playerViewController = AVPlayerViewController()
        addChild(playerViewController)
        view.addSubview(playerViewController.view)
        playerViewController.view.frame = view.bounds
        playerViewController.didMove(toParent: self)
    }
}

