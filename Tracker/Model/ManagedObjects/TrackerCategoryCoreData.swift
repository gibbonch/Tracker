//
//  TrackerCategoryCoreData+CoreDataClass.swift
//  Tracker
//
//  Created by Александр Торопов on 16.12.2024.
//
//

import CoreData

@objc(TrackerCategoryCoreData)
public class TrackerCategoryCoreData: NSManagedObject, Identifiable {
    @NSManaged public var title: String
    @NSManaged public var trackers: Set<TrackerCoreData>
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrackerCategoryCoreData> {
        return NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
    }
    
    @objc(addTrackersObject:)
    @NSManaged public func addToTrackers(_ value: TrackerCoreData)

    @objc(removeTrackersObject:)
    @NSManaged public func removeFromTrackers(_ value: TrackerCoreData)
}

// MARK: - Mapping

extension TrackerCategoryCoreData {
    func mapToDomainModel() -> TrackerCategory {
        TrackerCategory(
            title: title,
            trackers: trackers.compactMap { $0.mapToDomainModel() }
        )
    }
}
