//
//  UITableViewCell+identifier.swift
//  Tracker
//
//  Created by Александр Торопов on 13.11.2024.
//

import UIKit

extension UITableViewCell {
    static var identifier: String {
        return String(describing: type(of: self))
    }
}
