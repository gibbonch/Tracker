//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Александр Торопов on 08.11.2024.
//

import UIKit

final class TrackerCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var viewModel: TrackerCellViewModel? {
        didSet { updateCell() }
    }
    
    // MARK: - Subviews
    
    lazy var trackerCardView: TrackerCardView = {
        let cardView = TrackerCardView()
        cardView.layer.cornerRadius = 16
        cardView.layer.borderWidth = 1
        cardView.layer.borderColor = UIColor.grayApp.withAlphaComponent(0.3).cgColor
        cardView.translatesAutoresizingMaskIntoConstraints = false
        return cardView
    }()
    
    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .blackApp
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var completeButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 17
        button.imageView?.tintColor = .whiteApp
        button.addTarget(self, action: #selector(completeButtonDidTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContentView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func updateCell() {
        guard let state = viewModel?.trackerCellState else { return }
        trackerCardView.setup(with: state)
        dayLabel.text = state.completionsCountText
        animateButtonAppearanceUpdate()
        completeButton.isEnabled = state.isEnabled
    }
    
    private func setupContentView() {
        layer.cornerRadius = 16
        contentView.addSubviews(trackerCardView, dayLabel, completeButton)
        
        NSLayoutConstraint.activate([
            trackerCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            trackerCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            trackerCardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            trackerCardView.heightAnchor.constraint(equalToConstant: 90),
            
            dayLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            dayLabel.topAnchor.constraint(equalTo: trackerCardView.bottomAnchor, constant: 16),
            
            completeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            completeButton.topAnchor.constraint(equalTo: trackerCardView.bottomAnchor, constant: 8),
            completeButton.heightAnchor.constraint(equalToConstant: 34),
            completeButton.widthAnchor.constraint(equalToConstant: 34),
        ])
    }
    
    private func updateButtonAppearance() {
        guard let state = viewModel?.trackerCellState else { return }
        let imageName = state.isCompleted ? "checkmark" : "plus"
        completeButton.setImage(UIImage(systemName: imageName)?.withRenderingMode(.alwaysTemplate), for: .normal)
        completeButton.tintColor = .whiteApp
        completeButton.backgroundColor = state.isCompleted ? state.color.withAlphaComponent(0.3) : state.color
    }
    
    private func animateButtonAppearanceUpdate() {
        UIView.animate(withDuration: 0.15) { [weak self] in
            guard let self else { return }
            updateButtonAppearance()
            completeButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        } completion: { [weak self] _ in
            UIView.animate(withDuration: 0.15, animations: {
                self?.completeButton.transform = CGAffineTransform.identity
            })
        }
    }
    
    // MARK: - Objc Methods
    
    @objc private func completeButtonDidTap() {
        guard let viewModel else { return }
        viewModel.completeButtonDidTap()
    }
}

// MARK: - DefaultTrackerCellViewModelDelegate

extension TrackerCollectionViewCell: DefaultTrackerCellViewModelDelegate {
    func didUpdateTrackerCellState() {
        updateCell()
    }
}
