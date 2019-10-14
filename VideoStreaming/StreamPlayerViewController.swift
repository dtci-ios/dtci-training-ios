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
    @IBOutlet private weak var videoPlayerView: UIView!
    @IBOutlet private weak var descriptionView: UIView!
    @IBOutlet private weak var relatedVideosTableView: UITableView!
    
    private var playerViewController: AVPlayerViewController!
    private var player: AVPlayer!
    
    private var streamUrl: URL
    
    static var nibName: String {
        return String(describing: self)
    }
    
    init(streamingUrl url: URL) {
        streamUrl = url
        super.init(nibName: StreamPlayerViewController.nibName, bundle: nil)
        setupPlayerViewController()
    }
    
    required init?(coder: NSCoder) {
        streamUrl = URL(fileURLWithPath: "")
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        relatedVideosTableView.register(UINib(nibName: VideoTableViewCell.Constants.nibName, bundle: nil),
                           forCellReuseIdentifier: VideoTableViewCell.Constants.reuseIdentifier)
        relatedVideosTableView.refreshControl = UIRefreshControl()
        relatedVideosTableView.refreshControl?.tintColor = .white
    }
    
    override func viewWillLayoutSubviews() {
        videoPlayerView.addSubview(playerViewController.view)
        
        playerViewController.view.frame = videoPlayerView.bounds
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = videoPlayerView.bounds
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        videoPlayerView.layer.addSublayer(playerLayer)
        
        player = AVPlayer(url: streamUrl)
        playerViewController.player = player
        playerViewController.player?.play()
    }
    
    private func setupPlayerViewController() {
        playerViewController = AVPlayerViewController()
        addChild(playerViewController)
        playerViewController.didMove(toParent: self)
    }
}

extension StreamPlayerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = UIColor(named: "gray")
        return cell
    }
}
