//
//  MockTrackerStore.swift
//  TrackerTests
//
//  Created by Александр Торопов on 13.01.2025.
//

import Foundation
@testable import Tracker

final class MockTrackerStore: TrackerStoring {
    private(set) var trackerCategories: [TrackerCategory]
    
    private(set) var createTrackerCalled = false
    private(set) var fetchTrackerCalled = false
    private(set) var fetchCategoryTitleCalled = false
    private(set) var deleteTrackerCalled = false
    private(set) var updateTrackerCalled = false
    private(set) var pinTrackerCalled = false
    private(set) var unpinTrackerCalled = false
    
    init(trackerCategories: [TrackerCategory]) {
        self.trackerCategories = trackerCategories
    }
    
    func create(tracker: Tracker, in categoryTitle: String) {
        createTrackerCalled = true
    }
    
    func fetchTracker(with id: UUID) -> TrackerCoreData? {
        fetchTrackerCalled = true
        return nil
    }
    
    func fetchCategoryTitle(tracker: Tracker) -> String {
        fetchCategoryTitleCalled = true
        return ""
    }
    
    func delete(tracker: Tracker) {
        deleteTrackerCalled = true
    }
    
    func update(tracker: Tracker, in categoryTitle: String) {
        updateTrackerCalled = true
    }
    
    func pin(tracker: Tracker) {
        pinTrackerCalled = true
    }
    
    func unpin(tracker: Tracker) {
        unpinTrackerCalled = true
    }
    
    
}
