//
//  CategoryTableViewCell.swift
//  Tracker
//
//  Created by Александр Торопов on 17.01.2025.
//

import UIKit

final class CategoryTableViewCell: UITableViewCell {
    
    // MARK: - Subviews
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupContentView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func setupCell(title: String, isSelected: Bool) {
        categoryLabel.text = title
        accessoryType = isSelected ? .checkmark : .none
        
        setSelected(isSelected, animated: true)
    }
    
    // MARK: - Private Methods
    
    private func setupContentView() {
        backgroundColor = UIColor.lightGrayApp.withAlphaComponent(0.3)
        selectionStyle = .none
        contentView.addSubviews(categoryLabel)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            categoryLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}
