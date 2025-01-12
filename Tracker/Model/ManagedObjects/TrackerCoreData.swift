//
//  TrackerCoreData+CoreDataClass.swift
//  Tracker
//
//  Created by Александр Торопов on 16.12.2024.
//
//

import UIKit
import CoreData

@objc(TrackerCoreData)
public class TrackerCoreData: NSManagedObject, Identifiable {
    @NSManaged public var trackerID: UUID
    @NSManaged public var color: UIColor
    @NSManaged public var emoji: String
    @NSManaged public var title: String
    @NSManaged public var type: String
    @NSManaged public var scheduleMask: Int16
    @NSManaged public var sectionTitle: String
    
    @NSManaged public var categories: Set<TrackerCategoryCoreData>
    @NSManaged public var records: Set<TrackerRecordCoreData>
    
    var schedule: [Weekday] {
        get { Weekday.from(bitMask: scheduleMask) }
        set { scheduleMask = newValue.reduce(0) { $0 | $1.bitMask } }
    }
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrackerCoreData> {
        return NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
    }
    
    @objc(addCategoriesObject:)
    @NSManaged public func addToCategories(_ value: TrackerCategoryCoreData)

    @objc(removeCategoriesObject:)
    @NSManaged public func removeFromCategories(_ value: TrackerCategoryCoreData)
}

// MARK: - Mapping

extension TrackerCoreData {
    func mapToDomainModel() -> Tracker? {
        guard let type = TrackerType(rawValue: type) else { return nil }
        return Tracker(
            id: trackerID,
            type: type,
            title: title,
            schedule: schedule,
            color: color,
            emoji: emoji
        )
    }
}
