//
//  TestCoreDataStack.swift
//  TrackerTests
//
//  Created by Александр Торопов on 19.01.2025.
//

@testable import Tracker
import CoreData

final class TestCoreDataStack: CoreDataStack {
    override init() {
        super.init()
        
        let container = NSPersistentContainer(name: CoreDataStack.modelName)
        
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { description, error in
          if let error = error as NSError? {
            assertionFailure("Unresolved error \(error), \(error.userInfo)")
          }
        }
        
        persistentContainer = container
    }
}
