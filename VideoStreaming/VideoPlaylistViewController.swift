//
//  VideoPlaylistViewController.swift
//  VideoStreaming
//
//  Created by Natalia Brasesco on 17/09/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import UIKit

class VideoPlaylistViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private let networkManager = GameStreamsAPI()
    private var playlist: [Stream?] = []
    private var gameId: String?
    private var gameName: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = gameName ?? ""
        
        showHUD()
        
        tableView.register(UINib(nibName: VideoTableViewCell.Constants.nibName, bundle: nil),
                           forCellReuseIdentifier: VideoTableViewCell.Constants.reuseIdentifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.tintColor = .white
        tableView.refreshControl?.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        networkManager.fetchGameStreams(ofGame: gameId ?? "",
                                        completion: fetchCompletionHandler(success:retrievedGameStreams:error:))
    }

    func setGameIdAndName(gameId: String, gameName: String) {
        self.gameId = gameId
        self.gameName = gameName
    }
    
    @objc private func refreshData(_ sender: Any) {
        tableView.refreshControl?.endRefreshing()

        networkManager.fetchGameStreams(ofGame: gameId ?? "",
                                        completion: fetchCompletionHandler(success:retrievedGameStreams:error:))
    }
    
    func fetchCompletionHandler(success: Bool, retrievedGameStreams: [Stream], error: Error?) {
        self.dismissHUD()
        if success {
            if !retrievedGameStreams.isEmpty {
                self.playlist.append(contentsOf: retrievedGameStreams)
                self.tableView.reloadData()
            }
        } else {
            let alert = UIAlertController(title: "ERROR", message: error?.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
}

extension VideoPlaylistViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VideoTableViewCell.Constants.reuseIdentifier, for: indexPath) as? VideoTableViewCell else {
            return UITableViewCell()
        }
        guard let video = playlist[indexPath.row] else {
            return UITableViewCell()
        }
        cell.configure(with: video)
        return cell
    }
    
}
