//
//  ColumnsLayout.swift
//  VideoStreaming
//
//  Created by Rodrigo Cian Berrios on 14/10/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import UIKit

struct CellAspectRatio {
    // Portrait mode => 4:3 is 4 heigth and 3 width
    var width: Int
    var height: Int

    init(width: Int = 3, height: Int = 4) {
        self.width = width
        self.height = height
    }

    var heightRatioFactor: Float {
        return Float(height) / Float(width)
    }

    var widthRatioFactor: Float {
        return Float(width) / Float(height)
    }
}

struct TopGamesCollectionViewLayout {

    let cellAspectRatio: CellAspectRatio

    var itemsWidthPercentage: Float // in range of 0..1

    init(itemsWidthPercentage: Float = 0.88, cellAspectRatio: CellAspectRatio = CellAspectRatio()) {
        let normalizedItemsWidthPercentage = itemsWidthPercentage > 1 ? itemsWidthPercentage / 100 : itemsWidthPercentage
        self.itemsWidthPercentage = normalizedItemsWidthPercentage
        self.cellAspectRatio = cellAspectRatio
    }

    var paddingsWidthPercentage: Float { // in range of 0..1
        1 - itemsWidthPercentage
    }

    var fullDisponibleWidthForItems : CGFloat {
        floor(ColumnsLayoutHelper.widthOfSafeArea() * CGFloat(itemsWidthPercentage))
    }

    var fullDisponibleWidthForPaddings : CGFloat {
        floor(ColumnsLayoutHelper.widthOfSafeArea() - fullDisponibleWidthForItems)
    }

    var itemWidth : CGFloat {
        floor(fullDisponibleWidthForItems / CGFloat(ColumnsLayoutHelper.columnsForTraitCollection()))
    }

    var itemHeight : CGFloat {
        floor(itemWidth * CGFloat(cellAspectRatio.heightRatioFactor))
    }

    var paddingWidth : CGFloat {
        floor(fullDisponibleWidthForPaddings / CGFloat(ColumnsLayoutHelper.columnsForTraitCollection() + 1))
    }

    func itemSize() -> CGSize {
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
