//
//  ColorCollectionViewCell.swift
//  Tracker
//
//  Created by Александр Торопов on 12.11.2024.
//

import UIKit

final class ColorCollectionViewCell: UICollectionViewCell {
    
    let colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupCell() {
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 3
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        
        contentView.addSubview(colorView)
        
        NSLayoutConstraint.activate([
            colorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            colorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
            colorView.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            colorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
        ])
    }
    
}

extension ColorCollectionViewCell: PickerCollectionViewCellProtocol {
    
    func applySelectAppearance() {
        let color = colorView.backgroundColor
        contentView.layer.borderColor = color?.withAlphaComponent(0.3).cgColor
        
    }
    
    func applyDeselectAppearance() {
        contentView.layer.borderColor = UIColor.clear.cgColor
    }
    
}
