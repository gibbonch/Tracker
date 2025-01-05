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
    var tracker: Tracker { get }
    var isPinned: Bool { get }
    var isEnabled: Bool { get }
    var isCompleted: Bool { get }
    var completionsCount: Int { get }
    
    func completeTracker()
}

// MARK: - DefaultTrackerCellViewModelDelegate

protocol DefaultTrackerCellViewModelDelegate: AnyObject {
    func didUpdateDate()
}

// MARK: - DefaultTrackerCellViewModel

final class DefaultTrackerCellViewModel: TrackerCellViewModel {
    
    // MARK: - Properties
    
    weak var delegate: DefaultTrackerCellViewModelDelegate?
    
    var tracker: Tracker
    var isPinned: Bool
    var isEnabled: Bool
    var isCompleted: Bool
    var completionsCount: Int
    
    private var date: Date
    private let store: TrackerRecordStoring
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    
    init(store: TrackerRecordStoring, date: Date, tracker: Tracker, isPinned: Bool) {
        self.date = date
        self.store = store
        self.tracker = tracker
        self.isPinned = isPinned
        
        isEnabled = date <= Calendar.current.startOfDay(for: Date())
        isCompleted = store.fetchRecords(for: tracker).contains { Calendar.current.isDate($0.date, inSameDayAs: date) }
        completionsCount = store.fetchRecordsAmount(for: tracker)
        
        NotificationCenter.default.publisher(for: Notification.Name("dateChanged"))
            .sink { [weak self] notification in
                if let updatedDate = notification.object as? Date {
                    self?.date = updatedDate
                    self?.isEnabled = updatedDate <= Calendar.current.startOfDay(for: Date())
                    self?.isCompleted = store.fetchRecords(for: tracker).contains { Calendar.current.isDate($0.date, inSameDayAs: updatedDate) }
                    self?.delegate?.didUpdateDate()
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Public Methods
    
    func completeTracker() {
        isCompleted.toggle()
        completionsCount += isCompleted ? 1 : -1
        
        if isCompleted {
            store.create(record: TrackerRecord(trackerID: tracker.id, date: date))
        } else {
            store.deleteRecord(tracker: tracker, date: date)
        }
    }
}
