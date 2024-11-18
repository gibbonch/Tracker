//
//  EmojiCollectionViewCell.swift
//  Tracker
//
//  Created by Александр Торопов on 13.11.2024.
//

import UIKit

final class EmojiCollectionViewCell: UICollectionViewCell {
        
    let emojiLabel: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 8
        label.font = .ypBold32
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupCell() {
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        
        contentView.addSubview(emojiLabel)
        
        NSLayoutConstraint.activate([
            emojiLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            emojiLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
            emojiLabel.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            emojiLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
        ])
    }
    
}

extension EmojiCollectionViewCell: PickerCollectionViewCellProtocol {
    
    func applySelectAppearance() {
        contentView.backgroundColor = .lightGrayApp
    }
    
    func applyDeselectAppearance() {
        contentView.backgroundColor = .whiteApp
    }
    
}
