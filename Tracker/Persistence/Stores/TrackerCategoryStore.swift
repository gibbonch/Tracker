//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Александр Торопов on 16.12.2024.
//

import CoreData

// MARK: - TrackerCategoryStoring

protocol TrackerCategoryStoring: DataStore {
    func createCategory(title: String)
    func fetchCategory(title: String) -> TrackerCategoryCoreData?
    func updateCategory(title: String, newTitle: String)
    func deleteCategory(title: String)
}

// MARK: - TrackerCategoryStore

final class TrackerCategoryStore: DataStore, TrackerCategoryStoring {
    
    // MARK: - Initializer
        
    override init(context: NSManagedObjectContext = CoreDataStack.shared.persistentContainer.viewContext) {
        super.init()
        createPinnedTrackerCategory()
    }
    
    // MARK: - Public Methods
    
    func createCategory(title: String) {
        if let _ = fetchCategory(title: title) {
            return
        }
        
        let categoryEntity = TrackerCategoryCoreData(context: context)
        categoryEntity.title = title
        
        do {
           try saveContext()
        } catch {
            Logger.error("Failed to create category: \(error.localizedDescription)")
        }
    }
    
    func fetchCategory(title: String) -> TrackerCategoryCoreData? {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerCategoryCoreData.title), title
        )
        
        return try? context.fetch(request).first
    }
    
    func updateCategory(title: String, newTitle: String) {
        let categoryEntity = fetchCategory(title: title)
        categoryEntity?.title = newTitle
        
        do {
           try saveContext()
        } catch {
            Logger.error("Failed to update category: \(error.localizedDescription)")
        }
    }
    
    func deleteCategory(title: String) {
        guard let categoryEntity = fetchCategory(title: title) else { return }
        context.delete(categoryEntity)
        
        do {
           try saveContext()
        } catch {
            Logger.error("Failed to delete category: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Private Methods
    
    private func createPinnedTrackerCategory() {
        if let _ = fetchCategory(title: Constants.pinnedCategoryTitle) {
            return
        }
        createCategory(title: Constants.pinnedCategoryTitle)
    }
}
