//
//  UIColor+selectionColor.swift
//  Tracker
//
//  Created by Александр Торопов on 07.11.2024.
//

import UIKit

extension UIColor {
    static func selectionColor(_ identifier: Int) -> UIColor? {
        return UIColor(named: "Selection\(identifier)")
    }
}
