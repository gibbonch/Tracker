//
//  CategoryAndScheduleTableViewDataSource.swift
//  Tracker
//
//  Created by Александр Торопов on 12.12.2024.
//

import UIKit

final class CategoryAndScheduleTableViewDataSource: NSObject, UITableViewDataSource {
    
    // MARK: - Properties
    
    private let viewModel: TrackerEditingViewModel
    
    // MARK: - Initializer
    
    init(viewModel: TrackerEditingViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Public Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.trackerType == .regular ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = prepareCell()
        
        if indexPath.row == 0 {
            cell.textLabel?.text = "Категория"
            cell.detailTextLabel?.text = viewModel.category
        } else {
            cell.textLabel?.text = "Расписание"
            var schedule = viewModel.schedule
            Utilities.bringScheduleIntoRuFormat(&schedule)
            if schedule.count == 7 {
                cell.detailTextLabel?.text = "Каждый день"
            } else {
                cell.detailTextLabel?.text = schedule.map { $0.toShortString() }.joined(separator: ", ")
            }
        }
        
        return cell
    }
    
    // MARK: - Private Methods
    
    private func prepareCell() -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "categoryAndScheduleCell")
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        cell.textLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        cell.detailTextLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        cell.detailTextLabel?.textColor = .grayApp
        cell.backgroundColor = UIColor.lightGrayApp.withAlphaComponent(0.3)
        return cell
    }
}
