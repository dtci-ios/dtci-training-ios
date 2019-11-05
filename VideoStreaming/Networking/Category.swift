//
//  Category.swift
//  VideoStreaming
//
//  Created by Julian Llorensi on 05/11/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import Foundation

enum Category: String {
    case rpg = "9d38085e-ee62-4203-877b-81797052a18b"
    case adventureGame = "80427d95-bb46-42d3-bf4d-408e9bdca49a"
    case shooter = "523fe736-fa95-44c7-b22f-13008ca2172c"
    case fighting = "7616f6ea-7e3d-4501-a87c-c160d2bc1849"
    case puzzle = "9751ee1d-0e5a-4fd3-8e9f-bc3c5d3230f0"
    case cardAndBoardGame = "8d39b307-d3ad-4f4a-98a4-d1951f55ceb7"
    case drivingAndRacingGame = "f5ed5bd0-78cb-4467-8e13-9172a210b64d"
    
    var localizedDescription: String {
        var tag: String
        
        switch self {
        case .rpg:
            tag = "RPG"
        case .adventureGame:
            tag = "Adventure Game"
        case .shooter:
            tag = "Shooter"
        case .fighting:
            tag = "Fighting"
        case .puzzle:
            tag = "Puzzle"
        case .cardAndBoardGame:
            tag = "Card & Board Game"
        case .drivingAndRacingGame:
            tag = "Driving & Racing Game"
        @unknown default:
            tag = "None"
        }
        
        return tag
    }
}
