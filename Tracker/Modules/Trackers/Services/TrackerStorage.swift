//
//  TrackerBuilder.swift
//  Tracker
//
//  Created by Александр Торопов on 09.11.2024.
//

import Foundation

protocol DataStorage {
    func saveCategories(_ categories: [TrackerCategory])
    func loadCategories() -> [TrackerCategory]
}

final class TrackerUserDefaultsDataStorage: DataStorage {
    
    // MARK: - Properties
    private let userDefaults = UserDefaults.standard
    private let categoriesStorageKey = "trackerCategories"
    private let completedTrackersStorageKey = "completedTrackers"
    
    // MARK: - Category Methods
    func saveCategories(_ categories: [TrackerCategory]) {
        do {
            let data = try JSONEncoder().encode(categories)
            userDefaults.set(data, forKey: categoriesStorageKey)
        } catch {
            print("Failed to save categories: \(error)")
        }
    }
    
    func loadCategories() -> [TrackerCategory] {
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
    
    // MARK: - Completed Trackers Methods
    func saveCompletedTrackers(_ completedTrackers: [TrackerRecord]) {
        do {
            let data = try JSONEncoder().encode(completedTrackers)
            userDefaults.set(data, forKey: completedTrackersStorageKey)
        } catch {
            print("Failed to save completed trackers: \(error)")
        }
    }
    
    func loadCompletedTrackers() -> [TrackerRecord] {
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

