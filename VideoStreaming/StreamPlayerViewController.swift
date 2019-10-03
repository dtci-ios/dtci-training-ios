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
    @IBOutlet private weak var playerView: UIView!
    @IBOutlet private weak var descriptionView: UIView!
    @IBOutlet private weak var tableView: UITableView!
    
    private var avPlayer: AVPlayer!
    private var avPlayerLayer: AVPlayerLayer!
    
    private var streamingUrl: URL?
    
    static var nibName: String {
        return String(describing: self)
    }
    
    init(streamingUrl url: URL?) {
        super.init(nibName: StreamPlayerViewController.nibName, bundle: nil)
        streamingUrl = url
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    override func viewDidLoad() {
        
        if let streamingUrl = streamingUrl {
            avPlayer = AVPlayer(url: streamingUrl)
            
            avPlayerLayer = AVPlayerLayer(player: avPlayer)
            avPlayerLayer.videoGravity = .resize
            
            playerView.layer.addSublayer(avPlayerLayer)
            
            // playerViewController.player = avPlayer
            avPlayer.play()
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        avPlayerLayer.frame = playerView.bounds
    }
    
    func play() {
        /*
        let _ = AVPlayerViewController()
        
        if let url = streamingUrl {            
            avPlayer = AVPlayer(url: url)
            
            avPlayerLayer = AVPlayerLayer(player: avPlayer)
            avPlayerLayer.videoGravity = .resize
            
            playerView.layer.addSublayer(avPlayerLayer)
            
            // playerViewController.player = avPlayer
            avPlayer.play()
        }
        */
        
        /*
        present(playerViewController, animated: true) { [weak self] in
            self?.avPlayer.play()
        }
        */
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
