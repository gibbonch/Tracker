//
//  YPLabel.swift
//  Tracker
//
//  Created by Александр Торопов on 13.11.2024.
//

import UIKit

final class YPLabel: UILabel {
    
    init(text: String? = nil, font: UIFont, textColor: UIColor = .blackApp) {
        super.init(frame: .zero)
        setupLabel(text: text, font: font, textColor: textColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLabel(text: String?, font: UIFont, textColor: UIColor) {
        self.text = text
        self.textColor = textColor
        self.font = font
        self.textAlignment = .center
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
}
