//
//  CategoryTableViewCell.swift
//  Tracker
//
//  Created by Александр Торопов on 14.11.2024.
//

import UIKit

final class CategoryTableViewCell: UITableViewCell {
    
    static let cellHeight = 75.0
    
    lazy var categoryLabel = YPLabel(font: .ypRegular17)
    
    lazy var markImageView: UIImageView = {
        let imageView = UIImageView(image: nil)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        backgroundColor = UIColor.lightGrayApp.withAlphaComponent(0.3)
        
        contentView.addSubviews(categoryLabel, markImageView)
        NSLayoutConstraint.activate([
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            categoryLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            markImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            markImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
}
