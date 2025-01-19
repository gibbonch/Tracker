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
        let coreDataStack = CoreDataStack.shared
        let trackerStore = TrackerStore(coreDataStack: coreDataStack)
        let trackerProvider = TrackerProvider(context: coreDataStack.context)
        let trackersViewModel = DefaultTrackersViewModel(trackerStore: trackerStore, trackerProvider: trackerProvider)
        let trackersViewController = TrackersViewController(viewModel: trackersViewModel)
        
        let statisticsViewController = StatisticsViewController()
        
        let mainTabBarController = MainTabBarController(viewControllers: [trackersViewController, statisticsViewController])
        window?.rootViewController = mainTabBarController
    }
    
    // MARK: - Onboarding Flow
    
    func switchToOnboarding() {
        let onboardingViewController = OnboardingViewController()
        window?.rootViewController = onboardingViewController
    }
    
}
