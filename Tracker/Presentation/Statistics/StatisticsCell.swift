//
//  StatisticsCell.swift
//  Tracker
//
//  Created by Александр Торопов on 26.01.2025.
//

import UIKit

final class StatisticsCell: UICollectionViewCell {
    
    // MARK: - Subviews
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = .blackApp
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .blackApp
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var gradientLayer: CAGradientLayer?
    
    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupContentView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyGradientBorder()
    }
    
    // MARK: - Public Methods
    
    func setupCell(title: String, value: Int) {
        titleLabel.text = title
        valueLabel.text = value.description
    }
    
    // MARK: - Private Methods
    
    private func applyGradientBorder() {
        gradientLayer?.removeFromSuperlayer()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(rgb: 0x007BFA).cgColor,
            UIColor(rgb: 0x46E69D).cgColor,
            UIColor(rgb: 0xFD4C49).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 1, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        gradientLayer.frame = bounds
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = 1
        shapeLayer.path = UIBezierPath(roundedRect: bounds.insetBy(dx: 2.5, dy: 2.5), cornerRadius: contentView.layer.cornerRadius).cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        
        gradientLayer.mask = shapeLayer
        
        contentView.layer.insertSublayer(gradientLayer, at: 0)
        self.gradientLayer = gradientLayer
    }
    
    private func setupContentView() {
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 16
        contentView.addSubview(valueLabel)
        contentView.addSubview(titleLabel)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            valueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            valueLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            titleLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 7),
        ])
    }
}

