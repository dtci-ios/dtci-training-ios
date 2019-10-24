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
    private var landscapeVideoView: UIView!
    private var videosAPI = VideosAPI() 
    private var url: URL
    private var userId: String
    private var titleText: String
    private var relatedVideos: [Video] = [Video]()

    static var nibName: String {
        return String(describing: self)
    }
    
    init(with url: URL, title: String, andRelatedVideosFor userId: String) {
        self.url = url
        self.userId = userId
        titleText = title
        super.init(nibName: StreamPlayerViewController.nibName, bundle: nil)
        
        videosAPI.fetchVideoList(byUserId: userId) { [weak self] (result) in
            switch result {
            case .success(let relatedVideos):
                self?.relatedVideos = relatedVideos
                self?.relatedVideosTableView.reloadData()
            case .failure(let error):
                self?.popUpAlert(for: error)
            }
        }
        
        setupPlayerViewController()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        relatedVideosTableView.register(UINib(nibName: VideoTableViewCell.Constants.nibName, bundle: nil),
                           forCellReuseIdentifier: VideoTableViewCell.Constants.reuseIdentifier)
        
        relatedVideosTableView.backgroundColor = .black
        
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.text = titleText
        
        videoPlayerView.addSubview(playerViewController.view)
        
        playerViewController.view.frame = videoPlayerView.bounds
        
        player = AVPlayer(url: url)
        playerViewController.player = player
        playerViewController.player?.play()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        if landscapeVideoView == nil {
            landscapeVideoView  = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.height, height: view.frame.width))
            view.addSubview(landscapeVideoView)
            playerViewController.view.frame = landscapeVideoView.bounds
            landscapeVideoView.addSubview(playerViewController.view)
        } else {
            playerViewController.view.removeFromSuperview()
            landscapeVideoView.removeFromSuperview()
            videoPlayerView.addSubview(playerViewController.view)
            playerViewController.view.frame = videoPlayerView.bounds
            landscapeVideoView = nil
        }
    }
    
    private func setupPlayerViewController() {
        playerViewController = AVPlayerViewController()
        addChild(playerViewController)
        playerViewController.didMove(toParent: self)
    }
    
    private func playRelatedVideo(with videoURL: String?, newTitle: String) {
        if let url = videoURL, let m3u8URL = URL(string: url) {
            player = AVPlayer(url: m3u8URL)
            playerViewController.player = player
            playerViewController.player?.play()
            descriptionLabel.text = newTitle
        }
    }
    
    private func setCell(with urls: PwnResponse.QualityUrls, andTitle title: String) {
        let alert = UIAlertController(title: "Choose the streaming quality", message: nil, preferredStyle: .actionSheet)
            
        for key in urls.keys.sorted(by: { $0.localizedStandardCompare($1) == .orderedAscending }) {
            alert.addAction(UIAlertAction(title: key, style: .default, handler: { (action) in
                self.playRelatedVideo(with: urls[key], newTitle: title)
            }))
        }
            
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                       
        present(alert, animated: true)
    }
    
    private func popUpAlert(for error: APIError) {
        let alert = UIAlertController(title: "ERROR", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
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
        
        showHUD()
        
        pwnServiceAPI?.fetchM3U8Urls { [weak self] (result) in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let urls):
                strongSelf.titleText = strongSelf.relatedVideos[indexPath.row].title
                strongSelf.setCell(with: urls, andTitle: strongSelf.titleText)
            case .failure(let error):
                strongSelf.popUpAlert(for: error)
            }
            
            self?.dismissHUD()
        }
    }
}

