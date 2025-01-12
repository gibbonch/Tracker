//
//  TrackerCardView.swift
//  Tracker
//
//  Created by Александр Торопов on 08.11.2024.
//

import UIKit

final class TrackerCardView: UIView {
       
    // MARK: - Subviews
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 15
        label.backgroundColor = .whiteApp.withAlphaComponent(0.3)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var pinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .pin
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .whiteApp
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
    
    func setup(with tracker: Tracker, isPinned: Bool) {
        emojiLabel.text = tracker.emoji
        titleLabel.text = tracker.title
        backgroundColor = tracker.color
        pinImageView.isHidden = !isPinned
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        addSubviews(emojiLabel, pinImageView, titleLabel)
    }
    
    private func setConstraints() {
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
