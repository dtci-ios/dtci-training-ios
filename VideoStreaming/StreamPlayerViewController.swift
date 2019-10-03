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
    private var avPlayerLayer: AVPlayerLayer!
    
    private var streamUrl: URL?
    
    static var nibName: String {
        return String(describing: self)
    }
    
    init(streamingUrl url: URL?) {
        super.init(nibName: StreamPlayerViewController.nibName, bundle: nil)
        
        if let streamUrl = streamUrl {
            initializePlayer(streamUrl: streamUrl)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func play() {
        let playerViewController = AVPlayerViewController()
        playerViewController.player = avPlayer
        
        present(playerViewController, animated: true) { [weak self] in
            self?.avPlayer.play()
        }
    }
    
    private func initializePlayer(streamUrl: URL) {
        let videoAsset = AVURLAsset(url: streamUrl)
        let playerItem = AVPlayerItem(asset: videoAsset)
        avPlayer = AVPlayer(playerItem: playerItem)
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
    }
    
}

extension StreamPlayerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
}
