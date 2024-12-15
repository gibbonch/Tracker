//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Александр Торопов on 06.11.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let appDIContainer = AppDIContainer.shared
        
        let trackersViewController = appDIContainer.createTrackersViewController()
        let statisticsViewController = appDIContainer.createStatisticsViewController()
        window?.rootViewController = MainTabBarController(viewControllers: [trackersViewController, statisticsViewController])
        
        window?.makeKeyAndVisible()
    }
}

