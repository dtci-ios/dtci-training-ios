//
//  ViewController.swift
//  VideoStreaming
//
//  Created by JULIAN ANDRES GUTIERREZ MAYA on 9/16/19.
//  Copyright © 2019 ESPN. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    private let topGamesManager = TopGamesAPI()
    private let gameStreamManager = GameStreamsAPI()
    private var gamesArr: [Game?]?
    private var gameStreamsArr: [Stream?]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        topGamesManager.fetchTopGames { (incomingArray) in
            self.gamesArr = incomingArray
            self.tableView.reloadData()
        }
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gamesArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as! GameTableViewCell
        cell.game = gamesArr?[indexPath.row]
        return cell
    }
    
}
