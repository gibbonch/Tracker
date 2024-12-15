//
//  TrackersViewModel.swift
//  Tracker
//
//  Created by Александр Торопов on 07.12.2024.
//

import Foundation

protocol TrackersViewModel {
    var visibleCategories: [TrackerCategory] { get }
    
    // ViewController
    func updateDate(_ date: Date)
    func updateSearchText(_ searchText: String)
    func updateFilter(_ filter: TrackerFilter)
    func viewWillAppear()
    
    // CollectionViewDelegate
    func deleteTracker(at indexPath: IndexPath)
    func pinTracker(at: IndexPath)
    func unpinTracker(at: IndexPath)
    func createTrackerEditingViewModel(at indexPath: IndexPath) -> any TrackerEditingViewModel
    
    // DataSource
    func trackerCellViewModel(tracker: Tracker) -> any TrackerCellViewModel
}
