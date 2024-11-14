//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Александр Торопов on 08.11.2024.
//

import UIKit

final class TrackerCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private let trackerCardView = TrackerCardView()
    private let quantityView = QuantityView()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func configure(with tracker: Tracker, isChecked: Bool, checkButtonHandler: @escaping () -> Void) {
        trackerCardView.configure(with: tracker)
        quantityView.configure(with: tracker, isChecked: isChecked, checkButtonHandler: checkButtonHandler)
    }
    
    private func setupCell() {
        contentView.addSubviews(trackerCardView, quantityView)
        
        NSLayoutConstraint.activate([
            trackerCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            trackerCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            trackerCardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            quantityView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            quantityView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            quantityView.topAnchor.constraint(equalTo: trackerCardView.bottomAnchor),
        ])
    }
    
}
