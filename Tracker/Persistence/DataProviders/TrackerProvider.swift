//
//  TrackerProvider.swift
//  Tracker
//
//  Created by Александр Торопов on 27.12.2024.
//

import CoreData

// MARK: - TrackerProviderDelegate

protocol TrackerProviderDelegate: AnyObject {
    func didUpdateFetchedTrackers(_ categories: [TrackerCategory])
}

// MARK: - TrackerProvider

final class TrackerProvider: NSObject {
    
    // MARK: - Properties
    
    weak var delegate: TrackerProviderDelegate?
    private let context: NSManagedObjectContext
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let request = TrackerCoreData.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: #keyPath(TrackerCoreData.sectionTitle), ascending: true),
            NSSortDescriptor(key: #keyPath(TrackerCoreData.title), ascending: true)
        ]
        
        let controller = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: #keyPath(TrackerCoreData.sectionTitle),
            cacheName: nil
        )
        
        controller.delegate = self
        return controller
    }()
    
    private var fetchedTrackers: [TrackerCategory]? {
        guard let sections = fetchedResultsController.sections else { return nil }
        
        var trackerCategories = sections.map { section in
            let trackers = section.objects as? [TrackerCoreData] ?? []
            return TrackerCategory(
                title: section.name,
                trackers: trackers.compactMap { $0.mapToDomainModel() }
            )
        }
        
        if let pinnedCategoryIndex = trackerCategories.firstIndex(where: { $0.title == Constants.pinnedCategoryTitle }) {
            let pinnedCategory = trackerCategories.remove(at: pinnedCategoryIndex)
            trackerCategories.insert(pinnedCategory, at: 0)
        }
        
        return trackerCategories
    }
    
    // MARK: - Initializer
    
    init(store: DataStore) {
        self.context = store.context
        super.init()
    }
    
    // MARK: - Public Methods
    
    func updateTrackerQuery(_ trackerQuery: TrackerQuery) {
        let schedulePredicate = NSPredicate(
            format: "%K & %@ != 0 OR %K == %@",
            #keyPath(TrackerCoreData.scheduleMask), NSNumber(value: trackerQuery.date.weekday?.bitMask ?? 0),
            #keyPath(TrackerCoreData.type), TrackerType.single.rawValue
        )
        
        let searchTextPredicate = NSPredicate(
            format: "%K CONTAINS[cd] %@ OR %@ == ''",
            #keyPath(TrackerCoreData.title), trackerQuery.title,
            trackerQuery.title
        )
        
        let completionsPredicate = NSPredicate(
            format: "(%K == %@ AND (ANY %K.date == %@ OR NONE %K.date != nil)) OR %K == %@",
            #keyPath(TrackerCoreData.type), TrackerType.single.rawValue,
            #keyPath(TrackerCoreData.records), trackerQuery.date as NSDate,
            #keyPath(TrackerCoreData.records),
            #keyPath(TrackerCoreData.type), TrackerType.regular.rawValue
        )
        
        let trackersPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [schedulePredicate, searchTextPredicate, completionsPredicate])
        fetchedResultsController.fetchRequest.predicate = trackersPredicate
        
        try? fetchedResultsController.performFetch()
        delegate?.didUpdateFetchedTrackers(fetchedTrackers ?? [])
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TrackerProvider: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdateFetchedTrackers(fetchedTrackers ?? [])
    }
}
