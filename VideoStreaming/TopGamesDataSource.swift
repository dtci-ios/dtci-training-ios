//
//  TopGamesDataSource.swift
//  VideoStreaming
//
//  Created by Rodrigo Cian Berrios on 14/10/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import UIKit

class TopGamesDataSource: NSObject {

    private var topGamesAPI: TopGamesAPIProtocol
    private var games: [Game] = []

    init(topGamesAPI: TopGamesAPIProtocol){
        self.topGamesAPI = topGamesAPI
    }

    func hasAnyGame() -> Bool {
        !self.games.isEmpty
    }

    func isGamesEmpty() -> Bool {
        self.games.isEmpty
    }

    func getGamesCount() -> Int {
        return games.count
    }

    func getGameAt(_ position: Int) -> Game? {
        return (0 <= position && position <= games.count - 1) ? self.games[position] : nil
    }

    func getFirstGame() -> Game? {
        return self.games.first
    }

    func getLastGame() -> Game? {
        return self.games.last
    }

    func clearGames() {
        self.games.removeAll()
    }

    func addFirstGame(_ game: Game) {
        self.games.insert(game, at: 0)
    }

    func addLastGame(_ game: Game) {
        self.games.append(game)
    }

    func addGameAt(_ game: Game, position: Int) {
        self.games.insert(game, at: position)
    }

    func removeFirstGame() {
        self.games.removeFirst()
    }

    func removeLastGame() {
        self.games.removeLast()
    }

    func removeGameAt(_ position: Int) {
        self.games.remove(at: position)
    }

    func removeGame(_ toRemove: Game) {
        if let indexToRemove = self.games.firstIndex(of: toRemove) {
            self.games.remove(at: indexToRemove)
        }
    }

    func containsGame(_ game: Game) -> Bool {
        return self.games.contains(game)
    }

    func fetchDataSource(completion: @escaping (APIError?) -> Void) {
        topGamesAPI.fetchTopGames { result in
            switch result {
            case .success(let topGames):
                self.games = topGames
                completion(nil)
            case .failure(let error):
                self.games = []
                completion(error)
            }
        }
    }
}

