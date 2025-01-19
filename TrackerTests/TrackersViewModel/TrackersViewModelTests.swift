//
//  TrackersViewModelTests.swift
//  TrackerTests
//
//  Created by Александр Торопов on 13.01.2025.
//

import XCTest
@testable import Tracker

final class TrackersViewModelTests: XCTestCase {
    
    private var viewModel: TrackersViewModel!
    private var mockTrackerStore: MockTrackerStore!
    private var mockTrackerProvider: MockTrackerProvider!

    override func setUpWithError() throws {
        let tracker1 = Tracker(type: .regular, title: "tracker 1", schedule: [.monday, .tuesday, .wednesday], color: .selection1, emoji: "🥶")
        let tracker2 = Tracker(type: .regular, title: "tracker 2", schedule: [.tuesday, .friday, .sunday], color: .selection2, emoji: "🥶")
        let tracker3 = Tracker(type: .regular, title: "tracker 3", schedule: Weekday.allCases, color: .selection3, emoji: "🥶")
        let tracker4 = Tracker(type: .regular, title: "tracker 4", schedule: [.monday], color: .selection4, emoji: "🥶")
        let tracker5 = Tracker(type: .regular, title: "tracker 5", schedule: [.saturday, .sunday], color: .selection5, emoji: "🥶")
        
        let category1 = TrackerCategory(title: "category 1", trackers: [tracker1, tracker2, tracker3])
        let category2 = TrackerCategory(title: "category 2", trackers: [tracker4, tracker5])
        
        mockTrackerStore = MockTrackerStore(trackerCategories: [category1, category2])
        mockTrackerProvider = MockTrackerProvider(mockTrackerStore: mockTrackerStore)
        
        viewModel = DefaultTrackersViewModel(trackerStore: mockTrackerStore, trackerProvider: mockTrackerProvider)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockTrackerStore = nil
    }

    func testDateUpdate() throws {
        let date = Calendar.current.startOfDay(for: Date())
        let notificationExpectation = expectation(forNotification: Notification.dateDidChange, object: nil, handler: { notification in
            guard let updatedDate = notification.object as? Date else {
                return false
            }
            return updatedDate == date
        })

        viewModel.didUpdate(date: date)
        
        wait(for: [notificationExpectation], timeout: 1.0)
        XCTAssertTrue(mockTrackerProvider.updateTrackerQueryCalled)
    }
    
    func testUpdateSearchText() throws {
        let newSearchText = "search"
        
        viewModel.didUpdate(searchText: newSearchText)
        
        XCTAssertTrue(mockTrackerProvider.updateTrackerQueryCalled)
    }
    
    func testUpdateFilter() throws {
        let newFilter = TrackerFilter.active

        viewModel.didUpdate(filter: newFilter)
        
        XCTAssertTrue(mockTrackerProvider.updateTrackerQueryCalled)
    }
    
    func testDeleteTracker() throws {
        let indexPath = IndexPath(item: 0, section: 1)

        viewModel.didDeleteTracker(at: indexPath)
        
        XCTAssertTrue(mockTrackerStore.deleteTrackerCalled)
    }
    
    func testPinTracker() throws {
        let indexPath = IndexPath(item: 0, section: 1)

        viewModel.didPinTracker(at: indexPath)
        
        XCTAssertTrue(mockTrackerStore.pinTrackerCalled)
    }
    
    func testUnpinTracker() throws {
        let indexPath = IndexPath(item: 0, section: 1)

        viewModel.didUnpinTracker(at: indexPath)
        
        XCTAssertTrue(mockTrackerStore.unpinTrackerCalled)
    }
}
