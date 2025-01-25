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

// MARK: - TrackerProviding

protocol TrackerProviding: AnyObject {
    var delegate: TrackerProviderDelegate? { get set }
    func updateTrackerQuery(_ trackerQuery: TrackerQuery)
}

// MARK: - TrackerProvider

final class TrackerProvider: NSObject, TrackerProviding {
    
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
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
    }
    
    // MARK: - Public Methods
    
    func updateTrackerQuery(_ trackerQuery: TrackerQuery) {
        var predicates: [NSPredicate] = []
        
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
            format: "((%K == %@ AND (ANY %K.date == %@ OR NONE %K.date != nil)) OR %K == %@)",
            #keyPath(TrackerCoreData.type), TrackerType.single.rawValue,
            #keyPath(TrackerCoreData.records), trackerQuery.date as NSDate,
            #keyPath(TrackerCoreData.records),
            #keyPath(TrackerCoreData.type), TrackerType.regular.rawValue
        )
        
        predicates.append(contentsOf: [schedulePredicate, searchTextPredicate, completionsPredicate])
        
        if trackerQuery.filter == .active {
            let activeTrackersPredicate = NSPredicate(
                format: "SUBQUERY(%K, $record, $record.date == %@).@count == 0",
                #keyPath(TrackerCoreData.records), trackerQuery.date as NSDate
            )
            
            predicates.append(activeTrackersPredicate)
        } else if trackerQuery.filter == .completed {
            let completedTrackersPredicate = NSPredicate(
                format: "ANY %K.date == %@",
                #keyPath(TrackerCoreData.records), trackerQuery.date as NSDate
            )
            
            predicates.append(completedTrackersPredicate)
        }
        
        let trackersPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
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
