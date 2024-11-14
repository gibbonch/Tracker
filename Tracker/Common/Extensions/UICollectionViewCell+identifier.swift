//
//  UICollectionViewCell.swift
//  Tracker
//
//  Created by Александр Торопов on 12.11.2024.
//

import UIKit

extension UICollectionViewCell {
    static var identifier: String {
        return String(describing: type(of: self))
    }
}
