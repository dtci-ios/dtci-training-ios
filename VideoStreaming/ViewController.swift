//
//  ViewController.swift
//  VideoStreaming
//
//  Created by JULIAN ANDRES GUTIERREZ MAYA on 9/16/19.
//  Copyright © 2019 ESPN. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet private weak var videoView: VideoView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        videoView.configure(with: Video(title: "Hupmobile",
        duration: "20:30",
        date: Date(),
        imageName: "hupmobile"))
    }
}

