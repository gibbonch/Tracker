//
//  ScheduleTableViewCell.swift
//  Tracker
//
//  Created by Александр Торопов on 13.11.2024.
//

import UIKit

final class ScheduleTableViewCell: UITableViewCell {
    
    lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.font = .ypRegular17
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var daySwitch: UISwitch = {
        let daySwitch = UISwitch()
        daySwitch.isOn = false
        daySwitch.onTintColor = .blueApp
        daySwitch.translatesAutoresizingMaskIntoConstraints = false
        return daySwitch
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        backgroundColor = UIColor.lightGrayApp.withAlphaComponent(0.3)
        
        contentView.addSubviews(dayLabel, daySwitch)
        NSLayoutConstraint.activate([
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            daySwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            daySwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
}
