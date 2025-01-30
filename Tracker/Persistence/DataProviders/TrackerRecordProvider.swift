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
    
    // MARK: - Properties
    
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
    
    private var records: [TrackerRecord] {
        guard let objects = fetchedResultsController.fetchedObjects else {
            return []
        }
        
        let records = objects.compactMap { entity in
            let record = entity.mapToDomainModel()
            return record
        }
        return records
    }
    
    // MARK: - Initializer
    
    init(coreDataStack: CoreDataStack = CoreDataStack.shared) {
        context = coreDataStack.context
        super.init()
    }
    
    // MARK: - Public Methods
    
    func performFetch() {
        do {
            try fetchedResultsController.performFetch()
            delegate?.didChangeTrackerRecords(records)
        } catch {
            Logger.error("Failed to perform fetch with error: \(error.localizedDescription)")
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TrackerRecordProvider: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        delegate?.didChangeTrackerRecords(records)
    }
}
