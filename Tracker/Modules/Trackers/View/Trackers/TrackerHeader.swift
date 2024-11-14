//
//  TrackerHeader.swift
//  Tracker
//
//  Created by Александр Торопов on 09.11.2024.
//

import UIKit

final class TrackerHeader: UICollectionReusableView {
    
    static let identifier = "tracker-header"
    
    lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .ypBold19
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(categoryLabel)
        NSLayoutConstraint.activate([
            categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            categoryLabel.topAnchor.constraint(equalTo: topAnchor),
            categoryLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
