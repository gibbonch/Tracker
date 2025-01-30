//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Александр Торопов on 08.11.2024.
//

import UIKit

final class TrackerCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private let appMetrica = AppMetricaService()
    private var trackerCellViewModel: TrackerCellViewModel?
    
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
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func setupCell(viewModel: TrackerCellViewModel) {
        trackerCellViewModel = viewModel
        bind()
        
        trackerCardView.setup(with: viewModel.tracker, isPinned: trackerCellViewModel?.isPinned == true)
    }
    
    // MARK: - Private Methods
    
    private func bind() {
        guard let trackerCellViewModel else { return }
        
        trackerCellViewModel.onDateUpdate = { [weak self] isCompleted, isEnabled in
            self?.completeButton.isEnabled = isEnabled
            self?.updateButtonAppearance(isCompleted: isCompleted)
        }
        
        trackerCellViewModel.onCompletionsCountChangeState = { [weak self] isCompleted, cnt in
            self?.updateCompletionsCount(with: cnt)
            self?.animateButtonAppearanceUpdate(isCompleted: isCompleted)
        }
    }
    
    private func setupContentView() {
        layer.cornerRadius = 16
        contentView.addSubviews(trackerCardView, dayLabel, completeButton)
    }
    
    private func setupLayout() {
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
    
    private func updateCompletionsCount(with cnt: Int) {
        dayLabel.text = String.localizedStringWithFormat(NSLocalizedString("numberOfDays", comment: "Number of tracked days"), cnt)
    }
    
    private func updateButtonAppearance(isCompleted: Bool) {
        guard let trackerCellViewModel else { return }
        let imageName = isCompleted ? "checkmark" : "plus"
        completeButton.setImage(UIImage(systemName: imageName)?.withRenderingMode(.alwaysTemplate), for: .normal)
        completeButton.tintColor = .whiteApp
        completeButton.backgroundColor = isCompleted ? trackerCellViewModel.tracker.color.withAlphaComponent(0.3) : trackerCellViewModel.tracker.color
    }
    
    private func animateButtonAppearanceUpdate(isCompleted: Bool) {
        UIView.animate(withDuration: 0.15) { [weak self] in
            guard let self else { return }
            updateButtonAppearance(isCompleted: isCompleted)
            completeButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        } completion: { [weak self] _ in
            UIView.animate(withDuration: 0.15, animations: {
                self?.completeButton.transform = CGAffineTransform.identity
            })
        }
    }
    
    // MARK: - Objc Methods
    
    @objc private func completeButtonDidTap() {
        guard let trackerCellViewModel else { return }
        appMetrica.reportEvent(event: .click, screen: .Main, item: .track)
        trackerCellViewModel.didCompleteTracker()
    }
}
