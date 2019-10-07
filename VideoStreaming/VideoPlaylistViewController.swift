//
//  VideoPlaylistViewController.swift
//  VideoStreaming
//
//  Created by Natalia Brasesco on 17/09/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import UIKit
import AVKit

class VideoPlaylistViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private let networkManager = GameStreamsAPI()
    private var streams: [Stream?] = []
    private var streamUrl: URL?
    private var gameName: String?
    private var gameId: String? {
        didSet {
            if let url = composeStreamUrl(with: gameId ?? "", forKey: "game_id") {
                streamUrl = url
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = gameName ?? ""
        
        showHUD()
        
        tableView.register(UINib(nibName: VideoTableViewCell.Constants.nibName, bundle: nil),
                           forCellReuseIdentifier: VideoTableViewCell.Constants.reuseIdentifier)
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.tintColor = .white
        tableView.refreshControl?.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        fetchGameStreams()
        
        dismissHUD()
    }

    func setGameIdAndName(gameId: String, gameName: String) {
        self.gameId = gameId
        self.gameName = gameName
    }
    
    @objc private func refreshData(_ sender: Any) {
        tableView.refreshControl?.endRefreshing()

        fetchGameStreams()
    }
    
    private func fetchGameStreams() {
        networkManager.fetchGameStreams(ofGame: gameId ?? "") { (retrievedGameStreamsArray) in
            self.streams = retrievedGameStreamsArray
            self.tableView.reloadData()
        }
    }

}

extension VideoPlaylistViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return streams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VideoTableViewCell.Constants.reuseIdentifier,
                                                       for: indexPath) as? VideoTableViewCell else {
            return VideoTableViewCell()
        }
        
        guard let video = streams[indexPath.row] else {
            return VideoTableViewCell()
        }
        
        cell.configure(with: video)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let streamUrl = streamUrl else { return }
        
        var encodedUrl: String?
        
        do {
            encodedUrl = try String(contentsOf: streamUrl, encoding: .utf8)
        } catch let error {
            print("Error when try encode stream url \(error.localizedDescription)")
        }
        
        guard let urlToGetStreaming = URL(string: "https://pwn.sh/tools/streamapi.py?url=\(encodedUrl ?? "")") else { return }
        
        let streamPlayerViewController = StreamPlayerViewController(streamingUrl: urlToGetStreaming)
            
        present(streamPlayerViewController, animated: true)
            
        streamPlayerViewController.play()
    }
    
}

extension VideoPlaylistViewController {
    fileprivate func registerCellAndSetTableViewDelegates(completion: (() -> Void)?) {
        tableView.register(UINib(nibName: VideoTableViewCell.Constants.nibName, bundle: nil),
                           forCellReuseIdentifier: VideoTableViewCell.Constants.reuseIdentifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        completion?()
    }
    
    fileprivate func composeStreamUrl(with value: String, forKey key: String) -> URL? {
        var urlComponents = URLComponents()
        
        urlComponents.scheme = "https"
        urlComponents.host = "api.twitch.tv"
        urlComponents.path = "/helix/streams"
        urlComponents.queryItems = [
            URLQueryItem(name: key, value: value)
        ]
        
        return urlComponents.url
    }
}
