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
    @IBOutlet private weak var descriptionView: UIView!
    @IBOutlet private weak var tableView: UITableView!
    
    private var avPlayer: AVPlayer?
    
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
    
    func play() {
        let playerViewController = AVPlayerViewController()
        
        if let url = streamingUrl {
            avPlayer = AVPlayer(url: url)
            playerViewController.player = avPlayer
        }
        
        present(playerViewController, animated: true) {
            playerViewController.player?.play()
        }
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
