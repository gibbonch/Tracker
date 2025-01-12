//
//  UIColorTransformer.swift
//  Tracker
//
//  Created by Александр Торопов on 17.12.2024.
//

import UIKit

final class UIColorTransformer: ValueTransformer {
    override class func transformedValueClass() -> AnyClass {
        return UIColor.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let color = value as? UIColor else { return nil }
        return try? NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: true)
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        return try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)
    }
}

extension NSValueTransformerName {
    static let uiColorTransformerName = NSValueTransformerName(rawValue: "UIColorTransformer")
}
