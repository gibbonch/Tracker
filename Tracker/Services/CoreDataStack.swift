//
//  CoreDataStack.swift
//  Tracker
//
//  Created by Александр Торопов on 15.12.2024.
//

import CoreData

final class CoreDataStack {
    static let shared = CoreDataStack()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TrackerModel")
        
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load persistent stores: \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    private init() { }
}

extension CoreDataStack {
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func saveContextView() {
        do {
            try viewContext.save()
        } catch {
            viewContext.rollback()
        }
    }
}
