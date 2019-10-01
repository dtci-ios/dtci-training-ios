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
    
    enum UrlConstants {
        var baseUrl: String {
            return "https://api.twitch.tv/helix/streams?client-id=xzpd1f4527fu8fct7p7own0pgi35v5"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        showHUD(progressLabel: "Loading")
        
        registerCellAndSetTableViewDelegates { [unowned self] in
            self.tableView.refreshControl = UIRefreshControl()
            self.tableView.refreshControl?.tintColor = .white
            self.tableView.refreshControl?.addTarget(self, action: #selector(self.refreshData(_:)), for: .valueChanged)
        }
        
        gameStreamsAPI.fetchGameStreams(ofGame: "417752") { [weak self] (retrivedStreams) in
            self?.streams = retrivedStreams
            self?.tableView.reloadData()
        }
        
        dismissHUD(isAnimated: true)
    }
    
    @objc private func refreshData(_ sender: Any) {
        tableView.refreshControl?.endRefreshing()

        gameStreamsAPI.fetchGameStreams(ofGame: "417752") { (retrivedStreams) in
            self.streams = retrivedStreams
            self.tableView.reloadData()
        }
    }

}

extension VideoPlaylistViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
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
        let streamPlayerViewController = StreamPlayerViewController()
        
        if let streamId = streams[indexPath.row]?.id,
            let path = Bundle.main.path(forResource: "video", ofType: "m3u8") {
        
            streamPlayerViewController.set(streamingUrl: URL(fileURLWithPath: path))
        
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
