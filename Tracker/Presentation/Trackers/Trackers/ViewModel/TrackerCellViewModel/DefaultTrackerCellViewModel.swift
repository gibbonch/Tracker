//
//  DefaultTrackerCellViewModel.swift
//  Tracker
//
//  Created by Александр Торопов on 07.12.2024.
//

import UIKit

final class DefaultTrackerCellViewModel: TrackerCellViewModel {
    
    // MARK: - Properties
    
    weak var delegate: DefaultTrackerCellViewModelDelegate?
    
    private(set) var trackerCellState: TrackerCellState
    
    private let tracker: Tracker
    private var date: Date
    private let storage: TrackerAppStorage
    
    // MARK: - Initializer
    
    init(storage: TrackerAppStorage, tracker: Tracker, date: Date) {
        self.storage = storage
        self.tracker = tracker
        self.date = date
        
        let completionsCount = storage.fetchRecords(for: tracker).count
        let isCompleted = storage.fetchRecords(for: tracker).contains { Calendar.current.isDate($0.date, inSameDayAs: date) }
        let isPinned = storage.fetchTrackers(from: "Закрепленные").contains { $0.id == tracker.id }
        let isEnabled = date <= Date()
        
        self.trackerCellState = TrackerCellState(
            tracker: tracker,
            completionsCount: completionsCount,
            isCompleted: isCompleted,
            isEnabled: isEnabled,
            isPinned: isPinned
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateDate),
            name: NSNotification.Name(rawValue: "dateDidChange"),
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(pinTracker),
            name: NSNotification.Name(rawValue: "trackerDidPin"),
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(unpinTracker),
            name: NSNotification.Name(rawValue: "trackerDidUnpin"),
            object: nil
        )
    }
    
    // MARK: - Public Methods
    
    func completeButtonDidTap() {
        trackerCellState.toggleCompletion()
        
        if trackerCellState.isCompleted {
            storage.create(record: TrackerRecord(trackerID: tracker.id, date: date))
        } else {
            storage.delete(record: TrackerRecord(trackerID: tracker.id, date: date))
        }
        
        delegate?.didUpdateTrackerCellState()
    }
    
    // MARK: - Objc Methods
    
    @objc private func updateDate(_ notification: NSNotification) {
        if let date = notification.userInfo?["date"] as? Date {
            self.date = date
            trackerCellState.isCompleted = storage.fetchRecords(for: tracker).contains { Calendar.current.isDate($0.date, inSameDayAs: date) }
            trackerCellState.isEnabled = date <= Date()
            delegate?.didUpdateTrackerCellState()
        }
    }
    
    @objc private func pinTracker(_ notification: NSNotification) {
        if let pinnedTrackerId = notification.userInfo?["trackerId"] as? UUID, pinnedTrackerId == tracker.id {
            trackerCellState.isPinned = true
            delegate?.didUpdateTrackerCellState()
        }
    }
    
    @objc private func unpinTracker(_ notification: NSNotification) {
        if let pinnedTrackerId = notification.userInfo?["trackerId"] as? UUID, pinnedTrackerId == tracker.id {
            trackerCellState.isPinned = false
            delegate?.didUpdateTrackerCellState()
        }
    }
}
