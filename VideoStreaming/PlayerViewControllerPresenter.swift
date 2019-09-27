//
//  PlayerViewControllerPresenter.swift
//  VideoStreaming
//
//  Created by Julian Llorensi on 27/09/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import Foundation

class PlayerViewControllerPresenter {
    private var viewController: PlayerViewController?
    private var video: Video?
    
    init() {
        self.viewController = nil
        self.video = nil
    }
    
    func set(withViewController controller: PlayerViewController, andVideo video: Video) {
        self.viewController = controller
        self.video = video
    }
}
