//
//  TrackerCategoryStorage.swift
//  Tracker
//
//  Created by Александр Торопов on 14.12.2024.
//

import Foundation

protocol TrackerCategoryStorage {
    func fetchCategories(query: TrackerQuery) -> [TrackerCategory]
    func fetchCategoryTitles() -> [String]
    func create(category: TrackerCategory)
    func delete(category: TrackerCategory)
}
