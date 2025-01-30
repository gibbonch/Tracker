//
//  TitleTextField.swift
//  Tracker
//
//  Created by Александр Торопов on 17.01.2025.
//

import UIKit

final class TitleTextField: UITextField {
    
    init() {
        super.init(frame: .zero)
        setupTextField()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTextField() {
        textColor = .blackApp
        font = .systemFont(ofSize: 17, weight: .regular)
        backgroundColor = .backgroundApp
        layer.cornerRadius = 16
        clearButtonMode = .whileEditing
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 75))
        leftViewMode = .always
        rightView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 75))
        rightViewMode = .unlessEditing
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}
