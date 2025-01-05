//
//  CoreDataStack.swift
//  Tracker
//
//  Created by Александр Торопов on 15.12.2024.
//

import CoreData

final class CoreDataStack {
    static let shared = CoreDataStack()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TrackerModel")
        container.loadPersistentStores { _, error in
            if let error {
                Logger.error("Failed to load persistent stores (\(error.localizedDescription))")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext { persistentContainer.viewContext }
    
    private init() {
        ValueTransformer.setValueTransformer(UIColorTransformer(), forName: .uiColorTransformerName)
    }
}
