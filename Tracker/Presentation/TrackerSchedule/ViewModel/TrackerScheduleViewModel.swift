//
//  TrackerScheduleViewModel.swift
//  Tracker
//
//  Created by Александр Торопов on 12.12.2024.
//

import Foundation

// MARK: - TrackerScheduleViewModel

protocol TrackerScheduleViewModel {
    var schedule: [Weekday] { get }
    func didSelectWeekday(at indexPath: IndexPath)
    func didEndScheduleEditing()
}

// MARK: - DefaultTrackerScheduleViewModelDelegate

protocol DefaultTrackerScheduleViewModelDelegate: AnyObject {
    func didEndScheduleEditing(updatedSchedule: [Weekday])
}

// MARK: - DefaultTrackerScheduleViewModel

final class DefaultTrackerScheduleViewModel: TrackerScheduleViewModel {
    
    // MARK: - Properties
    
    weak var delegate: DefaultTrackerScheduleViewModelDelegate?
    
    private(set) var schedule: [Weekday] {
        didSet { Utilities.bringScheduleIntoRuFormat(&schedule) }
    }
    
    // MARK: - Initializer
    
    init(schedule: [Weekday]) {
        self.schedule = schedule
        Utilities.bringScheduleIntoRuFormat(&self.schedule)
    }
    
    // MARK: - Public Methods
    
    func didSelectWeekday(at indexPath: IndexPath) {
        let rawValue = indexPath.row == 6 ? 0 : indexPath.row + 1
        guard let weekday = Weekday(rawValue: rawValue) else { return }
        if schedule.contains(weekday) {
            schedule.removeAll(where: { $0 == weekday })
        } else {
            schedule.append(weekday)
        }
    }
    
    func didEndScheduleEditing() {
        delegate?.didEndScheduleEditing(updatedSchedule: schedule)
    }
}
