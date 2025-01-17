//
//  AppCoordinator.swift
//  Tracker
//
//  Created by Александр Торопов on 16.01.2025.
//

import UIKit

final class AppCoordinator {
    private let window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    // MARK: - Main Flow
    
    func switchToTrackers() {
        let trackerStore = TrackerStore()
        let trackersViewModel = DefaultTrackersViewModel(trackerStore: trackerStore,trackerProvider: TrackerProvider(store: trackerStore))
        let trackersViewController = TrackersViewController(viewModel: trackersViewModel)
        let statisticsViewController = StatisticsViewController()
        let mainTabBarController = MainTabBarController(viewControllers: [trackersViewController, statisticsViewController])
        window?.rootViewController = mainTabBarController
    }
    
    // MARK: - Onboarding Flow
    
    func switchToOnboarding() {
        let onboardingViewController = OnboardingViewController()
        window?.rootViewController = OnboardingViewController()
    }
    
}
