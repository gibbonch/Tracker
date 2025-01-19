//
//  CoreDataStack.swift
//  Tracker
//
//  Created by Александр Торопов on 15.12.2024.
//

import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    static let modelName = "TrackerModel"
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataStack.modelName)
        container.loadPersistentStores { _, error in
            if let error {
                Logger.error("Failed to load persistent stores (\(error.localizedDescription))")
            }
        }
        return container
    }()
    
    init() {
        ValueTransformer.setValueTransformer(UIColorTransformer(), forName: .uiColorTransformerName)
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            Logger.error("Failed to save context (\(error.localizedDescription))")
        }
    }
}
