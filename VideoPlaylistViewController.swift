//
//  VideoPlaylistViewController.swift
//  VideoStreaming
//
//  Created by Natalia Brasesco on 17/09/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import UIKit

struct Video {
    var title: String
    var duration: String
    var date: Date
    var image: String
}

class VideoPlaylistViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    // mock data
    var playlist : [Video] = [Video(title: "Opeth - Ghost Reveries", duration: "1:06:58", date: Date(), image: "Opeth-GR"),
                              Video(title: "Led Zeppelin - Houses of the Holy", duration: "0:40:57", date: Date(), image: "Zepp-HH"),
                              Video(title: "Pantera - Vulgar Display of Power", duration: "0:52:48", date: Date(), image: "Pantera-VDP"),
                              Video(title: "Portishead - Roseland NYC Live", duration: "0:57:25", date: Date(), image: "Portishead-RNYCL"),
                              Video(title: "Megadeth - Countdown to Extinction", duration: "0:47:26", date: Date(), image: "Megadeth-CTE"),
                              Video(title: "Charly García - Piano Bar", duration: "0:35:02", date: Date(), image: "Charly-PB"),
                              Video(title: "Sumo - LLegando los Monos", duration: "0:43:08", date: Date(), image: "Sumo-LLM"),
                              Video(title: "Björk - Debut", duration: "0:48:26", date: Date(), image: "Bjork-D")]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register Cell nib
        tableView.register(UINib(nibName: "VideoTableViewCell", bundle: nil), forCellReuseIdentifier: "videoCell")
        
        // set tableView Delegate and DataSource
        tableView.delegate = self
        tableView.dataSource = self
        
        // Refresh Control
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
    }
    
    @objc private func refreshData(_ sender: Any) {
        // Fetch Data to refresh tableView
        print("refreshed")
        tableView.reloadData()
        tableView.refreshControl?.endRefreshing()
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
