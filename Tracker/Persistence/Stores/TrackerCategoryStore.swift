//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Александр Торопов on 16.12.2024.
//

import CoreData

// MARK: - TrackerCategoryStoring

protocol TrackerCategoryStoring {
    func createCategory(title: String) -> TrackerCategoryCoreData?
    func fetchCategory(title: String) -> TrackerCategoryCoreData?
    func updateCategory(title: String, newTitle: String)
    func deleteCategory(title: String)
}

// MARK: - TrackerCategoryStore

final class TrackerCategoryStore: DataStore, TrackerCategoryStoring {
    
    // MARK: - Initializer
        
    override init(coreDataStack: CoreDataStack) {
        super.init(coreDataStack: coreDataStack)
        createPinnedTrackerCategory()
    }
    
    // MARK: - Public Methods
    
    @discardableResult
    func createCategory(title: String) -> TrackerCategoryCoreData? {
        if let _ = fetchCategory(title: title) {
            return nil
        }
        
        let categoryEntity = TrackerCategoryCoreData(context: context)
        categoryEntity.title = title
        
        coreDataStack.saveContext()
        
        return categoryEntity
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
        
        categoryEntity?.trackers.forEach { $0.sectionTitle = newTitle }
        
        coreDataStack.saveContext()
    }
    
    func deleteCategory(title: String) {
        guard let categoryEntity = fetchCategory(title: title) else { return }
        context.delete(categoryEntity)
        
        coreDataStack.saveContext()
    }
    
    // MARK: - Private Methods
    
    private func createPinnedTrackerCategory() {
        if let _ = fetchCategory(title: Constants.pinnedCategoryTitle) {
            return
        }
        createCategory(title: Constants.pinnedCategoryTitle)
    }
}
