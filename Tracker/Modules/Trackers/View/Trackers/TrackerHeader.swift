//
//  TrackerHeader.swift
//  Tracker
//
//  Created by Александр Торопов on 09.11.2024.
//

import UIKit

final class TrackerHeader: UICollectionReusableView {
    
    // MARK: - Subviews
    lazy var categoryLabel = YPLabel(font: .ypBold19)
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func setupView() {
        addSubview(categoryLabel)
        NSLayoutConstraint.activate([
            categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            categoryLabel.topAnchor.constraint(equalTo: topAnchor),
            categoryLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
