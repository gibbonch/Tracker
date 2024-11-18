//
//  TrackersViewModel.swift
//  Tracker
//
//  Created by Александр Торопов on 14.11.2024.
//

import Foundation

final class TrackersViewModel {
    
    // MARK: - Properties
    
    private var categories: [TrackerCategory]
    private var completedTrackers: [TrackerRecord]
    
    private let storage: TrackerUserDefaultsDataStorage
    
    // MARK: - Initializer
    init() {
        self.storage = TrackerUserDefaultsDataStorage()
        self.categories = storage.loadCategories()
        self.completedTrackers = storage.loadCompletedTrackers()
    }
    
    // MARK: - Public Methods
    
    func relevantCategories(filterText: String? = "", selectedDate: Date) -> [TrackerCategory] {
        let selectedDay = Day.getDay(from: selectedDate)
        return categories.compactMap { category in
            let relevantTrackers = category.trackers.filter { tracker in
                let matchesText = filterText == nil || filterText!.isEmpty || tracker.title.localizedCaseInsensitiveContains(filterText!)
                let matchesDay = selectedDay == nil || tracker.schedule.contains(selectedDay!)
                let singleEventDidCheck = tracker.type == .single && tracker.checkCount != 0 && !isTrackerCompleted(tracker.id, on: selectedDate)
                return matchesText && matchesDay && !singleEventDidCheck
            }
            return relevantTrackers.isEmpty ? nil : TrackerCategory(id: category.id, title: category.title, trackers: relevantTrackers)
        }
    }
    
    func addTracker(_ tracker: Tracker, to categoryTitle: String) {
        if let index = categories.firstIndex(where: { $0.title == categoryTitle }) {
            let updatedTrackers = categories[index].trackers + [tracker]
            categories[index] = TrackerCategory(
                id: categories[index].id,
                title: categories[index].title,
                trackers: updatedTrackers
            )
        } else {
            let newCategory = TrackerCategory(title: categoryTitle, trackers: [tracker])
            categories.append(newCategory)
        }
        storage.saveCategories(categories)
    }
    
    func deleteTracker(_ tracker: Tracker, from categoryTitle: String) {
        if let index = categories.firstIndex(where: { $0.title == categoryTitle }) {
            let updatedTrackers = categories[index].trackers.filter { $0 != tracker }
            if updatedTrackers.isEmpty {
                categories.remove(at: index)
            } else {
                categories[index] = TrackerCategory(
                    id: categories[index].id,
                    title: categories[index].title,
                    trackers: updatedTrackers
                )
            }
        }
        storage.saveCategories(categories)
    }
    
    func isTrackerCompleted(_ trackerID: UUID, on date: Date) -> Bool {
        let trackers = completedTrackers.contains { record in
            let calendar = Calendar.current
            return record.trackerID == trackerID &&
                calendar.isDate(record.date, inSameDayAs: date)
        }
        return trackers
    }
    
    func checkTracker(_ trackerID: UUID, on date: Date) {
        let record = TrackerRecord(trackerID: trackerID, date: date)
        completedTrackers.append(record)
        updateTrackerCounter(for: trackerID)
        storage.saveCompletedTrackers(completedTrackers)
    }
    
    func uncheckTracker(_ trackerID: UUID, on date: Date) {
        completedTrackers.removeAll { $0.trackerID == trackerID && Calendar.current.isDate($0.date, inSameDayAs: date) }
        updateTrackerCounter(for: trackerID)
        storage.saveCompletedTrackers(completedTrackers)
    }
    
    // MARK: - Private Methods
    
    private func updateTrackerCounter(for trackerID: UUID) {
        for index in categories.indices {
            if let trackerIndex = categories[index].trackers.firstIndex(where: { $0.id == trackerID }) {
                let completedCount = completedTrackers.filter { $0.trackerID == trackerID }.count
                var tracker = categories[index].trackers[trackerIndex]
                tracker = Tracker(
                    id: tracker.id,
                    type: tracker.type,
                    title: tracker.title,
                    colorID: tracker.colorID,
                    emoji: tracker.emoji,
                    schedule: tracker.schedule,
                    trackerValue: completedCount,
                    isPin: tracker.isPin
                )
                categories[index] = TrackerCategory(
                    id: categories[index].id,
                    title: categories[index].title,
                    trackers: categories[index].trackers.replacing(at: trackerIndex, with: tracker)
                )
            }
        }
        storage.saveCategories(categories)
    }
}

private extension Array {
    func replacing(at index: Int, with newElement: Element) -> [Element] {
        var newArray = self
        newArray[index] = newElement
        return newArray
    }
}
