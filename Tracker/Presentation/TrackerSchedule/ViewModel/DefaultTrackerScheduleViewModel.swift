//
//  DefaultTrackerScheduleViewModel.swift
//  Tracker
//
//  Created by Александр Торопов on 12.12.2024.
//

import Foundation

protocol DefaultTrackerScheduleViewModelDelegate: AnyObject {
    func didEndScheduleEditing(updatedSchedule: [Weekday])
}

final class DefaultTrackerScheduleViewModel: TrackerScheduleViewModel {
    weak var delegate: DefaultTrackerScheduleViewModelDelegate?
    private(set) var schedule: [Weekday] {
        didSet { Utilities.bringScheduleIntoRuFormat(&schedule) }
    }
    
    init(schedule: [Weekday]) {
        self.schedule = schedule
        Utilities.bringScheduleIntoRuFormat(&self.schedule)
    }
    
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
