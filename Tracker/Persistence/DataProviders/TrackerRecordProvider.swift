//
//  TrackerRecordProvider.swift
//  Tracker
//
//  Created by Александр Торопов on 26.01.2025.
//

import Foundation
import CoreData

protocol TrackerRecordProviderDelegate: AnyObject {
    func didChangeTrackerRecords(_ records: [TrackerRecord])
}

final class TrackerRecordProvider: NSObject {
    weak var delegate: TrackerRecordProviderDelegate?
    let context: NSManagedObjectContext
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData> = {
        let request = TrackerRecordCoreData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(TrackerRecordCoreData.date), ascending: true)]
        
        let controller = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        
        return controller
    }()
    
    init(coreDataStack: CoreDataStack = CoreDataStack.shared) {
        context = coreDataStack.context
        super.init()
    }
    
    func performFetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            Logger.error("Failed to perform fetch with error: \(error.localizedDescription)")
        }
    }
}

extension TrackerRecordProvider: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        guard let objects = controller.fetchedObjects else {
            return
        }
        
        let records = objects.compactMap { object in
            let recordEntity = object as? TrackerRecordCoreData
            let record = recordEntity?.mapToDomainModel()
            return record
        }
        
        delegate?.didChangeTrackerRecords(records)
    }
}
