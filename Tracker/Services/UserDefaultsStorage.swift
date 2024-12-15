//
//  UserDefaultsStorage.swift
//  Tracker
//
//  Created by Александр Торопов on 09.11.2024.
//

import Foundation

final class UserDefaultsStorage: TrackerAppStorage {

    // MARK: - Properties
    
    private let userDefaults = UserDefaults.standard
    private let categoriesStorageKey = "trackerCategories"
    private let completedTrackersStorageKey = "completedTrackers"
    
    private var categories = [TrackerCategory]()
    private var records = [TrackerRecord]()
    
    // MARK: - Initializer
    
    init() {
        categories = loadCategories()
        records = loadCompletedTrackers()
    }

    // MARK: - Private Methods
    
    private func saveCategories() {
        do {
            let data = try JSONEncoder().encode(categories)
            userDefaults.set(data, forKey: categoriesStorageKey)
        } catch {
            print("Failed to save categories: \(error)")
        }
    }
    
    private func loadCategories() -> [TrackerCategory] {
        guard let data = userDefaults.data(forKey: categoriesStorageKey) else {
            return []
        }
        do {
            return try JSONDecoder().decode([TrackerCategory].self, from: data)
        } catch {
            print("Failed to load categories: \(error)")
            return []
        }
    }
    
    private func saveCompletedTrackers() {
        do {
            let data = try JSONEncoder().encode(records)
            userDefaults.set(data, forKey: completedTrackersStorageKey)
        } catch {
            print("Failed to save completed trackers: \(error)")
        }
    }
    
    private func loadCompletedTrackers() -> [TrackerRecord] {
        guard let data = userDefaults.data(forKey: completedTrackersStorageKey) else {
            return []
        }
        do {
            return try JSONDecoder().decode([TrackerRecord].self, from: data)
        } catch {
            print("Failed to load completed trackers: \(error)")
            return []
        }
    }
}

// MARK: - TrackerStorage

extension UserDefaultsStorage {
    func fetchTrackers(from categoryTitle: String) -> [Tracker] {
        let index = categories.firstIndex { category in
            category.title == categoryTitle
        }
        
        guard let index else { return [] }
        return categories[index].trackers
    }
    
    func fetchCategoryTitle(for tracker: Tracker) -> String? {
        return categories.first { category in
            category.trackers.contains(where: { $0 == tracker })
        }?.title
    }
    
    func create(tracker: Tracker, in categoryTitle: String) {
        if let categoryIndex = categories.firstIndex(where: { $0.title == categoryTitle }) {
            let category = categories[categoryIndex]
            var updatedTrackers = category.trackers
            updatedTrackers.append(tracker)
            let updatedCategory = TrackerCategory(id: category.id, title: category.title, trackers: updatedTrackers)
            categories[categoryIndex] = updatedCategory
        } else {
            let category = TrackerCategory(title: categoryTitle, trackers: [tracker])
            categories.append(category)
        }
        
        saveCategories()
    }
    
    // TODO: Bug with deletion from pin category
    func delete(tracker: Tracker, from categoryTitle: String) {
        guard let categoryIndex = categories.firstIndex(where: { $0.title == categoryTitle }) else { return }
        
        let category = categories[categoryIndex]
        let updatedTrackers = category.trackers.filter { $0 != tracker }
        if updatedTrackers.isEmpty {
            categories.remove(at: categoryIndex)
        } else {
            let updatedCategory = TrackerCategory(id: category.id, title: category.title, trackers: updatedTrackers)
            categories[categoryIndex] = updatedCategory
        }
        
        saveCategories()
    }
}

// MARK: - TrackerCategoryStorage

extension UserDefaultsStorage {
    func fetchCategories(query: TrackerQuery) -> [TrackerCategory] {
        categories = loadCategories()
        var relevantCategories: [TrackerCategory] = []
        for category in categories {
            let relevantTrackers = filterTrackers(in: category, query: query)
            if !relevantTrackers.isEmpty {
                relevantCategories.append(TrackerCategory(id: category.id, title: category.title, trackers: relevantTrackers))
            }
        }
        return relevantCategories
    }
    
    func fetchCategoryTitles() -> [String] {
        return categories.compactMap { category in
            category.title != TrackerCategoryType.pinned.rawValue ? category.title : nil
        }
    }
    
    func create(category: TrackerCategory) { }
    
    func delete(category: TrackerCategory) { }
    
    private func filterTrackers(in category: TrackerCategory, query: TrackerQuery) -> [Tracker] {
        guard let weekday = query.date.weekday else { return [] }
        let relevantTrackers = category.trackers.filter { tracker in
            let matchesText = query.title.isEmpty || tracker.title.localizedCaseInsensitiveContains(query.title)
            let matchesDay = tracker.schedule.contains(where: { $0 == weekday })
            let singleEventDidCheck = tracker.type == .single && completionsCount(tracker: tracker) != 0 && !isCompleted(tracker: tracker, on: query.date)
            let pinnedTracker = category.title != "Закрепленные" && fetchTrackers(from: "Закрепленные").contains { $0 == tracker }
                        
            return matchesText && matchesDay && !singleEventDidCheck && !pinnedTracker
        }
        
        return relevantTrackers
    }
    
    private func completionsCount(tracker: Tracker) -> Int {
        return records.filter { record in
            record.trackerID == tracker.id
        }.count
    }
    
    private func isCompleted(tracker: Tracker, on date: Date) -> Bool {
        return records.contains { record in
            return record.trackerID == tracker.id && Calendar.current.isDate(record.date, inSameDayAs: date)
        }
    }
}


// MARK: - TrackerRecordStorage

extension UserDefaultsStorage {
    func fetchRecords(for tracker: Tracker) -> [TrackerRecord] {
        return records.filter { record in
            record.trackerID == tracker.id
        }
    }
    
    func create(record: TrackerRecord) {
        records.append(record)
        saveCompletedTrackers()
    }
    
    func delete(record: TrackerRecord) {
        records.removeAll { $0.trackerID == record.trackerID && Calendar.current.isDate($0.date, inSameDayAs: record.date) }
        saveCompletedTrackers()
    }
}
