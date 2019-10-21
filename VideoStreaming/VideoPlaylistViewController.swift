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
    
    func fetchCompletionHandler(result: Swift.Result<[Stream], APIError>) {
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
    
    private func playVideo(with streamingURL: String?) {
        if let url = streamingURL, let m3u8URL = URL(string: url) {
            let streamPlayerViewController = StreamPlayerViewController(streamingUrl: m3u8URL)
                           
            present(streamPlayerViewController, animated: true)
                           
            streamPlayerViewController.play()
        }
    }
    
    private func takeUserLoginName(from users: [User]) -> String {
        guard let userLoginName = users.first?.login else { return "" }
        return userLoginName
    }
    
    private func createOptions(for urls: PwnResponse.QualityUrls) {
        let alert = UIAlertController(title: "Choose the streaming quality", message: nil, preferredStyle: .actionSheet)
        
        for key in urls.keys.sorted(by: { $0.localizedStandardCompare($1) == .orderedAscending }) {
            alert.addAction(UIAlertAction(title: key, style: .default, handler: { (_) in
                self.playVideo(with: urls[key])
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
        guard let streamUserId = streams[indexPath.row]?.userId else { return }
        
        let usersAPI = UsersAPI()
            
        usersAPI.fetchUsers(userId: streamUserId) { (result) in

            switch result {
            case .success(let users):
                
                let pwnServiceAPI = PwnServiceAPI(userName: self.takeUserLoginName(from: users))
                
                pwnServiceAPI.fetchStreamingM3U8Urls { [weak self] (result) in
                    switch result {
                    case .success(let urls):
                        self?.createOptions(for: urls)
                    case .failure(let error):
                        self?.popUpAlert(for: error)
                    }
                }
                
            case .failure(let error):
                self.popUpAlert(for: error)
            }
            
        }
    }
}



