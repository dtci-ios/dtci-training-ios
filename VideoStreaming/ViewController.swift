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
        // Do any additional setup after loading the view.
        videoView.configure(with: Video(title: "The Hupmobile (Ep. 1)", duration: "20:45", date: Date(), imageName: "hupmobile"))
    }
}

