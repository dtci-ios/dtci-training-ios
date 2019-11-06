//
//  Category.swift
//  VideoStreaming
//
//  Created by Julian Llorensi on 05/11/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import Foundation

enum Category: String {
    case rpg = "ab2975e3-b9ca-4b1a-a93e-fb61a5d5c3a4"
    case adventureGame = "0569b171-2a2b-476e-a596-5bdfb45a1327"
    case shooter = "6ea6bca4-4712-4ab9-a906-e3336a9d8039"
    case multiplayer = "ff56eeeb-99ed-4a60-93fc-0b3f05d8661e "
    case puzzle = "9751ee1d-0e5a-4fd3-8e9f-bc3c5d3230f0"
    case cardAndBoardGame = "6f655045-9989-4ef7-8f85-1edcec42d648"
    case irl = "2610cff9-10ae-4cb3-8500-778e6722fbb5"
    
    var localizedDescription: String {
        var tag: String
        
        switch self {
        case .rpg:
            tag = "RPG"
        case .adventureGame:
            tag = "Adventure Game"
        case .shooter:
            tag = "Shooter"
        case .multiplayer:
            tag = "Fighting"
        case .puzzle:
            tag = "Puzzle"
        case .cardAndBoardGame:
            tag = "Card & Board Game"
        case .irl:
            tag = "Driving & Racing Game"
        }
        
        return tag
    }
}
