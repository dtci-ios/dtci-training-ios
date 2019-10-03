//
//  VideoPlaylistViewController.swift
//  VideoStreaming
//
//  Created by Natalia Brasesco on 17/09/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import UIKit
import AVKit
import Alamofire

class VideoPlaylistViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    private let gameStreamsAPI = GameStreamsAPI()
    private var streams: [Stream?] = [Stream]()
    private var gameId: String?
    private var gameName: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = gameName ?? ""
        
        showHUD()
        
        encodingStreamUrl()
        
        tableView.register(UINib(nibName: VideoTableViewCell.Constants.nibName, bundle: nil),
                           forCellReuseIdentifier: VideoTableViewCell.Constants.reuseIdentifier)
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.tintColor = .white
        tableView.refreshControl?.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        fetchGameStreams()
        
        self.dismissHUD()
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
        gameStreamsAPI.fetchGameStreams(ofGame: gameId ?? "") { (retrievedGameStreams) in
            
            if let retrivedGameStreams = retrievedGameStreams?.compactMap({ $0 }) {
                self.streams.append(contentsOf: retrivedGameStreams)
            }
            
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
            return UITableViewCell()
        }
        
        guard let video = streams[indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.configure(with: video)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let streamPlayerViewController = StreamPlayerViewController(streamingUrl: URL(fileURLWithPath: "https://pwn.sh/tools/streamapi.py?url=" + (encodingStreamUrl()?.absoluteString ?? "")))
            
        present(streamPlayerViewController, animated: true) {
            streamPlayerViewController.play()
        }
    }
    
}

extension VideoPlaylistViewController {
    private func registerCellAndSetTableViewDelegates(completion: (() -> Void)?) {
        tableView.register(UINib(nibName: VideoTableViewCell.Constants.nibName, bundle: nil),
                           forCellReuseIdentifier: VideoTableViewCell.Constants.reuseIdentifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        completion?()
    }
    
    private func encodingStreamUrl() -> URL? {
        var urlComponents = URLComponents()
        
        urlComponents.scheme = "https"
        urlComponents.host = "api.twitch.tv"
        urlComponents.path = "/helix/streams"
        urlComponents.queryItems = [
            URLQueryItem(name: "game_id", value: gameId)
        ]

        return urlComponents.url
    }
}
