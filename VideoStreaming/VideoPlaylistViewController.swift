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
    
    // mock data
    private var videos = [Video(title: "Opeth - Ghost Reveries", duration: "1:06:58", date: Date(), image: "Opeth-GR"),
                          Video(title: "Led Zeppelin - Houses of the Holy", duration: "0:40:57", date: Date(), image: "Zepp-HH"),
                          Video(title: "Pantera - Vulgar Display of Power", duration: "0:52:48", date: Date(), image: "Pantera-VDP"),
                          Video(title: "Portishead - Roseland NYC Live", duration: "0:57:25", date: Date(), image: "Portishead-RNYCL"),
                          Video(title: "Megadeth - Countdown to Extinction", duration: "0:47:26", date: Date(), image: "Megadeth-CTE"),
                          Video(title: "Charly García - Piano Bar", duration: "0:35:02", date: Date(), image: "Charly-PB"),
                          Video(title: "Sumo - LLegando los Monos", duration: "0:43:08", date: Date(), image: "Sumo-LLM"),
                          Video(title: "Björk - Debut", duration: "0:48:26", date: Date(), image: "Bjork-D"),
                          Video(title: "Testing Placeholder Image", duration: "--:--:--", date: Date(), image: ""),
                          Video(title: "Queens of the Stone Age - Rated R", duration: "0:42:10", date: Date(), image: "QotSA-RR"),
                          Video(title: "Tool - Lateralus", duration: "1:18:51", date: Date(), image: "Tool-L"),
                          Video(title: "Red Hot Chilly Peppers - One Hot Minute", duration: "1:01:24", date: Date(), image: "RHCP-OHM"),
                          Video(title: "Testing Placeholder Image", duration: "--:--:--", date: Date(), image: "")]
    private var playlist : [Video?] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        playlist.append(contentsOf: Array(videos.prefix(3)))
        videos.removeFirst(3)
        
        // Register Cell nib
        tableView.register(UINib(nibName: VideoTableViewCell.Constants.nibName, bundle: nil),
                           forCellReuseIdentifier: VideoTableViewCell.Constants.reuseIdentifier)
        
        // set tableView Delegate and DataSource
        tableView.delegate = self
        tableView.dataSource = self
        
        // Refresh Control
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
    }
    
    @objc private func refreshData(_ sender: Any) {
        tableView.refreshControl?.endRefreshing()
        // Adding Data to test refresh
        if !videos.isEmpty {
            playlist.append(videos.removeFirst())
            tableView.reloadData()
        }
    }
    
}

extension VideoPlaylistViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath) as! VideoTableViewCell
        cell.video = playlist[indexPath.row]
        return cell
    }
    
}
