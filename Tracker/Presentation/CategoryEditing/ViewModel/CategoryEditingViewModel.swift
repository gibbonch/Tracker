//
//  CategoryEditingViewModel.swift
//  Tracker
//
//  Created by Александр Торопов on 18.01.2025.
//

import Foundation

protocol CategoryEditingViewModel: AnyObject {
    var headerTitle: String { get }
    var title: String? { get }
    var isCategoryCreationAllowed: Bool { get }
    var onTitleChangeState: ((String) -> Void)? { get set }
    func titleDidChange(_ newTitle: String)
    func createCategory(_ completion: @escaping () -> Void)
}

final class DefaultCategoryEditingViewModel: CategoryEditingViewModel {
    let headerTitle: String
    var onTitleChangeState: ((String) -> Void)?
    private(set) var title: String?
    private let categoryStore: TrackerCategoryStoring
    
    private let isNewCategory: Bool
    private let originalTitle: String?
    
    var isCategoryCreationAllowed: Bool {
        return !(title?.isEmpty ?? true)
    }
    
    init(title: String?, categoryStore: TrackerCategoryStoring) {
        self.title = title
        self.categoryStore = categoryStore
        
        if let title = title {
            self.headerTitle = "Редактирование категории"
            self.isNewCategory = false
            self.originalTitle = title
        } else {
            self.headerTitle = "Новая категория"
            self.isNewCategory = true
            self.originalTitle = nil
        }
    }
    
    func titleDidChange(_ newTitle: String) {
        title = newTitle
        onTitleChangeState?(newTitle)
    }
    
    func createCategory(_ completion: @escaping () -> Void) {
        guard let title = title, !title.isEmpty else { return }
        
        if isNewCategory {
            categoryStore.createCategory(title: title)
        } else if let originalTitle = originalTitle {
            categoryStore.updateCategory(title: originalTitle, newTitle: title)
        }
        
        completion()
    }
}

