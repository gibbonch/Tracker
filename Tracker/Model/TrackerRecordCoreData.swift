//
//  TrackerRecordCoreData+CoreDataClass.swift
//  Tracker
//
//  Created by Александр Торопов on 15.12.2024.
//
//

import Foundation
import CoreData

@objc(TrackerRecordCoreData)
public class TrackerRecordCoreData: NSManagedObject, Identifiable {
    @NSManaged public var date: Date?
    @NSManaged public var tracker: TrackerCoreData?
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrackerRecordCoreData> {
        return NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
    }
}
