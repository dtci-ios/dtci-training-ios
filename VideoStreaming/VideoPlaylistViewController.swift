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
    
    private var videos = [Video]()
    private var videosAPI: VideosAPIProtocol?
    
    static var nibName: String {
        return String(describing: self)
    }
    
    init(videosAPI: VideosAPIProtocol) {
        super.init(nibName: VideoPlaylistViewController.nibName, bundle: nil)
        self.videosAPI = videosAPI
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videosAPI = VideosAPI()
        
        videosAPI?.fetchVideoList(byGameId: String(Int.random(in: 1...10000))) { (retrievedVideos) in
            self.videos = retrievedVideos
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

        videosAPI?.fetchVideoList(byGameId: String(Int.random(in: 1...10000))) { (retrievedVideos) in
            self.videos = retrievedVideos
            self.tableView.reloadData()
        }
    }
    
}

extension VideoPlaylistViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VideoTableViewCell.Constants.reuseIdentifier,
                                                       for: indexPath) as? VideoTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: videos[indexPath.row])
        
        return cell
    }
    
}
