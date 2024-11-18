//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Александр Торопов on 08.11.2024.
//

import UIKit

protocol TrackerCollectionViewCellDelegate: AnyObject {
    func didTapCheckButton(in cell: TrackerCollectionViewCell)
}

final class TrackerCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    weak var delegate: TrackerCollectionViewCellDelegate?
    
    var tracker: Tracker? {
        didSet {
            guard let tracker else { return }
            trackerCardView.configure(with: tracker)
            daysCount = tracker.checkCount
            checkButton.configure(with: UIColor.selectionColor(tracker.colorID))
            checkButton.addTarget(self, action: #selector(checkButtonDidTap), for: .touchUpInside)
        }
    }
    
    private var daysCount: Int = 0 {
        didSet { updateDayLabel() }
    }
    
    // MARK: - Subviews
    
    lazy var dayLabel = YPLabel(font: .ypMedium12)
    lazy var checkButton = CheckButton()
    lazy var trackerCardView = TrackerCardView()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc private func checkButtonDidTap() {
        delegate?.didTapCheckButton(in: self)
        checkButton.isChecked.toggle()
        daysCount += checkButton.isChecked ? 1 : -1
    }
    
    // MARK: - Private Methods
    
    private func setupCell() {
        contentView.addSubviews(trackerCardView, dayLabel, checkButton)
        
        NSLayoutConstraint.activate([
            trackerCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            trackerCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            trackerCardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            dayLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            dayLabel.topAnchor.constraint(equalTo: trackerCardView.bottomAnchor, constant: 16),
            
            checkButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            checkButton.topAnchor.constraint(equalTo: trackerCardView.bottomAnchor, constant: 8)
        ])
    }
    
    private func updateDayLabel() {
        dayLabel.text = "\(daysCount) \(dayWord(for: daysCount))"
    }
    
    private func dayWord(for count: Int) -> String {
        switch count % 10 {
        case 1 where count % 100 != 11:
            return "день"
        case 2...4 where !(11...14).contains(count % 100):
            return "дня"
        default:
            return "дней"
        }
    }
}
