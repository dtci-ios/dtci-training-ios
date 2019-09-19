//
//  MainViewController.swift
//  VideoStreaming
//
//  Created by Rodrigo Cian Berrios on 18/09/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import Foundation
import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var mainLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Show the progressHUD
        self.showHUD(progressLabel: "Loading...")
        
        //Added asyncAfter on main Queue for see the progressHUD.
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.mainLabel.text = "Hellow world"
            //Hide the progressHUD
            self.dismissHUD(isAnimated: true)
        }
    }
}

