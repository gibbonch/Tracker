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
        
        let recordProvider = TrackerRecordProvider()
        let service = StatisticsService(trackerRecordProvider: recordProvider, trackerStore: trackerStore)
        let statisticsViewController = StatisticsViewController(statisticsService: service)
        
        let mainTabBarController = MainTabBarController(viewControllers: [trackersViewController, statisticsViewController])
        window?.rootViewController = mainTabBarController
    }
    
    // MARK: - Onboarding Flow
    
    func switchToOnboarding() {
        let switchToTrackersCompletion: () -> Void = { [weak self] in
            UserDefaults.standard.set(true, forKey: Constants.didPresentOnboarding)
            self?.switchToTrackers()
        }
        
        let onboardingViewController = OnboardingViewController(completion: switchToTrackersCompletion)
        
        window?.rootViewController = onboardingViewController
    }
    
}
