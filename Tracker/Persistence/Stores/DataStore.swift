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
    let coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        context = coreDataStack.context
        super.init()
    }
}
