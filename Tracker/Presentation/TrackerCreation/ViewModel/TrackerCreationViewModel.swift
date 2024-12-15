//
//  TrackerCreationViewModel.swift
//  Tracker
//
//  Created by Александр Торопов on 09.12.2024.
//

import Foundation

protocol TrackerCreationViewModel {
    func updateTrackerType(_ trackerType: TrackerType)
    func createTrackerEditingViewModel() -> (any TrackerEditingViewModel)?
}
