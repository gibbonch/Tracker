//
//  TrackerEditingViewModel.swift
//  Tracker
//
//  Created by Александр Торопов on 09.12.2024.
//

import UIKit

// MARK: - TrackerEditingViewModel

protocol TrackerEditingViewModel: AnyObject {
    var applyButtonText: String { get }
    var completionsCount: Int? { get }
    var isApplyButtonEnabled: Bool { get }
    
    var trackerType: TrackerType { get }
    var title: String { get set }
    var emoji: String { get set }
    var color: UIColor { get set }
    var category: String? { get }
    var schedule: [Weekday] { get }
    
    func applyButtonDidTap()
    func createTrackerCategoriesViewModel(_ categoryTitle: String?) -> any TrackerCategoriesViewModel
    func createTrackerScheduleViewModel() -> any TrackerScheduleViewModel
    func presentWarningMessage()
}

// MARK: - DefaultTrackerEditingViewModelDelegate

protocol DefaultTrackerEditingViewModelDelegate: AnyObject {
    func didUpdateCategory()
    func didUpdateSchedule()
    func didUpdateApplyButtonState()
    func didTitleExchangeLimit()
}

// MARK: - DefaultTrackerEditingViewModel

final class DefaultTrackerEditingViewModel: TrackerEditingViewModel {
    
    // MARK: - Properties
    
    weak var delegate: DefaultTrackerEditingViewModelDelegate?
    
    let applyButtonText: String
    let completionsCount: Int?
    let trackerType: TrackerType
    
    private let isNewTracker: Bool
    private let originalCategory: String?
    private let trackerID: UUID?

    private(set) var isApplyButtonEnabled: Bool {
        didSet { delegate?.didUpdateApplyButtonState() }
    }
    
    var title: String {
        didSet { validateApplyButtonState() }
    }
    
    var emoji: String {
        didSet { validateApplyButtonState() }
    }
    
    var color: UIColor {
        didSet { validateApplyButtonState() }
    }
    
    private(set) var category: String? {
        didSet {
            delegate?.didUpdateCategory()
            validateApplyButtonState()
        }
    }
    
    private(set) var schedule: [Weekday] {
        didSet {
            delegate?.didUpdateSchedule()
            validateApplyButtonState()
        }
    }
    
    private let trackerStore: TrackerStoring
    
    // MARK: - Initializers
    
    init(trackerStore: TrackerStoring, tracker: Tracker, completionsCount: Int, categoryTitle: String) {
        self.trackerStore = trackerStore
        
        self.trackerType = tracker.type
        self.trackerID = tracker.id
        self.title = tracker.title
        self.category = categoryTitle
        self.originalCategory = categoryTitle
        self.schedule = tracker.schedule
        self.emoji = tracker.emoji
        self.color = tracker.color
        
        self.isNewTracker = false
        self.applyButtonText = NSLocalizedString("save", comment: "Save action text")
        self.isApplyButtonEnabled = true
        self.completionsCount = completionsCount
    }
    
    init(trackerStore: TrackerStoring, trackerType: TrackerType) {
        self.trackerStore = trackerStore
        
        self.trackerType = trackerType
        self.trackerID = nil
        self.title = ""
        self.category = ""
        self.schedule = []
        self.emoji = ""
        self.color = .clear

        self.isNewTracker = true
        self.applyButtonText = NSLocalizedString("create", comment: "Create action text")
        self.isApplyButtonEnabled = false
        self.completionsCount = nil
        self.schedule = trackerType == .regular ? [] : Weekday.allCases
        
        self.category = nil
        self.originalCategory = nil
    }
    
    // MARK: - Public Methods
    
    func applyButtonDidTap() {
        guard let category else {
            return
        }
        
        if isNewTracker {
            let newTracker = Tracker(type: trackerType, title: title, schedule: schedule, color: color, emoji: emoji)
            trackerStore.create(tracker: newTracker, in: category)
        } else {
            guard let trackerID else { return }
            let updatedTracker = Tracker(id: trackerID, type: trackerType, title: title, schedule: schedule, color: color, emoji: emoji)
            
            if let originalCategory, originalCategory != category {
                trackerStore.update(tracker: updatedTracker, from: originalCategory, to: category)
            } else {
                trackerStore.update(tracker: updatedTracker, in: category)
            }
        }
    }

    
    func createTrackerScheduleViewModel() -> any TrackerScheduleViewModel {
        let scheduleViewModel = DefaultTrackerScheduleViewModel(schedule: schedule)
        scheduleViewModel.delegate = self
        return scheduleViewModel
    }
    
    func createTrackerCategoriesViewModel(_ categoryTitle: String?) -> any TrackerCategoriesViewModel {
        let categoryStore = TrackerCategoryStore(coreDataStack: CoreDataStack.shared)
        let categoryProvider = TrackerCategoryProvider(store: categoryStore)
        let categoriesViewModel = DefaultTrackerCategoriesViewModel(selectedCategory: categoryTitle,
                                                                    categoryStore: categoryStore,
                                                                    categoryProvider: categoryProvider)
        
        categoriesViewModel.onChangeSelectedCategory = { [weak self] selectedCategory in
            self?.category = selectedCategory
        }
        
        return categoriesViewModel
    }
    
    func presentWarningMessage() {
        delegate?.didTitleExchangeLimit()
    }
    
    // MARK: - Private Methods
    
    private func validateApplyButtonState() {
        isApplyButtonEnabled = !title.isEmpty && category != nil && !schedule.isEmpty && !emoji.isEmpty && color != .clear
    }
}

// MARK: - DefaultTrackerScheduleViewModelDelegate

extension DefaultTrackerEditingViewModel: DefaultTrackerScheduleViewModelDelegate {
    func didEndScheduleEditing(updatedSchedule: [Weekday]) {
        schedule = updatedSchedule
    }
}

