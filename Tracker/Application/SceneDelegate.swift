//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Александр Торопов on 06.11.2024.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: windowScene)
        
        let trackerStore = TrackerStore()
        let trackersViewModel = DefaultTrackersViewModel(trackerStore: trackerStore,trackerProvider: TrackerProvider(store: trackerStore))
        let trackersViewController = TrackersViewController(viewModel: trackersViewModel)
        let statisticsViewController = StatisticsViewController()
        window?.rootViewController = MainTabBarController(viewControllers: [trackersViewController, statisticsViewController])
        
        window?.makeKeyAndVisible()
    }
}

