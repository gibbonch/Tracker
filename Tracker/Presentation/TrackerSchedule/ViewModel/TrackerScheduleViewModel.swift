//
//  TrackerScheduleViewModel.swift
//  Tracker
//
//  Created by Александр Торопов on 12.12.2024.
//

import Foundation

protocol TrackerScheduleViewModel {
    var schedule: [Weekday] { get }
    func didSelectWeekday(at indexPath: IndexPath)
    func didEndScheduleEditing()
}
