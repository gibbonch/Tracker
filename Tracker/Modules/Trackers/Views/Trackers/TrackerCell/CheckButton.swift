//
//  CheckButton.swift
//  Tracker
//
//  Created by Александр Торопов on 08.11.2024.
//

import UIKit

final class CheckButton: UIButton {
    
    // MARK: - Properties
    
    var isChecked = false {
        didSet { animateButtonAppearance() }
    }
    
    private var color: UIColor? {
        didSet { updateButtonAppearance() }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 34, height: 34)
    }
    
    // MARK: - Initializer
    
    init() {
        super.init(frame: .zero)
        setupButtonAppearance()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func configure(with color: UIColor?) {
        self.color = color
    }
    
    // MARK: - Private Methods
    
    private func setupButtonAppearance() {
        layer.masksToBounds = true
        layer.cornerRadius = 17
        imageView?.tintColor = .whiteApp
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func updateButtonAppearance() {
        
        let imageName = isChecked ? "checkmark" : "plus"
        setImage(UIImage(systemName: imageName), for: .normal)
        backgroundColor = isChecked ? color?.withAlphaComponent(0.3) : color
    }
    
    private func animateButtonAppearance() {
        
        UIView.animate(withDuration: 0.15, animations: { [weak self] in
            self?.updateButtonAppearance()
            self?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: { [weak self] _ in
            UIView.animate(withDuration: 0.15) {
                self?.transform = CGAffineTransform.identity
            }
        })
    }
}
