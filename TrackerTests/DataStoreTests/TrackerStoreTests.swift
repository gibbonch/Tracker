//
//  TrackerStoreTests.swift
//  TrackerTests
//
//  Created by Александр Торопов on 19.01.2025.
//

@testable import Tracker
import XCTest
import CoreData

final class TrackerStoreTests: XCTestCase {
    var trackerStore: TrackerStore!
    var coreDataStack: CoreDataStack!
    
    override func setUp() {
        super.setUp()
        coreDataStack = TestCoreDataStack()
        trackerStore = TrackerStore(coreDataStack: coreDataStack)
    }
    
    override func tearDown() {
        super.tearDown()
        coreDataStack = nil
        trackerStore = nil
    }
    
    func testCreateTracker() {
        // Given
        let tracker = Tracker(type: .regular,
                              title: "Tracker 1",
                              schedule: [.monday, .saturday, .sunday],
                              color: .selection1,
                              emoji: "🥶")
        
        let categoryTitle = "Category 1"
        let categoryStore = TrackerCategoryStore(coreDataStack: coreDataStack)
        let categoryEntity = categoryStore.createCategory(title: categoryTitle)
        XCTAssertNotNil(categoryEntity)
        
        // When
        let trackerEntity = trackerStore.create(tracker: tracker, in: categoryTitle)
        
        // Then
        XCTAssertNotNil(trackerEntity)
        XCTAssertEqual(tracker.id, trackerEntity?.trackerID)
        XCTAssertEqual(tracker.emoji, trackerEntity?.emoji)
        XCTAssertEqual(tracker.title, trackerEntity?.title)
        XCTAssertEqual(tracker.color, trackerEntity?.color)
        XCTAssertEqual(tracker.type.rawValue, trackerEntity?.type)
        XCTAssertEqual(Set(tracker.schedule), Set(trackerEntity?.schedule ?? []))
        XCTAssertEqual(categoryTitle, trackerEntity?.sectionTitle)
    }
    
    func testCreateTrackerInNonExistentCategory() {
        // Given
        let tracker = Tracker(type: .regular,
                              title: "Tracker 1",
                              schedule: [.monday, .saturday, .sunday],
                              color: .selection1,
                              emoji: "🥶")
        
        let nonExistentCategoryTitle = "Category 1"
        
        // When
        let trackerEntity = trackerStore.create(tracker: tracker, in: nonExistentCategoryTitle)
        
        // Then
        XCTAssertNil(trackerEntity)
    }
    
    func testFetchTracker() {
        // Given
        let tracker = Tracker(type: .regular,
                              title: "Tracker 1",
                              schedule: [.monday, .saturday, .sunday],
                              color: .selection1,
                              emoji: "🥶")
        
        let categoryTitle = "Category 1"
        let categoryStore = TrackerCategoryStore(coreDataStack: coreDataStack)
        let categoryEntity = categoryStore.createCategory(title: categoryTitle)
        XCTAssertNotNil(categoryEntity)
        
        let trackerEntity = trackerStore.create(tracker: tracker, in: categoryTitle)
        XCTAssertNotNil(trackerEntity)
        
        // When
        let fetchedTracker = trackerStore.fetchTracker(with: tracker.id)
        
        // Then
        XCTAssertNotNil(fetchedTracker)
        XCTAssertEqual(tracker.id, fetchedTracker?.trackerID)
    }
    
    func testFetchCategoryTitle() {
        // Given
        let tracker = Tracker(type: .regular,
                              title: "Tracker 1",
                              schedule: [.monday, .saturday, .sunday],
                              color: .selection1,
                              emoji: "🥶")
        
        let categoryTitle = "Category 1"
        let categoryStore = TrackerCategoryStore(coreDataStack: coreDataStack)
        let categoryEntity = categoryStore.createCategory(title: categoryTitle)
        XCTAssertNotNil(categoryEntity)
        
        let trackerEntity = trackerStore.create(tracker: tracker, in: categoryTitle)
        XCTAssertNotNil(trackerEntity)
        
        // When
        let fetchedCategoryTitle = trackerStore.fetchCategoryTitle(tracker: tracker)
        
        // Then
        XCTAssertEqual(fetchedCategoryTitle, categoryTitle)
    }
    
    func testUpdateTracker() {
        // Given
        let tracker = Tracker(type: .regular,
                              title: "Original Tracker",
                              schedule: [.monday, .friday],
                              color: .selection1,
                              emoji: "🥶")
        
        let updatedTitle = "Updated Tracker"
        let updatedEmoji = "🔥"
        let updatedColor = UIColor.selection2
        
        let categoryTitle = "Original Category"
        
        let categoryStore = TrackerCategoryStore(coreDataStack: coreDataStack)
        let categoryEntity = categoryStore.createCategory(title: categoryTitle)
        XCTAssertNotNil(categoryEntity)
        
        let trackerEntity = trackerStore.create(tracker: tracker, in: categoryTitle)
        XCTAssertNotNil(trackerEntity)
        
        // When
        let updatedTracker = Tracker(id: tracker.id,
                                     type: .regular,
                                     title: updatedTitle,
                                     schedule: tracker.schedule,
                                     color: updatedColor,
                                     emoji: updatedEmoji)
        
        let updatedEntity = trackerStore.update(tracker: updatedTracker, in: categoryTitle)
        
        // Then
        XCTAssertNotNil(updatedEntity)
        XCTAssertEqual(updatedEntity?.title, updatedTitle)
        XCTAssertEqual(updatedEntity?.emoji, updatedEmoji)
        XCTAssertEqual(updatedEntity?.color, updatedColor)
    }
    
