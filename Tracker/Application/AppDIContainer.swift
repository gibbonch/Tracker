//
//  AppDIContainer.swift
//  Tracker
//
//  Created by Александр Торопов on 08.12.2024.
//

import UIKit

final class AppDIContainer {
    static let shared = AppDIContainer()
    
    private init() { }
    
    func createTrackersViewController() -> UIViewController {
        let storage = UserDefaultsStorage()
        let trackersViewModel = DefaultTrackersViewModel(storage: storage)
        return TrackersViewController(viewModel: trackersViewModel)
    }
    
    func createStatisticsViewController() -> UIViewController {
        return StatisticsViewController()
    }
    
    func createTrackerCreationViewController() -> UIViewController {
        let createTrackerViewModel = DefaultTrackerCreationViewModel()
        return TrackerCreationViewController(viewModel: createTrackerViewModel)
    }
}
