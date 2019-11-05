//
//  ColumnsLayoutHelper.swift
//  VideoStreaming
//
//  Created by Rodrigo Cian Berrios on 25/10/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import UIKit

class ColumnsLayoutHelper {

    static func widthOfSafeArea() -> CGFloat {
        guard let rootView = (UIApplication.shared.windows.filter {$0.isKeyWindow}.first) else { return 0 }

        if #available(iOS 11.0, *) {
            let leftInset = rootView.safeAreaInsets.left
            let rightInset = rootView.safeAreaInsets.right
            return rootView.bounds.width - leftInset - rightInset
        } else {
            return rootView.bounds.width
        }
    }

    static func heightOfSafeArea() -> CGFloat {
        guard let rootView = (UIApplication.shared.windows.filter {$0.isKeyWindow}.first) else { return 0 }

        if #available(iOS 11.0, *) {
            let topInset = rootView.safeAreaInsets.top
            let bottomInset = rootView.safeAreaInsets.bottom
            return rootView.bounds.height - topInset - bottomInset
        } else {
            return rootView.bounds.height
        }
    }

    static func columnsForTraitCollection() -> Int {
        switch UITraitCollection.current.horizontalSizeClass {
        case .compact:
            return UITraitCollection.current.verticalSizeClass == .compact ? 3 : 2
        case .regular:
            return UITraitCollection.current.verticalSizeClass == .compact ? 3 : 4
        default:
            return 2
        }
    }
}
