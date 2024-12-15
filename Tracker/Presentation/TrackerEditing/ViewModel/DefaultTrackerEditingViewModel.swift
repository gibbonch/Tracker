//
//  DefaultTrackerEditingViewModel.swift
//  Tracker
//
//  Created by Александр Торопов on 09.12.2024.
//

import UIKit

final class DefaultTrackerEditingViewModel: TrackerEditingViewModel {
    
    // MARK: - Properties
    
    weak var delegate: DefaultTrackerEditingViewModelDelegate?
    
    let header: String
    let applyButtonText: String
    let completionsCount: Int?
    let trackerType: TrackerType
    
    private let isNewTracker: Bool
    private let trackerId: UUID?

    private(set) var isApplyButtonEnabled: Bool {
        didSet { delegate?.didUpdateApplyButtonState() }
    }
    
    var title: String {
        didSet { validateApplyButtonState() }
    }
    
    var emoji: String {
        didSet { validateApplyButtonState() }
    }
    
    var color: UIColor {
        didSet { validateApplyButtonState() }
    }
    
    private(set) var category: String {
        didSet {
            delegate?.didUpdateCategory()
            validateApplyButtonState()
        }
    }
    
    private(set) var schedule: [Weekday] {
        didSet {
            delegate?.didUpdateSchedule()
            validateApplyButtonState()
        }
    }
    
    private let storage: TrackerAppStorage
    
    // MARK: - Initializers
    
    init(tracker: Tracker, storage: TrackerAppStorage) {
        self.storage = storage
        
        self.trackerType = tracker.type
        self.trackerId = tracker.id
        self.title = tracker.title
        self.category = storage.fetchCategoryTitle(for: tracker) ?? ""
        self.schedule = tracker.schedule
        self.emoji = tracker.emoji
        self.color = tracker.color
        
        self.isNewTracker = false
        self.header = "Редактирование привычки"
        self.applyButtonText = "Сохранить"
        self.isApplyButtonEnabled = true
        self.completionsCount = storage.fetchRecords(for: tracker).count
    }
    
    init(trackerType: TrackerType, storage: TrackerAppStorage) {
        self.storage = storage
        
        self.trackerType = trackerType
        self.trackerId = nil
        self.title = ""
        self.category = ""
        self.schedule = []
        self.emoji = ""
        self.color = .clear

        self.isNewTracker = true
        self.header = trackerType == .regular ? "Новая привычка" : "Новое нерегулярное событие"
        self.applyButtonText = "Создать"
        self.isApplyButtonEnabled = false
        self.completionsCount = nil
        self.category = "Важное"
        self.schedule = trackerType == .regular ? [] : Weekday.allCases
    }
    
    // MARK: - Public Methods
    
    func applyButtonDidTap() {
        if isNewTracker {
            let newTracker = Tracker(type: trackerType, title: title, schedule: schedule, color: color, emoji: emoji)
            storage.create(tracker: newTracker, in: category)
        } else {
//            let updatedTracker = Tracker(id: trackerId ?? UUID(), type: trackerType, title: title, schedule: schedule, color: color, emoji: emoji)
//            storage.update(tracker: updatedTracker, with: id)
        }
    }
    
    func createTrackerScheduleViewModel() -> any TrackerScheduleViewModel {
        let scheduleViewModel = DefaultTrackerScheduleViewModel(schedule: schedule)
        scheduleViewModel.delegate = self
        return scheduleViewModel
    }
    
    func presentWarningMessage() {
        delegate?.didTitleExchangeLimit()
    }
    
    // MARK: - Private Methods
    
    private func validateApplyButtonState() {
        isApplyButtonEnabled = !title.isEmpty && !category.isEmpty && !schedule.isEmpty && !emoji.isEmpty && color != .clear
    }
}

// MARK: - DefaultTrackerScheduleViewModelDelegate

extension DefaultTrackerEditingViewModel: DefaultTrackerScheduleViewModelDelegate {
    func didEndScheduleEditing(updatedSchedule: [Weekday]) {
        schedule = updatedSchedule
    }
}

