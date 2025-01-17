//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Александр Торопов on 06.11.2024.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: windowScene)
        appCoordinator = AppCoordinator(window: window)
        
        let didPresentOnboarding = UserDefaults.standard.bool(forKey: Constants.didPresentOnboarding)
        
        if didPresentOnboarding {
            appCoordinator?.switchToTrackers()
            
        } else {
            appCoordinator?.switchToOnboarding()
        }
        
        window?.makeKeyAndVisible()
    }
}

