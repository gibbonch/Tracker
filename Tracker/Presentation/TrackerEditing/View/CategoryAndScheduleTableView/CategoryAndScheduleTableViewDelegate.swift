//
//  CategoryAndScheduleTableViewDelegate.swift
//  Tracker
//
//  Created by Александр Торопов on 10.12.2024.
//

import UIKit

final class CategoryAndScheduleTableViewDelegate: NSObject, UITableViewDelegate {
    
    // MARK: - Properties
    
    weak var parentViewController: UIViewController?
    private weak var viewModel: TrackerEditingViewModel?
    
    // MARK: - Initializer
    
    init(viewModel: TrackerEditingViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Public Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel else { return }
        
        if indexPath.row == 0 {
            // ...
        } else {
            let trackerScheduleViewModel = viewModel.createTrackerScheduleViewModel()
            let trackerScheduleViewController = TrackerScheduleViewController(viewModel: trackerScheduleViewModel)
            parentViewController?.present(trackerScheduleViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
    }
}
