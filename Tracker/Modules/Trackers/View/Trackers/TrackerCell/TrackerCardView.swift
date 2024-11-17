//
//  TrackerCardView.swift
//  Tracker
//
//  Created by Александр Торопов on 08.11.2024.
//

import UIKit

final class TrackerCardView: UIView {
    
    // MARK: - Properties
    override var intrinsicContentSize: CGSize {
        let defaultSize = super.intrinsicContentSize
        return CGSize(width: defaultSize.width, height: 90)
    }
    
    // MARK: - Subviews
    lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 15
        label.backgroundColor = .whiteApp.withAlphaComponent(0.3)
        label.textAlignment = .center
        label.font = .ypMedium16
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var pinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .pin
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .ypMedium12
        label.textColor = .whiteApp
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configure(with tracker: Tracker) {
        emojiLabel.text = tracker.emoji
        titleLabel.text = tracker.title
        backgroundColor = .selectionColor(tracker.colorID)
        pinImageView.isHidden = !tracker.isPin
    }
    
    // MARK: - Private Methods
    private func setupView() {
        layer.cornerRadius = 16
        layer.borderWidth = 1
        layer.borderColor = UIColor.grayApp.withAlphaComponent(0.3).cgColor
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(emojiLabel, pinImageView, titleLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            emojiLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            emojiLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            emojiLabel.heightAnchor.constraint(equalToConstant: 28),
            emojiLabel.widthAnchor.constraint(equalToConstant: 28),
            
            pinImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            pinImageView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
        ])
    }
}
