//
//  ScheduleTableViewCell.swift
//  Tracker
//
//  Created by Александр Торопов on 13.11.2024.
//

import UIKit

final class ScheduleTableViewCell: UITableViewCell {
    
    private var handler: (() -> Void)?
    
    // MARK: - Subviews
    
    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.font = .ypRegular17
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var daySwitch: UISwitch = {
        let daySwitch = UISwitch()
        daySwitch.isOn = false
        daySwitch.onTintColor = .blueApp
        daySwitch.addTarget(self, action: #selector(didToggleDaySwitch), for: .valueChanged)
        daySwitch.translatesAutoresizingMaskIntoConstraints = false
        return daySwitch
    }()
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func setupCell(with weekday: Weekday, isSelected: Bool, switchTogglingHandler: @escaping () -> Void) {
        handler = switchTogglingHandler
        backgroundColor = UIColor.lightGrayApp.withAlphaComponent(0.3)
        selectionStyle = .none
        dayLabel.text = weekday.toString()
        daySwitch.isOn = isSelected
    }
    
    // MARK: - Private Methods
    
    private func setConstraints() {
        contentView.addSubviews(dayLabel, daySwitch)
        NSLayoutConstraint.activate([
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            daySwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            daySwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    // MARK: - Objc Methods
    
    @objc private func didToggleDaySwitch() {
        handler?()
    }
}
