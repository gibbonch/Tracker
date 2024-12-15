//
//  DefaultTrackersViewModel.swift
//  Tracker
//
//  Created by Александр Торопов on 14.11.2024.
//

import Foundation

final class DefaultTrackersViewModel: TrackersViewModel {
    
    // MARK: - Properties
    
    weak var delegate: DefaultTrackersViewModelDelegate?
    private let storage: TrackerAppStorage
    
    private(set) var visibleCategories: [TrackerCategory] = []
    
    private var date: Date = Date()
    private var searchText: String = ""
    private var filter: TrackerFilter = .all
    
    private var query: TrackerQuery {
        TrackerQuery(title: searchText, date: date, filter: filter)
    }
    
    // MARK: - Initializer
    
    init(storage: TrackerAppStorage) {
        self.storage = UserDefaultsStorage()
        updateCategories()
    }
    
    // MARK: - Public Methods
    
    func updateDate(_ date: Date) {
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: "dateDidChange"),
            object: nil,
            userInfo: ["date": date]
        )
        
        self.date = date
        updateCategories()
    }
    
    func updateSearchText(_ searchText: String) {
        self.searchText = searchText
        updateCategories()
    }
    
    func updateFilter(_ filter: TrackerFilter) {
        self.filter = filter
        updateCategories()
    }
    
    func viewWillAppear() {
        updateCategories()
    }
    
    func deleteTracker(at indexPath: IndexPath) {
        let category = visibleCategories[indexPath.section]
        let tracker = category.trackers[indexPath.row]
        storage.delete(tracker: tracker, from: category.title)
        updateCategories()
    }
    
    func pinTracker(at indexPath: IndexPath) {
        let category = visibleCategories[indexPath.section]
        let tracker = category.trackers[indexPath.row]
        storage.create(tracker: tracker, in: "Закрепленные")
        
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: "trackerDidPin"),
            object: nil,
            userInfo: ["trackerId": tracker.id]
        )
        
        updateCategories()
    }
    
    func unpinTracker(at indexPath: IndexPath) {
        let category = visibleCategories[indexPath.section]
        let tracker = category.trackers[indexPath.row]
        storage.delete(tracker: tracker, from: "Закрепленные")
        
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: "trackerDidUnpin"),
            object: nil,
            userInfo: ["trackerId": tracker.id]
        )
        
        updateCategories()
    }
    
    func trackerCellViewModel(tracker: Tracker) -> any TrackerCellViewModel {
        return DefaultTrackerCellViewModel(storage: storage, tracker: tracker, date: date)
    }
    
    func createTrackerEditingViewModel(at indexPath: IndexPath) -> any TrackerEditingViewModel {
        let category = visibleCategories[indexPath.section]
        let tracker = category.trackers[indexPath.row]
        return DefaultTrackerEditingViewModel(tracker: tracker, storage: storage)
    }
    
    // MARK: - Private Methods
    
    private func updateCategories() {
        visibleCategories = storage.fetchCategories(query: query)
        if let pinCategoryIndex = visibleCategories.firstIndex(where: { $0.title == "Закрепленные" }) {
            let pinCategory = visibleCategories.remove(at: pinCategoryIndex)
            visibleCategories.insert(pinCategory, at: 0)
        }
        
        delegate?.didUpdateVisibleCategories()
    }
}
