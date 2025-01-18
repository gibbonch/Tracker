//
//  TrackerCategoriesViewModel.swift
//  Tracker
//
//  Created by Александр Торопов on 17.01.2025.
//

import Foundation

// MARK: - TrackerCategoriesViewModel

protocol TrackerCategoriesViewModel: AnyObject {
    var onChangeExistingCategories: Binding<(insertedIndices: [Int], deletedIndices: [Int])>? { get set }
    var onChangeSelectedCategory: Binding<String?>? { get set }
    var categoryTitles: [String] { get }
    
    func isSelectedCategory(at indexPath: IndexPath) -> Bool
    func didSelectCategory(at indexPath: IndexPath)
    func deleteCategory(at indexPath: IndexPath)
    func createCategoryEditingViewModel(indexPath: IndexPath?) -> any CategoryEditingViewModel
}

// MARK: - DefaultTrackerCategoriesViewModel

final class DefaultTrackerCategoriesViewModel: TrackerCategoriesViewModel {

    // MARK: - Properties
    
    var onChangeSelectedCategory: Binding<String?>?
    var onChangeExistingCategories: Binding<(insertedIndices: [Int], deletedIndices: [Int])>?
    private(set) var categoryTitles: [String] = []
    
    private var selectedCategory: String?
    private let categoryStore: TrackerCategoryStoring
    private let categoryProvider: TrackerCategoryProvider
    
    // MARK: - Initializer
    
    init(selectedCategory: String?, categoryStore: TrackerCategoryStoring, categoryProvider: TrackerCategoryProvider) {
        self.selectedCategory = selectedCategory
        self.categoryStore = categoryStore
        self.categoryProvider = categoryProvider
        categoryProvider.delegate = self
    }
    
    // MARK: - Public Methods
    
    func isSelectedCategory(at indexPath: IndexPath) -> Bool {
        categoryTitles[indexPath.row] == selectedCategory
    }
    
    func didSelectCategory(at indexPath: IndexPath) {
        selectedCategory = categoryTitles[indexPath.row]
        onChangeSelectedCategory?(selectedCategory)
    }
    
    func deleteCategory(at indexPath: IndexPath) {
        categoryStore.deleteCategory(title: categoryTitles[indexPath.row])
        onChangeSelectedCategory?(nil)
    }
    
    func createCategoryEditingViewModel(indexPath: IndexPath?) -> any CategoryEditingViewModel {
        if let indexPath {
            return DefaultCategoryEditingViewModel(title: categoryTitles[indexPath.row], categoryStore: categoryStore)
        } else {
            return DefaultCategoryEditingViewModel(title: nil, categoryStore: categoryStore)
        }
    }
}

// MARK: - TrackerCategoryProviderDelegate

extension DefaultTrackerCategoriesViewModel: TrackerCategoryProviderDelegate {
    func didUpdateFetchedCategories(_ categories: [String]) {
        let oldCategories = categoryTitles
        let newCategories = categories
        
        let insertedIndices = newCategories.enumerated().compactMap { index, element in
            oldCategories.contains(element) ? nil : index
        }
        
        let deletedIndices = oldCategories.enumerated().compactMap { index, element in
            newCategories.contains(element) ? nil : index
        }
        
        categoryTitles = categories
        
        onChangeExistingCategories?((insertedIndices, deletedIndices))
    }
}
