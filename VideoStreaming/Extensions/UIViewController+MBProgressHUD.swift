//
//  UIViewController+MBProgressHUD.swift
//  VideoStreaming
//
//  Created by Rodrigo Cian Berrios on 18/09/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD
 
extension UIViewController {
    func showHUD(progressLabel: String = "") {
        let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHUD.label.text = progressLabel
    }

    func dismissHUD(isAnimated: Bool = false) {
        MBProgressHUD.hide(for: self.view, animated: isAnimated)
    }
}
