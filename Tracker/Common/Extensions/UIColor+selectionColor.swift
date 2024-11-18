//
//  UIColor+selectionColor.swift
//  Tracker
//
//  Created by Александр Торопов on 07.11.2024.
//

import UIKit

extension UIColor {
    
    static var selectionColors: [Int: UIColor] {
        var selections = [Int: UIColor]()
        (1...18).forEach { id in
            selections[id] = UIColor(named: "Selection\(id)")
        }
        return selections
    }
    
    static func selectionColor(_ identifier: Int) -> UIColor? {
        return UIColor(named: "Selection\(identifier)")
    }
    
    static func identifier(for color: UIColor?) -> Int? {
        return selectionColors.first(where: { $0.value == color })?.key
    }
    
}