    func testUpdateTrackerCategory() {
        // Given
        let tracker = Tracker(type: .regular,
                              title: "Tracker",
                              schedule: [.monday],
                              color: .selection1,
                              emoji: "🥶")
        let originalCategory = "Original Category"
        let newCategory = "New Category"
        
        let categoryStore = TrackerCategoryStore(coreDataStack: coreDataStack)
        XCTAssertNotNil(categoryStore.createCategory(title: originalCategory))
        XCTAssertNotNil(categoryStore.createCategory(title: newCategory))
        
        let trackerEntity = trackerStore.create(tracker: tracker, in: originalCategory)
        XCTAssertNotNil(trackerEntity)
        
        // When
        let updatedEntity = trackerStore.update(tracker: tracker, from: originalCategory, to: newCategory)
        
        // Then
        XCTAssertNotNil(updatedEntity)
        XCTAssertEqual(updatedEntity?.sectionTitle, newCategory)
    }
    
    func testUpdateTrackerSchedule() {
        // Given
        let tracker = Tracker(type: .regular,
                              title: "Tracker with Schedule",
                              schedule: [.monday],
                              color: .selection1,
                              emoji: "🥶")
        let categoryTitle = "Category"
        let categoryStore = TrackerCategoryStore(coreDataStack: coreDataStack)
        XCTAssertNotNil(categoryStore.createCategory(title: categoryTitle))
        let trackerEntity = trackerStore.create(tracker: tracker, in: categoryTitle)
        XCTAssertNotNil(trackerEntity)
        
        // When
        var updatedTracker = Tracker(id: tracker.id,
                                     type: tracker.type,
                                     title: tracker.title,
                                     schedule: [.tuesday, .friday],
                                     color: tracker.color,
                                     emoji: tracker.emoji)
        
        let updatedEntity = trackerStore.update(tracker: updatedTracker, in: categoryTitle)
        
        // Then
        XCTAssertNotNil(updatedEntity)
        XCTAssertEqual(Set(updatedEntity?.schedule ?? []), Set(updatedTracker.schedule))
    }
    
    func testPinTracker() {
        // Given
        let tracker = Tracker(type: .regular,
                              title: "Pin Tracker",
                              schedule: [.monday],
                              color: .selection1,
                              emoji: "🥶")
        let categoryTitle = "Category"
        let categoryStore = TrackerCategoryStore(coreDataStack: coreDataStack)
        XCTAssertNotNil(categoryStore.createCategory(title: categoryTitle))
        let trackerEntity = trackerStore.create(tracker: tracker, in: categoryTitle)
        XCTAssertNotNil(trackerEntity)
        
        // When
        trackerStore.pin(tracker: tracker)
        let pinnedTracker = trackerStore.fetchTracker(with: tracker.id)
        
        // Then
        XCTAssertEqual(pinnedTracker?.sectionTitle, Constants.pinnedCategoryTitle)
    }

    func testUnpinTracker() {
        // Given
        let tracker = Tracker(type: .regular,
                              title: "Unpin Tracker",
                              schedule: [.monday],
                              color: .selection1,
                              emoji: "🥶")
        let categoryTitle = "Category"
        let categoryStore = TrackerCategoryStore(coreDataStack: coreDataStack)
        XCTAssertNotNil(categoryStore.createCategory(title: categoryTitle))
        let trackerEntity = trackerStore.create(tracker: tracker, in: categoryTitle)
        XCTAssertNotNil(trackerEntity)
        
        trackerStore.pin(tracker: tracker)
        
        // When
        trackerStore.unpin(tracker: tracker)
        let unpinnedTracker = trackerStore.fetchTracker(with: tracker.id)
        
        // Then
        XCTAssertEqual(unpinnedTracker?.sectionTitle, categoryTitle)
    }

    func testDeleteTracker() {
        // Given
        let tracker = Tracker(type: .regular,
                              title: "Delete Tracker",
                              schedule: [.monday],
                              color: .selection1,
                              emoji: "🥶")
        let categoryTitle = "Category"
        let categoryStore = TrackerCategoryStore(coreDataStack: coreDataStack)
        XCTAssertNotNil(categoryStore.createCategory(title: categoryTitle))
        let trackerEntity = trackerStore.create(tracker: tracker, in: categoryTitle)
        XCTAssertNotNil(trackerEntity)
        
        // When
        trackerStore.delete(tracker: tracker)
        let deletedTracker = trackerStore.fetchTracker(with: tracker.id)
        
        // Then
        XCTAssertNil(deletedTracker)
    }
}
