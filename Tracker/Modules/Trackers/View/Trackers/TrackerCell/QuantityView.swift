//
//  QuantityView.swift
//  Tracker
//
//  Created by Александр Торопов on 09.11.2024.
//

import UIKit

final class QuantityView: UIView {
    
    // MARK: - Properties
    
    private var daysCount: Int = 0 {
        didSet { updateDayLabel() }
    }
    
    private var checkButtonHandler: (() -> Void)?
    
    // MARK: - Subviews
    
    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.font = .ypMedium12
        label.textColor = .blackApp
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var checkButton = CheckButton()
    
    override var intrinsicContentSize: CGSize {
        let defaultSize = super.intrinsicContentSize
        return CGSize(width: defaultSize.width, height: 58)
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateDayLabel()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func configure(with tracker: Tracker, isChecked: Bool, checkButtonHandler: @escaping () -> Void) {
        self.daysCount = tracker.checkCount
        self.checkButtonHandler = checkButtonHandler
        checkButton.configure(with: UIColor.selectionColor(tracker.colorID)) { [weak self] in
            guard let self else { return }
            self.daysCount += self.checkButton.isChecked ? 1 : -1
            self.checkButtonHandler?()
        }
        checkButton.isChecked = isChecked
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(dayLabel, checkButton)
        
        NSLayoutConstraint.activate([
            dayLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            dayLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            
            checkButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            checkButton.topAnchor.constraint(equalTo: topAnchor, constant: 8)
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
