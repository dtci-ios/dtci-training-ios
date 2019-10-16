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
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var relatedVideosTableView: UITableView!
    
    private var playerViewController: AVPlayerViewController!
    private var player: AVPlayer!
    private var videosAPI = VideosAPI() 
    private var streamUrl: URL
    private var userId: String
    private var titleText: String
    private var relatedVideos: [Video] = [Video]()

    static var nibName: String {
        return String(describing: self)
    }
    
    init(streamingUrl url: URL, userId id: String, title: String?) {
        streamUrl = url
        userId = id
        titleText = title ?? ""
        super.init(nibName: StreamPlayerViewController.nibName, bundle: nil)
        
        videosAPI.fetchVideoList(byUserId: userId) { [weak self] (result) in
            switch result {
            case .success(let relatedVideos):
                self?.relatedVideos = relatedVideos
                self?.relatedVideosTableView.reloadData()
            case .failure(let error):
                let alert = UIAlertController(title: "ERROR", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true)
            }
        }
        
        setupPlayerViewController()
    }
    
    required init?(coder: NSCoder) {
        streamUrl = URL(fileURLWithPath: "")
        userId = ""
        titleText = ""
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        relatedVideosTableView.register(UINib(nibName: VideoTableViewCell.Constants.nibName, bundle: nil),
                           forCellReuseIdentifier: VideoTableViewCell.Constants.reuseIdentifier)
        relatedVideosTableView.refreshControl = UIRefreshControl()
        relatedVideosTableView.refreshControl?.tintColor = .white
        
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.text = titleText
        
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if UIDevice.current.orientation == .landscapeRight || UIDevice.current.orientation == .landscapeLeft {
            videoPlayerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            videoPlayerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            videoPlayerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            videoPlayerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        } else {
            videoPlayerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = false
            videoPlayerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = false
            videoPlayerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = false
            videoPlayerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = false
        }
    }
    
    private func setupPlayerViewController() {
        playerViewController = AVPlayerViewController()
        addChild(playerViewController)
        playerViewController.didMove(toParent: self)
    }
}

extension StreamPlayerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return relatedVideos.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell") as? VideoTableViewCell else {
            return UITableViewCell()
        }
    
        cell.configure(with: relatedVideos[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let videoId = relatedVideos[indexPath.row].id
        
        let pwnServiceAPI = PwnServiceAPI(with: videoId)
        
        pwnServiceAPI?.fetchStreamingM3U8Urls { [weak self] (result) in
            switch result {
            case .success(let urls):
                let alert = UIAlertController(title: "Choose the streaming quality", message: nil, preferredStyle: .actionSheet)
                    
                for key in urls.keys.sorted(by: { $0.localizedStandardCompare($1) == .orderedAscending }) {
                    alert.addAction(UIAlertAction(title: key, style: .default, handler: { (action) in
                        if let stringURL = urls[key], let m3u8URL = URL(string: stringURL) {
                            self?.player = AVPlayer(url: m3u8URL)
                            self?.playerViewController.player = self?.player
                            self?.playerViewController.player?.play()
                            self?.descriptionLabel.text = self?.relatedVideos[indexPath.row].title
                        }
                    }))
                }
                    
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                               
                self?.present(alert, animated: true)
                    
            case .failure(let error):
                let alert = UIAlertController(title: "ERROR", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true)
            }
        }
    }
}

extension StreamPlayerViewController {
    private func reloadVideoPlayerConstraints(isActivate: Bool) {
        videoPlayerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = isActivate
        videoPlayerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = isActivate
        videoPlayerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = isActivate
        videoPlayerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = isActivate
    }
}
