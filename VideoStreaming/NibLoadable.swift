//
//  UIView+Extension.swift
//  VideoStreaming
//
//  Created by Julian Llorensi on 04/10/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import UIKit

protocol NibLoadable: class {
    static var nibName: String { get }
}

extension NibLoadable where Self: UIView {
    static var nibName: String {
        return String(describing: self)
    }
    
    func nibSetup() {
        guard let view = Bundle.main.loadNibNamed(Self.nibName, owner: self, options: nil)?.first as? UIView else {
            return
        }
        
        addSubview(view)
    }
}
