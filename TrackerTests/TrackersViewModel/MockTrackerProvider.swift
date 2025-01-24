//
//  MockTrackerProvider.swift
//  TrackerTests
//
//  Created by Александр Торопов on 13.01.2025.
//

import Foundation
@testable import Tracker

final class MockTrackerProvider: TrackerProviding {
    var delegate: (any TrackerProviderDelegate)? {
        didSet { delegate?.didUpdateFetchedTrackers(mockTrackerStore?.trackerCategories ?? []) }
    }
    
    var mockTrackerStore: MockTrackerStore?
    
    init(mockTrackerStore: MockTrackerStore) {
        self.mockTrackerStore = mockTrackerStore
    }
    
    private(set) var updateTrackerQueryCalled = false
    
    func updateTrackerQuery(_ trackerQuery: TrackerQuery) {
        updateTrackerQueryCalled = true
        delegate?.didUpdateFetchedTrackers(mockTrackerStore?.trackerCategories ?? [])
    }
}
