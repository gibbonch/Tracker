//
//  TrackerCoreData+CoreDataClass.swift
//  Tracker
//
//  Created by Александр Торопов on 15.12.2024.
//
//

import Foundation
import CoreData

public class TrackerCoreData: NSManagedObject, Identifiable {
    @NSManaged public var type: NSObject?
    @NSManaged public var title: String?
    @NSManaged public var schedule: NSObject?
    @NSManaged public var color: NSObject?
    @NSManaged public var emoji: String?
    @NSManaged public var category: TrackerCategoryCoreData?
    @NSManaged public var records: NSSet?
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrackerCoreData> {
        return NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
    }
    
    @objc(addRecordsObject:)
    @NSManaged public func addToRecords(_ value: TrackerRecordCoreData)
    
    @objc(removeRecordsObject:)
    @NSManaged public func removeFromRecords(_ value: TrackerRecordCoreData)
    
    @objc(addRecords:)
    @NSManaged public func addToRecords(_ values: NSSet)
    
    @objc(removeRecords:)
    @NSManaged public func removeFromRecords(_ values: NSSet)
}
