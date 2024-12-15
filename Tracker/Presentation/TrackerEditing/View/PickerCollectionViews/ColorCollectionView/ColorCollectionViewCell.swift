//
//  ColorCollectionViewCell.swift
//  Tracker
//
//  Created by Александр Торопов on 13.12.2024.
//

import UIKit

final class ColorCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var color: UIColor? {
        didSet { colorView.backgroundColor = color }
    }
    
    // MARK: - Subviews
    
    private lazy var colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func applySelectedAppearance() {
        contentView.layer.borderColor = color?.withAlphaComponent(0.3).cgColor
    }
    
    func applyDeselectedAppearance() {
        contentView.layer.borderColor = UIColor.clear.cgColor
    }
    
    // MARK: - Private Methods
    
    private func setupCell() {
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 3
        contentView.backgroundColor = .clear
        contentView.addSubview(colorView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
        ])
    }
}
