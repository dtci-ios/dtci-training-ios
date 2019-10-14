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
    private var gameName: String?
    private var gameId: String?

    static var nibName: String {
        return String(describing: self)
    }
    
    init(with game: Game) {
        super.init(nibName: VideoPlaylistViewController.nibName, bundle: nil)
        gameName = game.name
        gameId = game.id
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = gameName ?? ""
        
        showHUD()
        
        tableView.register(UINib(nibName: VideoTableViewCell.Constants.nibName, bundle: nil),
                           forCellReuseIdentifier: VideoTableViewCell.Constants.reuseIdentifier)
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.tintColor = .white
        tableView.refreshControl?.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        

        networkManager.fetchGameStreams(ofGame: gameId ?? "", completion: fetchCompletionHandler(result:))
    }
    
    @objc private func refreshData(_ sender: Any) {
        tableView.refreshControl?.endRefreshing()
        networkManager.fetchGameStreams(ofGame: gameId ?? "", completion: fetchCompletionHandler(result:))
    }
    
    func fetchCompletionHandler(result: Result<[Stream], APIError>) {
        dismissHUD()
        switch result {
        case .success(let gameStreams):
            streams = gameStreams
            tableView.reloadData()
        case .failure(let error):
            let alert = UIAlertController(title: "ERROR", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
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
        guard let filePath = Bundle.main.path(forResource: "lol", ofType: ".mp4") else { return }
        
        let streamUrl = URL(fileURLWithPath: filePath)
        
        let streamPlayerViewController = StreamPlayerViewController(streamingUrl: streamUrl)
        
        navigationController?.pushViewController(streamPlayerViewController, animated: true)
    }
}


