//
//  MainTabBarController.swift
//  Tracker
//
//  Created by Александр Торопов on 06.11.2024.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    // MARK: - Initializer
    
    init(viewControllers: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        setupTabBar(with: viewControllers)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func setupTabBar(with viewControllers: [UIViewController]) {
        tabBar.layer.borderWidth = 1.25
        tabBar.layer.borderColor = UIColor.lightGrayApp.cgColor
        
        self.viewControllers = viewControllers.map { viewController in
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.tabBarItem = viewController.tabBarItem
            navigationController.navigationBar.prefersLargeTitles = true
            return navigationController
        }
    }
}
