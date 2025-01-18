//
//  TrackerStore.swift
//  Tracker
//
//  Created by Александр Торопов on 16.12.2024.
//

import CoreData

// MARK: - TrackerStoring

protocol TrackerStoring {
    func create(tracker: Tracker, in categoryTitle: String)
    func fetchTracker(with id: UUID) -> TrackerCoreData?
    func fetchCategoryTitle(tracker: Tracker) -> String
    func delete(tracker: Tracker)
    func update(tracker: Tracker, in categoryTitle: String)
    func update(tracker: Tracker, from originalCategoryTitle: String, to newCategoryTitle: String)
    func pin(tracker: Tracker)
    func unpin(tracker: Tracker)
}

// MARK: - TrackerStore

final class TrackerStore: DataStore, TrackerStoring {
    
    // MARK: - Public Methods
    
    func create(tracker: Tracker, in categoryTitle: String) {
        let trackerCategoryStore = TrackerCategoryStore(context: context)
        guard let categoryEntity = trackerCategoryStore.fetchCategory(title: categoryTitle) else {
            Logger.error("Failed to load category entity")
            return
        }
        
        let trackerEntity = TrackerCoreData(context: context)
        trackerEntity.trackerID = tracker.id
        trackerEntity.title = tracker.title
        trackerEntity.color = tracker.color
        trackerEntity.emoji = tracker.emoji
        trackerEntity.type = tracker.type.rawValue
        trackerEntity.schedule = tracker.schedule
        trackerEntity.sectionTitle = categoryTitle
        categoryEntity.addToTrackers(trackerEntity)
        
        do {
           try saveContext()
        } catch {
            Logger.error("Failed to create tracker: \(error.localizedDescription)")
        }
    }
    
    func fetchTracker(with id: UUID) -> TrackerCoreData? {
        let request = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerCoreData.trackerID), id as NSUUID)
        
        return try? context.fetch(request).first
    }
    
    func fetchCategoryTitle(tracker: Tracker) -> String {
        let trackerEntity = fetchTracker(with: tracker.id)
        let categoryEntity = trackerEntity?.categories.first(where: { $0.title != Constants.pinnedCategoryTitle })
        return categoryEntity?.title ?? ""
    }
    
    func update(tracker: Tracker, from originalCategoryTitle: String, to newCategoryTitle: String) {
        let trackerCategoryStore = TrackerCategoryStore(context: context)
        guard let originalCategoryEntity = trackerCategoryStore.fetchCategory(title: originalCategoryTitle),
              let newCategoryEntity = trackerCategoryStore.fetchCategory(title: newCategoryTitle),
              let trackerEntity = fetchTracker(with: tracker.id) else { return }
        
        trackerEntity.title = tracker.title
        trackerEntity.emoji = tracker.emoji
        trackerEntity.color = tracker.color
        trackerEntity.schedule = tracker.schedule
        trackerEntity.sectionTitle = newCategoryTitle

        if trackerEntity.categories.contains(originalCategoryEntity) {
            trackerEntity.categories.remove(originalCategoryEntity)
            originalCategoryEntity.removeFromTrackers(trackerEntity)
        }
        
        trackerEntity.categories.insert(newCategoryEntity)
        
        do {
            try saveContext()
        } catch {
            Logger.error("Failed to update tracker: \(error.localizedDescription)")
        }
    }

    func update(tracker: Tracker, in categoryTitle: String) {
        let trackerCategoryStore = TrackerCategoryStore(context: context)
        guard let categoryEntity = trackerCategoryStore.fetchCategory(title: categoryTitle),
              let trackerEntity = fetchTracker(with: tracker.id) else { return }
        
        trackerEntity.title = tracker.title
        trackerEntity.emoji = tracker.emoji
        trackerEntity.color = tracker.color
        trackerEntity.schedule = tracker.schedule
        
        if !trackerEntity.categories.contains(categoryEntity) {
            trackerEntity.categories.removeAll()
            trackerEntity.categories.insert(categoryEntity)
        }
        
        do {
            try saveContext()
        } catch {
            Logger.error("Failed to update tracker: \(error.localizedDescription)")
        }
    }

    
    func delete(tracker: Tracker) {
        guard let trackerEntity = fetchTracker(with: tracker.id) else { return }
        context.delete(trackerEntity)
        
        do {
           try saveContext()
        } catch {
            Logger.error("Failed to delete tracker: \(error.localizedDescription)")
        }
    }
    
    func pin(tracker: Tracker) {
        let trackerCategoryStore = TrackerCategoryStore(context: context)
        
        guard let pinnedCategoryEntity = trackerCategoryStore.fetchCategory(title: Constants.pinnedCategoryTitle),
              let trackerEntity = fetchTracker(with: tracker.id) else { return }
        
        trackerEntity.categories.insert(pinnedCategoryEntity)
        trackerEntity.sectionTitle = Constants.pinnedCategoryTitle
        
        do {
           try saveContext()
        } catch {
            Logger.error("Failed to pin tracker: \(error.localizedDescription)")
        }
    }
    
    func unpin(tracker: Tracker) {
        let trackerCategoryStore = TrackerCategoryStore(context: context)
        
        guard let pinnedCategoryEntity = trackerCategoryStore.fetchCategory(title: Constants.pinnedCategoryTitle),
              let trackerEntity = fetchTracker(with: tracker.id) else { return }
        
        pinnedCategoryEntity.trackers.remove(trackerEntity)
        trackerEntity.sectionTitle = trackerEntity.categories.first?.title ?? ""
        
        do {
           try saveContext()
        } catch {
            Logger.error("Failed to unpin tracker: \(error.localizedDescription)")
        }
    }
}
