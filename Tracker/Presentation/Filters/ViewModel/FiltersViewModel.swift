//
//  FiltersViewModel.swift
//  Tracker
//
//  Created by Александр Торопов on 25.01.2025.
//

import Foundation

protocol FiltersViewModel: AnyObject {
    var onChangeSelectedFilter: Binding<TrackerFilter>? { get set }
    func filtersCount() -> Int
    func filterDescriptionForCell(at indexPath: IndexPath) -> String
    func isSelectedCell(at indexPath: IndexPath) -> Bool
    func didSelectCell(at indexPath: IndexPath)
}

final class DefaultFiltersViewModel: FiltersViewModel {
    
    var onChangeSelectedFilter: Binding<TrackerFilter>?
    
    private let filters = TrackerFilter.allCases
    private var selectedFilter: TrackerFilter
    
    init(filter: TrackerFilter) {
        selectedFilter = filter
    }
    
    func filtersCount() -> Int {
        filters.count
    }
    
    func filterDescriptionForCell(at indexPath: IndexPath) -> String {
        filters[indexPath.row].description
    }
    
    func isSelectedCell(at indexPath: IndexPath) -> Bool {
        selectedFilter == filters[indexPath.row]
    }
    
    func didSelectCell(at indexPath: IndexPath) {
        selectedFilter = filters[indexPath.row]
        onChangeSelectedFilter?(selectedFilter)
    }
}
