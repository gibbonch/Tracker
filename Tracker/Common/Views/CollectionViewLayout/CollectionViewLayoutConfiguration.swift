//
//  CollectionViewLayoutConfiguration.swift
//  Tracker
//
//  Created by Александр Торопов on 09.12.2024.
//

import UIKit

struct CollectionViewLayoutConfiguration {
    let cellsPerLine: Int
    let amountWidth: CGFloat
    let cellHeight: CGFloat
    let minimumLineSpacing: CGFloat
    let minimumInteritemSpacing: CGFloat
    let headerHeight: CGFloat
    let sectionInsets: UIEdgeInsets?
    
    var availableWidth: CGFloat {
        amountWidth - (minimumInteritemSpacing + (sectionInsets?.left ?? 0) + (sectionInsets?.right ?? 0))
    }
    
    var itemSize: CGSize {
        let cellWidth = availableWidth / CGFloat(cellsPerLine)
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
