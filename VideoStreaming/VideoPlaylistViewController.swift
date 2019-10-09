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

    func setGameIdAndName(gameId: String, gameName: String) {
        self.gameId = gameId
        self.gameName = gameName
    }
    
    @objc private func refreshData(_ sender: Any) {
        tableView.refreshControl?.endRefreshing()

        networkManager.fetchGameStreams(ofGame: gameId ?? "",
                                        completion: fetchCompletionHandler(result:))
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
        guard let streamUserName = streams[indexPath.row]?.userName else { return }
        
        let urlWithUserName = "https://twitch.tv/" + streamUserName
        
        guard let endpoint = URL(string: "https://pwn.sh/tools/streamapi.py?url=" + urlWithUserName) else { return }
        
        Alamofire.request(endpoint, parameters: nil, headers: GameStreamsAPI.headers).responseJSON { (response) in
            
            guard let dataResponse = response.data else { return }
            
            let decoder = JSONDecoder()
            
            do {
                let pwnResponse = try decoder.decode(PwnResponse.self, from: dataResponse)
                let urlsMirror = Mirror(reflecting: pwnResponse.urls)
                
                var urlsValues: [String] = []
                
                urlsMirror.children.forEach { (urlProperty) in
                    if let urlValue = urlProperty.value as? String {
                        urlsValues.append(urlValue)
                    }
                }
                
                let alert = UIAlertController(title: "Choose the streaming quality", message: nil, preferredStyle: .actionSheet)
                
                let qualityLabels = ["160p", "360p", "480p", "720p", "720p60", "1080p60"]
                
                urlsValues.forEach { (url) in
                    alert.addAction(UIAlertAction(title: qualityLabels[urlsValues.firstIndex(of: url) ?? -1], style: .default) {
                        (action) in
                        
                        guard let indexForActionSelected = alert.actions.firstIndex(of: action) else { return }
                        
                        guard let urlQualitySelected = URL(string: urlsValues[indexForActionSelected]) else { return }
                        
                        let streamPlayerViewController = StreamPlayerViewController(streamingUrl: urlQualitySelected)
                            
                        self.present(streamPlayerViewController, animated: true)
                            
                        streamPlayerViewController.play()
                    })
                }
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
                self.present(alert, animated: true)
                
            } catch let error {
                print("Error when decode JSON \(error.localizedDescription)")
            }
            
        }
    
    }
    
}

extension VideoPlaylistViewController {
    private func registerCellAndSetTableViewDelegates(completion: (() -> Void)?) {
        tableView.register(UINib(nibName: VideoTableViewCell.Constants.nibName, bundle: nil),
                           forCellReuseIdentifier: VideoTableViewCell.Constants.reuseIdentifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        completion?()
    }
    
    private func composeStreamUrl(with userName: String) -> URL? {
        var urlComponents = URLComponents()
        
        urlComponents.scheme = "https"
        urlComponents.host = "twitch.tv"
        urlComponents.path = userName

        return urlComponents.url
    }
}
