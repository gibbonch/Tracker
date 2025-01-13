//
//  DefaultTrackerCellViewModel.swift
//  Tracker
//
//  Created by Александр Торопов on 07.12.2024.
//

import UIKit
import Combine

// MARK: - TrackerCellViewModel

protocol TrackerCellViewModel: AnyObject {
    var onDateUpdate: ((_ isCompleted: Bool, _ isEnabled: Bool) -> Void)? { get set }
    var onCompletionsCountChangeState: ((_ isCompleted: Bool, _ completionsCount: Int) -> Void)? { get set }
    
    var tracker: Tracker { get }
    var isPinned: Bool { get }
    
    func didCompleteTracker()
}

// MARK: - DefaultTrackerCellViewModel

final class DefaultTrackerCellViewModel: TrackerCellViewModel {
    
    // MARK: - Properties
    
    var onDateUpdate: ((Bool, Bool) -> Void)? {
        didSet { onDateUpdate?(isCompleted, isEnabled) }
    }
    
    var onCompletionsCountChangeState: ((Bool, Int) -> Void)? {
        didSet { onCompletionsCountChangeState?(isCompleted, completionsCount) }
    }
    
    let tracker: Tracker
    let isPinned: Bool
    
    private var isEnabled: Bool
    private var isCompleted: Bool
    private var completionsCount: Int
    
    private var date: Date
    private let store: TrackerRecordStoring
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    
    init(store: TrackerRecordStoring, date: Date, tracker: Tracker, isPinned: Bool) {
        self.store = store
        self.date = date
        self.tracker = tracker
        self.isPinned = isPinned
        
        let trackerRecords = store.fetchRecords(for: tracker)
        isCompleted = trackerRecords.contains { Calendar.current.isDate($0.date, inSameDayAs: date) }
        isEnabled = date <= Calendar.current.startOfDay(for: Date())
        completionsCount = store.fetchRecordsAmount(for: tracker)
         
        bind()
    }
    
    // MARK: - Public Methods
    
    func didCompleteTracker() {
        isCompleted.toggle()
        completionsCount += isCompleted ? 1 : -1
        
        if isCompleted {
            store.create(record: TrackerRecord(trackerID: tracker.id, date: date))
        } else {
            store.deleteRecord(tracker: tracker, date: date)
        }
        
        onCompletionsCountChangeState?(isCompleted, completionsCount)
    }
    
    // MARK: - Private Methods
    
    private func bind() {
        NotificationCenter.default.publisher(for: Notification.dateDidChange)
            .sink { [weak self] notification in
                guard let self else { return }
                if let updatedDate = notification.object as? Date {
                    self.date = updatedDate
                    let trackerRecords = store.fetchRecords(for: tracker)
                    isCompleted = trackerRecords.contains { Calendar.current.isDate($0.date, inSameDayAs: self.date) }
                    isEnabled = date <= Calendar.current.startOfDay(for: Date())
                    
                    onDateUpdate?(isCompleted, isEnabled)
                }
            }
            .store(in: &cancellables)
    }
}
