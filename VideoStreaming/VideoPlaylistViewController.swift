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
    private var dataSource: VideoPlaylistDataSource!

    static var nibName: String {
        return String(describing: self)
    }
    
    init(with game: Game) {
        gameName = game.name
        dataSource = VideoPlaylistDataSource(apiManager: GameStreamsAPI(), gameId: game.id)
        
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
        if let error = error { popUpAlert(for: error) }
    }
    
    private func createPlayer(with streamingURL: String?, title: String, andRelatedVideosFor userId: String) {
        if let url = streamingURL, let m3u8URL = URL(string: url) {
            let streamPlayerViewController = StreamPlayerViewController(with: StreamPlayerDataSource(apiManager: VideosAPI(), url: m3u8URL, videoTitle: title, userId: userId))
            present(streamPlayerViewController, animated: true)
        }
    }
    
    private func takeUserLoginName(from users: [User]) -> String {
        guard let userLoginName = users.first?.login else { return "" }
        return userLoginName
    }
    

    private func createOptionsForPlayer(with urls: PwnResponse.QualityUrls, title: String, andRelatedVideosFor userId: String) {

        let alert = UIAlertController(title: "Choose the streaming quality", message: nil, preferredStyle: .actionSheet)
        
        for key in urls.keys.sorted(by: { $0.localizedStandardCompare($1) == .orderedAscending }) {
            alert.addAction(UIAlertAction(title: key, style: .default, handler: { (_) in
                self.createPlayer(with: urls[key], title: title, andRelatedVideosFor: userId)
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
        
        let usersAPI = UsersAPI()
        
        showHUD()
        
        usersAPI.fetchUsers(userId: streamUserId) { (result) in
            
            switch result {
            case .success(let users):
                let pwnServiceAPI = PwnServiceAPI(forUser: self.takeUserLoginName(from: users))
                    
                pwnServiceAPI?.fetchM3U8Urls { [weak self] (result) in
                    
                    switch result {
                    case .success(let urls):
                        self?.createOptionsForPlayer(with: urls, title: self?.dataSource.getStream(withRow: indexPath.row)?.title ?? "NO TITLE",
                                                     andRelatedVideosFor: streamUserId)
                    case .failure(let error):
                        self?.popUpAlert(for: error)
                    }
                    
                    self?.dismissHUD()
                }
    
            case .failure(let error):
                self.popUpAlert(for: error)
            }
    
        }
    }
}



