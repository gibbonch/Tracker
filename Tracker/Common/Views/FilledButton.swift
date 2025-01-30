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
    private let enabledTextColor = UIColor.whiteApp
    private let disabledTextColor = UIColor.white
    
    private let handler: () -> Void
    
    override var isEnabled: Bool {
        didSet {
            updateAppearance()
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
        updateAppearance()
        addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setupButton(title: String) {
        setTitle(title, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        layer.cornerRadius = 16
        isEnabled = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func updateAppearance() {
        backgroundColor = isEnabled ? enabledBackgroundColor : disabledBackgroundColor
        setTitleColor(isEnabled ? enabledTextColor : disabledTextColor, for: .normal)
    }
    
    @objc private func buttonDidTap() {
        handler()
    }
}

