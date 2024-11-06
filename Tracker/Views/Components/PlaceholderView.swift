//
//  PlaceholderView.swift
//  Tracker
//
//  Created by Александр Торопов on 06.11.2024.
//

import UIKit

final class PlaceholderView: UIView {
    
    // MARK: - Properties
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .blackApp
        label.font = .ypMedium12
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializer
    
    init(image: UIImage?, message: String) {
        super.init(frame: .zero)
        imageView.image = image
        messageLabel.text = message
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setupView() {
        addSubviews(imageView, messageLabel)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 80.0),
            imageView.widthAnchor.constraint(equalToConstant: 80.0),
            
            messageLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
}