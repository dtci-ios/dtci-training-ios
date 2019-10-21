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
    
    private var gameName: String?
    private var gameId: String?
    private var dataSource: VideoPlaylistDataSource!

    static var nibName: String {
        return String(describing: self)
    }
    
    init(with game: Game) {
        gameName = game.name
        gameId = game.id
        dataSource = VideoPlaylistDataSource(apiManager: GameStreamsAPI(), gameId: gameId)
        
        super.init(nibName: VideoPlaylistViewController.nibName, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = gameName ?? ""
        
        showHUD()
        
        dataSource.load(completion: errorCompletionHandler(error:))
        
        tableView.register(UINib(nibName: VideoTableViewCell.Constants.nibName, bundle: nil),
                           forCellReuseIdentifier: VideoTableViewCell.Constants.reuseIdentifier)
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.tintColor = .white
        tableView.refreshControl?.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
    }
    
    @objc private func refreshData(_ sender: Any) {
        tableView.refreshControl?.endRefreshing()
        dataSource.load(completion: errorCompletionHandler(error:))
    }
    
    func errorCompletionHandler(error: APIError?) {
        dismissHUD()
        tableView.reloadData()
        if let error = error {
            let alert = UIAlertController(title: "ERROR", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
        }
    }
}

// MARK: TableViewDelegate & TableViewDataSource

extension VideoPlaylistViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? dataSource.streamCount : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VideoTableViewCell.Constants.reuseIdentifier,
                                                       for: indexPath) as? VideoTableViewCell else { return VideoTableViewCell() }
        
        guard let stream = dataSource.getStream(withRow: indexPath.row) else { return VideoTableViewCell() }
        
        cell.configure(with: stream)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let streamUserId = dataSource.getStream(withRow: indexPath.row)?.userId else { return }
        
        let pwnServiceAPI = PwnServiceAPI(withUserId: streamUserId)
    
        pwnServiceAPI.fetchStreamingM3U8Urls { [weak self] (result) in
            switch result {
            case .success(let urls):
                guard let lastStreamingUrl = urls[urls.keys.first ?? ""], let url = URL(string: lastStreamingUrl) else { return }
                           
                let streamPlayerViewController = StreamPlayerViewController(streamingUrl: url)
                               
                self?.present(streamPlayerViewController, animated: true)
                               
                streamPlayerViewController.play()
            case .failure(let error):
                let alert = UIAlertController(title: "ERROR", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true)
            }
        }
    }
}



