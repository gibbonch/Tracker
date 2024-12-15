//
//  DefaultTrackerCreationViewModel.swift
//  Tracker
//
//  Created by Александр Торопов on 09.12.2024.
//

import Foundation

final class DefaultTrackerCreationViewModel: TrackerCreationViewModel {
    
    // MARK: - Properties
    
    weak var delegate: DefaultTrackerCreationViewModelDelegate?
    private var trackerType: TrackerType?
    
    // MARK: - Public Methods
    
    func updateTrackerType(_ trackerType: TrackerType) {
        self.trackerType = trackerType
        delegate?.didUpdateTrackerType()
    }
    
    func createTrackerEditingViewModel() -> (any TrackerEditingViewModel)? {
        guard let trackerType else { return nil }
        let storage = UserDefaultsStorage()
        return DefaultTrackerEditingViewModel(trackerType: trackerType, storage: storage)
    }
}
