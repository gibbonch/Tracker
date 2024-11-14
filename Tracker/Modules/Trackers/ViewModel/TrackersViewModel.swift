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
        
        print(completedTrackers)
    }
    
    // MARK: - Methods
    
    func relevantCategories(filterText: String? = "", selectedDay: Day? = nil) -> [TrackerCategory] {
        let relevantCategories = categories.map { category -> TrackerCategory in
            let relevantTrackers = category.trackers.filter { tracker in
                let matchesText = filterText == nil || filterText!.isEmpty || tracker.title.localizedCaseInsensitiveContains(filterText!)
                let matchesDay = selectedDay == nil || (tracker.schedule.contains(selectedDay!))
                let singleEventDidCheck = tracker.type == .single && tracker.checkCount != 0
                return matchesText && matchesDay && !singleEventDidCheck
            }
            return TrackerCategory(title: category.title, trackers: relevantTrackers)
        }.filter { !$0.trackers.isEmpty }
        
        return relevantCategories
    }
    
    func addTracker(_ tracker: Tracker, to categoryTitle: String) {
        if let categoryIndex = categories.firstIndex(where: { $0.title == categoryTitle }) {
            categories[categoryIndex].trackers.append(tracker)
        } else {
            let newCategory = TrackerCategory(title: categoryTitle, trackers: [tracker])
            categories.append(newCategory)
        }
        
        storage.saveCategories(categories)
    }
    
    func deleteTracker(_ tracker: Tracker, from categoryTitle: String) {
        if let categoryIndex = categories.firstIndex(where: { $0.title == categoryTitle }) {
            categories[categoryIndex].trackers.removeAll { $0 == tracker }
            
            if categories[categoryIndex].trackers.isEmpty {
                categories.remove(at: categoryIndex)
            }
        }
        
        storage.saveCategories(categories)
    }
    
    func isTrackerCompleted(_ trackerID: UUID, on date: Date) -> Bool {
        return completedTrackers.contains {
            let calendar = Calendar.current
            let trackerDate = $0.date
            let targetDate = date
            
            let trackerYear = calendar.component(.year, from: trackerDate)
            let trackerMonth = calendar.component(.month, from: trackerDate)
            let trackerDay = calendar.component(.day, from: trackerDate)
            
            let targetYear = calendar.component(.year, from: targetDate)
            let targetMonth = calendar.component(.month, from: targetDate)
            let targetDay = calendar.component(.day, from: targetDate)
            
            return $0.trackerID == trackerID &&
                   trackerYear == targetYear &&
                   trackerMonth == targetMonth &&
                   trackerDay == targetDay
        }
    }
    
    func checkTracker(_ trackerID: UUID, on date: Date) {
        let record = TrackerRecord(trackerID: trackerID, date: date)
        completedTrackers.append(record)
        updateTrackerCounter(trackerID)
        storage.saveCompletedTrackers(completedTrackers)
    }
    
    func uncheckTracker(_ trackerID: UUID, on date: Date) {
        completedTrackers.removeAll { $0.trackerID == trackerID && $0.date == date }
        updateTrackerCounter(trackerID)
        storage.saveCompletedTrackers(completedTrackers)
    }
    
    private func updateTrackerCounter(_ trackerID: UUID) {
        let categoryIndex = categories.firstIndex(where: { category in
            category.trackers.contains { $0.id == trackerID }
        })
        
        if let categoryIndex {
            if let trackerIndex = categories[categoryIndex].trackers.firstIndex(where: { $0.id == trackerID }) {
                let completedCount = completedTrackers.filter { $0.trackerID == trackerID }.count
                categories[categoryIndex].trackers[trackerIndex].checkCount = completedCount
            }
        }
        
        storage.saveCategories(categories)
    }
    
}
