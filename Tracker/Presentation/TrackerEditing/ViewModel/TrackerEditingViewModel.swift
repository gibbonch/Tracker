//
//  TrackerEditingViewModel.swift
//  Tracker
//
//  Created by Александр Торопов on 14.12.2024.
//

import UIKit

protocol TrackerEditingViewModel: AnyObject {
    var header: String { get }
    var applyButtonText: String { get }
    var completionsCount: Int? { get }
    var isApplyButtonEnabled: Bool { get }
    
    var trackerType: TrackerType { get }
    var title: String { get set }
    var emoji: String { get set }
    var color: UIColor { get set }
    var category: String { get }
    var schedule: [Weekday] { get }
    
    func applyButtonDidTap()
//    func createTrackerCategoriesViewModel(_ categoryTitle: String?) -> any TrackerCategoriesViewModel
    func createTrackerScheduleViewModel() -> any TrackerScheduleViewModel
    func presentWarningMessage()
}
