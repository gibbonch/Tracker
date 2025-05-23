//
//  TrackerCategoryProvider.swift
//  Tracker
//
//  Created by Александр Торопов on 29.12.2024.
//

import CoreData

// MARK: - TrackerCategoryProviderDelegate

protocol TrackerCategoryProviderDelegate: AnyObject {
    func didUpdateFetchedCategories(_ categories: [String])
}

// MARK: - TrackerProvider

final class TrackerCategoryProvider: NSObject {
    
    // MARK: - Properties
    
    weak var delegate: TrackerCategoryProviderDelegate? {
        didSet {
            try? fetchedResultsController.performFetch()
            delegate?.didUpdateFetchedCategories(fetchedCategories ?? [])
        }
    }
    private let context: NSManagedObjectContext
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "%K != %@", #keyPath(TrackerCategoryCoreData.title), Constants.pinnedCategoryTitle)
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(TrackerCategoryCoreData.title), ascending: true)]
        
        let controller = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        controller.delegate = self
        
        return controller
    }()
    
    private var fetchedCategories: [String]? {
        guard let fetchedObjects = fetchedResultsController.fetchedObjects else { return nil }
        return fetchedObjects.map { $0.title }
    }
    
    // MARK: - Initializer
    
    init(store: DataStore) {
        self.context = store.context
        super.init()
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TrackerCategoryProvider: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdateFetchedCategories(fetchedCategories ?? [])
    }
}
