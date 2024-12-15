//
//  TrackerHeader.swift
//  Tracker
//
//  Created by Александр Торопов on 09.11.2024.
//

import UIKit

final class TrackerHeaderView: UICollectionReusableView {
    
    // MARK: - Subviews
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.textColor = .blackApp
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func setupHeaderView(category: String) {
        categoryLabel.text = category
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        backgroundColor = .none
        addSubview(categoryLabel)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            categoryLabel.topAnchor.constraint(equalTo: topAnchor),
            categoryLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
