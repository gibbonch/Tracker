//
//  FilledButton.swift
//  Tracker
//
//  Created by Александр Торопов on 07.11.2024.
//

import UIKit

final class FilledButton: UIButton {
    
    // MARK: - Properties
    
    private let enabledBackgroundColor = UIColor.blackApp
    private let disabledBackgroundColor = UIColor.grayApp
    private let handler: () -> Void
    
    override var isEnabled: Bool {
        didSet {
            updateBackground()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        let defaultSize = super.intrinsicContentSize
        return CGSize(width: defaultSize.width, height: 60)
    }
    
    // MARK: - Initializer
    
    init(title: String, isEnabled: Bool = true, handler: @escaping () -> Void) {
        self.handler = handler
        super.init(frame: .zero)
        setupButton(title: title)
        self.isEnabled = isEnabled
        updateBackground()
        addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setupButton(title: String) {
        setTitle(title, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel?.textColor = .whiteApp
        layer.cornerRadius = 16
        isEnabled = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func updateBackground() {
        backgroundColor = isEnabled ? enabledBackgroundColor : disabledBackgroundColor
    }
    
    @objc private func buttonDidTap() {
        handler()
    }
    
}
