//
//  DataStore.swift
//  Tracker
//
//  Created by Александр Торопов on 17.12.2024.
//

import Foundation
import CoreData

class DataStore: NSObject {    
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
        super.init()
    }
    
    func saveContext() throws {
        do {
            try context.save()
        } catch {
            context.rollback()
            throw error
        }
    }
}
