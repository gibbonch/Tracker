//
//  UIView+extensions.swift
//  Tracker
//
//  Created by Александр Торопов on 06.11.2024.
//

import UIKit

extension UIView {
    static var identifier: String {
        return String(describing: self)
    }
    
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
