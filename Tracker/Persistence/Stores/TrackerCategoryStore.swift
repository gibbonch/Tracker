//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Александр Торопов on 16.12.2024.
//

import CoreData

// MARK: - TrackerCategoryStoring

protocol TrackerCategoryStoring {
    @discardableResult
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
        let pinnedCategoryTitleForCurrentLocale = Constants.pinnedCategoryTitle
        let locales = Bundle.main.localizations
        
        let key = "pinnedCategory.title"
        
        for locale in locales {
            guard let path = Bundle.main.path(forResource: locale, ofType: "lproj"),
                  let bundle = Bundle(path: path) else {
                continue
            }
            
            let title = bundle.localizedString(forKey: key, value: nil, table: nil)
            
            if let _ = fetchCategory(title: title) {
                if pinnedCategoryTitleForCurrentLocale != title {
                    updateCategory(title: title, newTitle: pinnedCategoryTitleForCurrentLocale)
                }
                return
            }
        }
        
        createCategory(title: Constants.pinnedCategoryTitle)
    }
}
