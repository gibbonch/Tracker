//
//  DefaultTrackersViewModel.swift
//  Tracker
//
//  Created by Александр Торопов on 14.11.2024.
//

import Foundation

// MARK: - TrackersViewModel

protocol TrackersViewModel: AnyObject {
    var onVisibleCategoriesChange: Binding<[TrackerCategory]>? { get set }
    
    func didUpdate(date: Date)
    func didUpdate(searchText: String)
    func didUpdate(filter: TrackerFilter)
    
    func didDeleteTracker(at indexPath: IndexPath)
    func didPinTracker(at indexPath: IndexPath)
    func didUnpinTracker(at indexPath: IndexPath)
    
    func createTrackerEditingViewModel(at indexPath: IndexPath) -> any TrackerEditingViewModel
    func createTrackerCellViewModel(at indexPath: IndexPath) -> any TrackerCellViewModel
}

// MARK: - DefaultTrackersViewModel

final class DefaultTrackersViewModel: TrackersViewModel {
    
    // MARK: - Properties
    
    var onVisibleCategoriesChange: Binding<[TrackerCategory]>? {
        didSet { trackerProvider.updateTrackerQuery(trackerQuery) }
    }
    
    private var visibleCategories: [TrackerCategory] = []
    
    private var date: Date
    private var searchText: String
    private var filter: TrackerFilter
    
    private let trackerStore: TrackerStoring
    private var trackerProvider: TrackerProviding
    
    private var trackerQuery: TrackerQuery {
        TrackerQuery(title: searchText, date: date, filter: filter)
    }
    
    // MARK: - Initializer
    
    init(trackerStore: TrackerStoring, trackerProvider: TrackerProviding) {
        self.trackerStore = trackerStore
        date = Calendar.current.startOfDay(for: Date())
        searchText = ""
        filter = .all
        
        self.trackerProvider = trackerProvider
        trackerProvider.delegate = self
    }
    
    // MARK: - Public Methods
    
    func didUpdate(date: Date) {
        self.date = date
        NotificationCenter.default.post(name: Notification.dateDidChange, object: date)
        trackerProvider.updateTrackerQuery(trackerQuery)
    }
    
    func didUpdate(searchText: String) {
        self.searchText = searchText
        trackerProvider.updateTrackerQuery(trackerQuery)
    }
    
    func didUpdate(filter: TrackerFilter) {
        self.filter = filter
        trackerProvider.updateTrackerQuery(trackerQuery)
    }
    
    func didDeleteTracker(at indexPath: IndexPath) {
        let category = visibleCategories[indexPath.section]
        let tracker = category.trackers[indexPath.row]
        trackerStore.delete(tracker: tracker)
    }
    
    func didPinTracker(at indexPath: IndexPath) {
        let category = visibleCategories[indexPath.section]
        let tracker = category.trackers[indexPath.row]
        trackerStore.pin(tracker: tracker)
    }
    
    func didUnpinTracker(at indexPath: IndexPath) {
        let category = visibleCategories[indexPath.section]
        let tracker = category.trackers[indexPath.row]
        trackerStore.unpin(tracker: tracker)
    }
    
    func createTrackerCellViewModel(at indexPath: IndexPath) -> any TrackerCellViewModel {
        let category = visibleCategories[indexPath.section]
        return DefaultTrackerCellViewModel(store: TrackerRecordStore(),
                                           date: date,
                                           tracker: category.trackers[indexPath.row],
                                           isPinned: category.title == Constants.pinnedCategoryTitle)
    }
    
    func createTrackerEditingViewModel(at indexPath: IndexPath) -> any TrackerEditingViewModel {
        let category = visibleCategories[indexPath.section]
        let tracker = category.trackers[indexPath.row]
        return DefaultTrackerEditingViewModel(store: TrackerStore(),
                                              tracker: tracker,
                                              completionsCount: TrackerRecordStore().fetchRecordsAmount(for: tracker), 
                                              categoryTitle: category.title)
    }
}

// MARK: - TrackerProviderDelegate

extension DefaultTrackersViewModel: TrackerProviderDelegate {
    func didUpdateFetchedTrackers(_ categories: [TrackerCategory]) {
        visibleCategories = categories
        onVisibleCategoriesChange?(visibleCategories)
    }
}

// MARK: - Notification dateDidChange

extension Notification {
    static let dateDidChange = Notification.Name("dateDidChange")
}
