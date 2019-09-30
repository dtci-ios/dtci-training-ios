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
    
    private var videosAPI: VideosAPI?
    private var videos = [Video]()
    
    var playlist: [Video?] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        videosAPI = VideosAPI()
        
        videosAPI?.fetchVideoList(byGameId: "1902") { (retrievedVideos) in
            self.videos = retrievedVideos
            self.playlist = self.videos
            self.tableView.reloadData()
        }
        
        tableView.register(UINib(nibName: VideoTableViewCell.Constants.nibName, bundle: nil),
                           forCellReuseIdentifier: VideoTableViewCell.Constants.reuseIdentifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    @objc private func refreshData(_ sender: Any) {
        tableView.refreshControl?.endRefreshing()

        if !videos.isEmpty {
            playlist.append(videos.removeFirst())
            tableView.reloadData()
        }
    }
    
}

extension VideoPlaylistViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
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
