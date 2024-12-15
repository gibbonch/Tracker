//
//  TrackerCellViewModel.swift
//  Tracker
//
//  Created by Александр Торопов on 07.12.2024.
//

import Foundation

protocol TrackerCellViewModel {
    var trackerCellState: TrackerCellState { get }
    func completeButtonDidTap()
}
