//
//  UIView+addSubviews.swift
//  Tracker
//
//  Created by Александр Торопов on 06.11.2024.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
