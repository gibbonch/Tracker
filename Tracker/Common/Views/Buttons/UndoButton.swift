//
//  UndoButton.swift
//  Tracker
//
//  Created by Александр Торопов on 13.11.2024.
//

import UIKit

final class UndoButton: UIButton {
    
    // MARK: - Properties
    
    private let handler: () -> Void
    
    override var intrinsicContentSize: CGSize {
        let defaultSize = super.intrinsicContentSize
        return CGSize(width: defaultSize.width, height: 60)
    }
    
    // MARK: - Initializer
    
    init(title: String, handler: @escaping () -> Void) {
        self.handler = handler
        super.init(frame: .zero)
        setupButton(title: title)
        addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setupButton(title: String) {
        setTitle(title, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        setTitleColor(.redApp, for: .normal)
        layer.cornerRadius = 16
        layer.borderColor = UIColor.redApp.cgColor
        layer.borderWidth = 1
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc private func buttonDidTap() {
        handler()
    }
    
}
