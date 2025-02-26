//
//  TrackerStore.swift
//  Tracker
//
//  Created by Александр Торопов on 16.12.2024.
//

import CoreData

// MARK: - TrackerStoring

protocol TrackerStoring {
    @discardableResult
    func create(tracker: Tracker, in categoryTitle: String) -> TrackerCoreData?
    
    @discardableResult
    func update(tracker: Tracker, in categoryTitle: String) -> TrackerCoreData?
    
    @discardableResult
    func update(tracker: Tracker, from originalCategoryTitle: String, to newCategoryTitle: String) -> TrackerCoreData?
    
    func fetchTracker(with id: UUID) -> TrackerCoreData?
    func fetchTrackers(on date: Date) -> [Tracker]
    func fetchTrackersCount() -> Int
    func fetchCategoryTitle(tracker: Tracker) -> String
    func delete(tracker: Tracker)
    func pin(tracker: Tracker)
    func unpin(tracker: Tracker)
}

// MARK: - TrackerStore

final class TrackerStore: DataStore, TrackerStoring {
    
    // MARK: - Initializer
    
    override init(coreDataStack: CoreDataStack) {
        super.init(coreDataStack: coreDataStack)
        
        // Correct localization of the pinned category
        let _ = TrackerCategoryStore(coreDataStack: coreDataStack)
    }
    
    // MARK: - Public Methods
    
    @discardableResult
    func create(tracker: Tracker, in categoryTitle: String) -> TrackerCoreData? {
        let trackerCategoryStore = TrackerCategoryStore(coreDataStack: coreDataStack)
        guard let categoryEntity = trackerCategoryStore.fetchCategory(title: categoryTitle) else {
            Logger.error("Failed to load category entity")
            return nil
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
        
        coreDataStack.saveContext()
        
        return trackerEntity
    }
    
    func fetchTracker(with id: UUID) -> TrackerCoreData? {
        let request = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerCoreData.trackerID), id as NSUUID)
        
        return try? context.fetch(request).first
    }
    
    func fetchTrackers(on date: Date) -> [Tracker] {
        let bitMask = date.weekday?.bitMask ?? 0
        let request = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "%K & %@ != 0 AND ((%K == %@ AND (ANY %K.date == %@ OR NONE %K.date != nil)) OR %K == %@)", 
                                        #keyPath(TrackerCoreData.scheduleMask), NSNumber(value: bitMask),
                                        #keyPath(TrackerCoreData.type), TrackerType.single.rawValue,
                                        #keyPath(TrackerCoreData.records), date as NSDate,
                                        #keyPath(TrackerCoreData.records),
                                        #keyPath(TrackerCoreData.type), TrackerType.regular.rawValue)
        
        let trackerEntities = (try? context.fetch(request)) ?? []
        let trackers = trackerEntities.compactMap { $0.mapToDomainModel() }
        return trackers
    }
    
    func fetchCategoryTitle(tracker: Tracker) -> String {
        let trackerEntity = fetchTracker(with: tracker.id)
        let categoryEntity = trackerEntity?.categories.first(where: { $0.title != Constants.pinnedCategoryTitle })
        return categoryEntity?.title ?? ""
    }
    
    func fetchTrackersCount() -> Int {
        let request = TrackerCoreData.fetchRequest()
        do {
            let entities = try context.fetch(request)
            return entities.count
        } catch {
            Logger.error("Failed to fetch trackers count")
            return 0
        }
    }

    @discardableResult
    func update(tracker: Tracker, in categoryTitle: String) -> TrackerCoreData? {
        let trackerCategoryStore = TrackerCategoryStore(coreDataStack: coreDataStack)
        guard let categoryEntity = trackerCategoryStore.fetchCategory(title: categoryTitle),
              let trackerEntity = fetchTracker(with: tracker.id) else {
            return nil
        }
        
        trackerEntity.title = tracker.title
        trackerEntity.emoji = tracker.emoji
        trackerEntity.color = tracker.color
        
        if Set(trackerEntity.schedule) != Set(tracker.schedule) {
            let deletedWeekdays = trackerEntity.schedule.filter { oldWeekday in
                !tracker.schedule.contains(where: { $0 == oldWeekday })
            }
            
            let recordStore = TrackerRecordStore(coreDataStack: coreDataStack)
            deletedWeekdays.forEach{ recordStore.deleteRecord(tracker: tracker, weekday: $0) }
        }
        
        trackerEntity.schedule = tracker.schedule
        
        if !trackerEntity.categories.contains(categoryEntity) {
            trackerEntity.categories.removeAll()
            trackerEntity.categories.insert(categoryEntity)
        }
        
        coreDataStack.saveContext()
        return trackerEntity
    }
    
    @discardableResult
    func update(tracker: Tracker, from originalCategoryTitle: String, to newCategoryTitle: String) -> TrackerCoreData? {
        let trackerCategoryStore = TrackerCategoryStore(coreDataStack: coreDataStack)
        guard let originalCategoryEntity = trackerCategoryStore.fetchCategory(title: originalCategoryTitle),
              let newCategoryEntity = trackerCategoryStore.fetchCategory(title: newCategoryTitle),
              let trackerEntity = fetchTracker(with: tracker.id) else {
            return nil
        }
        
        trackerEntity.title = tracker.title
        trackerEntity.emoji = tracker.emoji
        trackerEntity.color = tracker.color
        trackerEntity.sectionTitle = newCategoryTitle
        
        if Set(trackerEntity.schedule) != Set(tracker.schedule) {
            let deletedWeekdays = trackerEntity.schedule.filter { oldWeekday in
                !tracker.schedule.contains(where: { $0 == oldWeekday })
            }
            
            let recordStore = TrackerRecordStore(coreDataStack: coreDataStack)
            deletedWeekdays.forEach{ recordStore.deleteRecord(tracker: tracker, weekday: $0) }
        }
        
        trackerEntity.schedule = tracker.schedule

        if trackerEntity.categories.contains(originalCategoryEntity) {
            trackerEntity.categories.remove(originalCategoryEntity)
            originalCategoryEntity.removeFromTrackers(trackerEntity)
        }
        
        trackerEntity.categories.insert(newCategoryEntity)
        
        coreDataStack.saveContext()
        return trackerEntity
    }

    func delete(tracker: Tracker) {
        guard let trackerEntity = fetchTracker(with: tracker.id) else { return }
        context.delete(trackerEntity)
        
        coreDataStack.saveContext()
    }
    
    func pin(tracker: Tracker) {
        let trackerCategoryStore = TrackerCategoryStore(coreDataStack: coreDataStack)
        
        guard let pinnedCategoryEntity = trackerCategoryStore.fetchCategory(title: Constants.pinnedCategoryTitle),
              let trackerEntity = fetchTracker(with: tracker.id) else { return }
        
        trackerEntity.categories.insert(pinnedCategoryEntity)
        trackerEntity.sectionTitle = Constants.pinnedCategoryTitle
        
        coreDataStack.saveContext()
    }
    
    func unpin(tracker: Tracker) {
        let trackerCategoryStore = TrackerCategoryStore(coreDataStack: coreDataStack)
        
        guard let pinnedCategoryEntity = trackerCategoryStore.fetchCategory(title: Constants.pinnedCategoryTitle),
              let trackerEntity = fetchTracker(with: tracker.id) else { return }
        
        pinnedCategoryEntity.trackers.remove(trackerEntity)
        trackerEntity.sectionTitle = trackerEntity.categories.first?.title ?? ""
        
        coreDataStack.saveContext()
    }
}
