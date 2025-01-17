//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Александр Торопов on 16.12.2024.
//

import CoreData

// MARK: - TrackerRecordStoring

protocol TrackerRecordStoring {
    func fetchRecords(for tracker: Tracker) -> [TrackerRecord]
    func fetchRecordsAmount(for tracker: Tracker) -> Int
    func create(record: TrackerRecord)
    func deleteRecord(tracker: Tracker, date: Date)
}

// MARK: - TrackerRecordStore

final class TrackerRecordStore: DataStore, TrackerRecordStoring {
    func fetchRecords(for tracker: Tracker) -> [TrackerRecord] {
        let request = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerRecordCoreData.tracker.trackerID), tracker.id as NSUUID
        )
        
        do {
            let recordEntities = try context.fetch(request)
            return recordEntities.map { $0.mapToDomainModel() }
        } catch {
            Logger.error("Failed to fetch tracker records: \(error.localizedDescription)")
            return []
        }
    }
    
    func fetchRecordsAmount(for tracker: Tracker) -> Int {
        let request = NSFetchRequest<NSNumber>(entityName: "TrackerRecordCoreData")
        request.resultType = .countResultType
        request.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerRecordCoreData.tracker.trackerID), tracker.id as NSUUID
        )
        
        do {
            let result = try context.fetch(request)
            return result.first?.intValue ?? 0
        } catch {
            Logger.error("Failed to fetch record count: \(error.localizedDescription)")
            return -1
        }
    }
    
    func create(record: TrackerRecord) {
        let request = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerCoreData.trackerID), record.trackerID as NSUUID
        )
        
        guard let trackerEntity = try? context.fetch(request).first else {
            Logger.error("Failed to create record")
            return
        }
        
        let recordEntity = TrackerRecordCoreData(context: context)
        recordEntity.date = record.date
        recordEntity.tracker = trackerEntity
        
        do {
           try saveContext()
        } catch {
            Logger.error("Failed to create record: \(error.localizedDescription)")
        }
    }
    
    func deleteRecord(tracker: Tracker, date: Date) { 
        let request = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(
            format: "%K == %@ && %K == %@",
            #keyPath(TrackerRecordCoreData.tracker.trackerID), tracker.id as NSUUID,
            #keyPath(TrackerRecordCoreData.date), date as NSDate
        )
        
        do {
            let recordEntities = try context.fetch(request)
            recordEntities.forEach { context.delete($0) }
        } catch {
            Logger.error("Failed to delete record: \(error.localizedDescription)")
        }
    }
}
