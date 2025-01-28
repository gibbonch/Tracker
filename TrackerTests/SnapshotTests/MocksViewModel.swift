//
//  MockTrackersViewModel.swift
//  TrackerTests
//
//  Created by Александр Торопов on 28.01.2025.
//

import UIKit
@testable import Tracker

final class TestTrackersViewModel: TrackersViewModel {
    var onVisibleCategoriesChange: (([TrackerCategory], Bool) -> Void)?
    var onTodayFilterApply: (() -> Void)?
    var totalTrackersAmount: Int
    var filter: TrackerFilter
    
    init() { 
        totalTrackersAmount = 0
        filter = .all
    }
    
    func didUpdate(date: Date) { }
    func didUpdate(searchText: String) { }
    func didDeleteTracker(at indexPath: IndexPath) { }
    func didPinTracker(at indexPath: IndexPath) { }
    func didUnpinTracker(at indexPath: IndexPath) { }
    func createTrackerEditingViewModel(at indexPath: IndexPath) -> any TrackerEditingViewModel { TestTrackerEditingViewModel() }
    func createTrackerCellViewModel(at indexPath: IndexPath) -> any TrackerCellViewModel { TestTrackerCellViewModel() }
    func createFiltersViewModel() -> any FiltersViewModel { TestFiltersViewModel() }
}

final class TestTrackerEditingViewModel: TrackerEditingViewModel {
    var applyButtonText: String
    var completionsCount: Int?
    var isApplyButtonEnabled: Bool
    var trackerType: TrackerType
    var title: String
    var emoji: String
    var color: UIColor
    var category: String?
    var schedule: [Weekday]
    
    init() { 
        applyButtonText = ""
        isApplyButtonEnabled = false
        trackerType = .regular
        title = ""
        emoji = ""
        color = .white
        schedule = []
    }
    
    func applyButtonDidTap() { }
    func createTrackerCategoriesViewModel(_ categoryTitle: String?) -> any TrackerCategoriesViewModel { TestTrackerCategoriesViewModel() }
    func createTrackerScheduleViewModel() -> any TrackerScheduleViewModel { TestTrackerScheduleViewModel() }
    func presentWarningMessage() { }
}

final class TestTrackerCellViewModel: TrackerCellViewModel {
    var onDateUpdate: ((Bool, Bool) -> Void)?
    var onCompletionsCountChangeState: ((Bool, Int) -> Void)?
    var tracker: Tracker
    var isPinned: Bool
    
    init() { 
        tracker = Tracker(type: .regular, title: "", schedule: [], color: .blackApp, emoji: "")
        isPinned = false
    }
    
    func didCompleteTracker() { }
}

final class TestFiltersViewModel: FiltersViewModel {
    var onChangeSelectedFilter: Binding<TrackerFilter>?
    
    func filtersCount() -> Int { 0 }
    func filterDescriptionForCell(at indexPath: IndexPath) -> String { "" }
    func isSelectedCell(at indexPath: IndexPath) -> Bool { false }
    func didSelectCell(at indexPath: IndexPath) { }
}

final class TestTrackerCategoriesViewModel: TrackerCategoriesViewModel {
    var onChangeExistingCategories: Binding<(insertedIndices: [Int], deletedIndices: [Int])>?
    var onChangeSelectedCategory: Binding<String?>?
    var categoryTitles: [String]
    
    init() {
        categoryTitles = []
    }
    
    func isSelectedCategory(at indexPath: IndexPath) -> Bool { false }
    func didSelectCategory(at indexPath: IndexPath) { }
    func deleteCategory(at indexPath: IndexPath) { }
    func createCategoryEditingViewModel(indexPath: IndexPath?) -> any CategoryEditingViewModel { TestCategoryEditingViewModel() }
}

final class TestTrackerScheduleViewModel: TrackerScheduleViewModel {
    var schedule: [Weekday]
    
    init() {
        schedule = []
    }
    
    func didSelect(weekday: Weekday) { }
    func didEndScheduleEditing() { }
}

final class TestCategoryEditingViewModel: CategoryEditingViewModel {
    var headerTitle: String
    var title: String?
    var isCategoryCreationAllowed: Bool
    var onTitleChangeState: ((String) -> Void)?
    
    init() {
        headerTitle = ""
        title = ""
        isCategoryCreationAllowed = false
    }
    
    func titleDidChange(_ newTitle: String) { }
    func createCategory(_ completion: @escaping () -> Void) { }
}
