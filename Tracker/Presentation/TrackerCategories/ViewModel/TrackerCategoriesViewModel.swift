//
//  TrackerCategoriesViewModel.swift
//  Tracker
//
//  Created by Александр Торопов on 17.01.2025.
//

import Foundation

protocol TrackerCategoriesViewModel {
    var onChangeExistingCategories: Binding<[String]>? { get set }
    
    func getCategoryTitles() -> [String]
    func getSelectedCategory() -> String?
    func didSelectCategory(at indexPath: IndexPath)
    func willDismissViewController()
}

final class DefaultTrackerCategoriesViewModel: TrackerCategoriesViewModel {
    
    var onChangeExistingCategories: Binding<[String]>?
    
    private var selectedCategory: String?
    private var categoryTitles: [String] = []
    private let trackerCategoryStorage: TrackerCategoryStoring
    private let trackerCategoryProvider: TrackerCategoryProvider
    
    init(selectedCategory: String?, trackerCategoryStorage: TrackerCategoryStoring, trackerCategoryProvider: TrackerCategoryProvider) {
        self.selectedCategory = selectedCategory
        self.trackerCategoryStorage = trackerCategoryStorage
        self.trackerCategoryProvider = trackerCategoryProvider
        
        
    }
    
    func getCategoryTitles() -> [String] {
        categoryTitles
    }
    
    func getSelectedCategory() -> String? {
        selectedCategory
    }
    
    func didSelectCategory(at indexPath: IndexPath) {
        <#code#>
    }
    
    func willDismissViewController() {
        
    }
}
