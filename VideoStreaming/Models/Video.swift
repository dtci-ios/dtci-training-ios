//
//  VideoModel.swift
//  VideoStreaming
//
//  Created by Julian Llorensi on 17/09/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import Foundation

struct Video {
    var durationAndDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MM/dd"
        let dateFormatted = formatter.string(from: date)
        return duration + "." + dateFormatted
    }
    
    let title: String
    let duration: String
    let date: Date
    let imageName: String
}

