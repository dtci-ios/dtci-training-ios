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
    private let gameStreamsAPI = GameStreamsAPI()
    private var streams: [Stream?] = [Stream]()
    private var gameId: String?
    private var gameName: String?
    
    private enum UrlConstants {
        var baseUrl: String {
            return "https://api.twitch.tv/helix/streams?client-id=xzpd1f4527fu8fct7p7own0pgi35v5"
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
        
        gameStreamsAPI.fetchGameStreams(ofGame: gameId ?? "") { (retrievedGameStreamsArray) in
            if let unRetrivedGameStreams = retrievedGameStreamsArray?.compactMap({ $0 }) {
                self.streams.append(contentsOf: unRetrivedGameStreams)
            }
            self.tableView.reloadData()
            self.dismissHUD()
        }
    }

    func setGameIdAndName(gameId: String, gameName: String) {
        self.gameId = gameId
        self.gameName = gameName
    }
    
    @objc private func refreshData(_ sender: Any) {
        tableView.refreshControl?.endRefreshing()

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
        if let streamId = streams[indexPath.row]?.id,
            let path = Bundle.main.path(forResource: "video", ofType: "m3u8") {
            let streamPlayerViewController = StreamPlayerViewController(streamingUrl: URL(fileURLWithPath: path))
            
            present(streamPlayerViewController, animated: true) {
                streamPlayerViewController.play()
            }
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
}
