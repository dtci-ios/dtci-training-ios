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
    private var landscapeVideoView: UIView!
    private var player: AVPlayer!
    private var dataSource: StreamPlayerDataSource

    static var nibName: String {
        return String(describing: self)
    }
    
    init(with dataSource: StreamPlayerDataSource) {
        self.dataSource = dataSource
        
        super.init(nibName: StreamPlayerViewController.nibName, bundle: nil)
        
        setupPlayerViewController()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.loadData(completion: errorCompletionHandler(error:))
        
        relatedVideosTableView.register(UINib(nibName: VideoTableViewCell.Constants.nibName, bundle: nil),
            forCellReuseIdentifier: VideoTableViewCell.Constants.reuseIdentifier)
        
        relatedVideosTableView.backgroundColor = .black
        
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.text = dataSource.videoTitle
        
        videoPlayerView.addSubview(playerViewController.view)
        
        playerViewController.view.frame = videoPlayerView.bounds
        
        player = AVPlayer(url: dataSource.url)
        playerViewController.player = player
        playerViewController.player?.play()
        
//        relatedVideosTableView.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        if landscapeVideoView == nil {
            landscapeVideoView  = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.height, height: view.frame.width))
            view.addSubview(landscapeVideoView)
            playerViewController.view.frame = landscapeVideoView.bounds
            landscapeVideoView.addSubview(playerViewController.view)
            landscapeVideoView.willMove(toSuperview: view)
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
    
    private func errorCompletionHandler(error: APIError?) {
        relatedVideosTableView.reloadData()
        if let error = error {
            let alert = UIAlertController(title: "ERROR", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
        }
    }
}

extension StreamPlayerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell") as? VideoTableViewCell else {
            return UITableViewCell()
        }
    
        guard let video = dataSource.getVideo(at: indexPath.row) else { return UITableViewCell() }
        
        cell.configure(with: video)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.relatedVideosCount
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let videoId = dataSource.getVideo(at: indexPath.row)?.id else  { return }
        
        let pwnServiceAPI = PwnServiceAPI(with: videoId)
        
        showHUD()
        
        pwnServiceAPI?.fetchM3U8Urls { [weak self] (result) in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let urls):
                let title = strongSelf.dataSource.getVideo(at: indexPath.row)?.title
                strongSelf.setCell(with: urls, andTitle: title ?? "NO TITLE")
            case .failure(let error):
                strongSelf.errorCompletionHandler(error: error)
            }
            
            self?.dismissHUD()
        }
    }
}

