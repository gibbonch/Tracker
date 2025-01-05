//
//  DefaultTrackersViewModel.swift
//  Tracker
//
//  Created by Александр Торопов on 14.11.2024.
//

import Foundation
import Combine

// MARK: - TrackersViewModel

protocol TrackersViewModel: AnyObject {
    var date: Date { get set }
    var searchText: String { get set }
    var filter: TrackerFilter { get set }
    
    var visibleCategories: [TrackerCategory] { get }
    
    func performDeleteAction(at indexPath: IndexPath)
    func performPinAction(at indexPath: IndexPath)
    func performUnpinAction(at indexPath: IndexPath)
    
    func createTrackerEditingViewModel(at indexPath: IndexPath, completionsCount: Int) -> any TrackerEditingViewModel
    func createTrackerCellViewModel(tracker: Tracker, isPinned: Bool) -> any TrackerCellViewModel
}

// MARK: - DefaultTrackersViewModelDelegate

protocol DefaultTrackersViewModelDelegate: AnyObject {
    func didUpdateVisibleCategories()
}

// MARK: - DefaultTrackersViewModel

final class DefaultTrackersViewModel: TrackersViewModel {
    
    // MARK: - Properties
    
    weak var delegate: DefaultTrackersViewModelDelegate?
    
    var date: Date = Calendar.current.startOfDay(for: Date()) {
        didSet {
            trackerProvider?.updateTrackerQuery(trackerQuery)
            NotificationCenter.default.post(name: Notification.Name("dateChanged"), object: date)
        }
    }
    
    var searchText: String = "" {
        didSet { trackerProvider?.updateTrackerQuery(trackerQuery) }
    }
    
    var filter: TrackerFilter = .all {
        didSet { trackerProvider?.updateTrackerQuery(trackerQuery) }
    }
    
    private(set) var visibleCategories: [TrackerCategory] = [] 
    
    private let trackerStore: TrackerStoring
    private var trackerProvider: TrackerProvider?
    
    private var trackerQuery: TrackerQuery {
        TrackerQuery(title: searchText, date: date, filter: filter)
    }
    
    // MARK: - Initializer
    
    init(trackerStore: TrackerStoring) {
        self.trackerStore = trackerStore
        
        trackerProvider = TrackerProvider(store: trackerStore)
        trackerProvider?.delegate = self
        trackerProvider?.updateTrackerQuery(trackerQuery)
    }
    
    // MARK: - Public Methods
    
    func performDeleteAction(at indexPath: IndexPath) {
        let category = visibleCategories[indexPath.section]
        let tracker = category.trackers[indexPath.row]
        trackerStore.delete(tracker: tracker)
    }
    
    func performPinAction(at indexPath: IndexPath) {
        let category = visibleCategories[indexPath.section]
        let tracker = category.trackers[indexPath.row]
        trackerStore.pin(tracker: tracker)
    }
    
    func performUnpinAction(at indexPath: IndexPath) {
        let category = visibleCategories[indexPath.section]
        let tracker = category.trackers[indexPath.row]
        trackerStore.unpin(tracker: tracker)
    }
    
    func createTrackerCellViewModel(tracker: Tracker, isPinned: Bool) -> any TrackerCellViewModel {
        DefaultTrackerCellViewModel(
            store: TrackerRecordStore(),
            date: date,
            tracker: tracker,
            isPinned: isPinned
        )
    }
    
    func createTrackerEditingViewModel(at indexPath: IndexPath, completionsCount: Int) -> any TrackerEditingViewModel {
        let category = visibleCategories[indexPath.section]
        let tracker = category.trackers[indexPath.row]
        return DefaultTrackerEditingViewModel(
            store: TrackerStore(),
            tracker: tracker,
            completionsCount: completionsCount
        )
    }
}

// MARK: - TrackerProviderDelegate

extension DefaultTrackersViewModel: TrackerProviderDelegate {
    func didUpdateFetchedTrackers(_ categories: [TrackerCategory]) {
        visibleCategories = categories
        delegate?.didUpdateVisibleCategories()
    }
}
