//
//  MainTabBarController.swift
//  Tracker
//
//  Created by Александр Торопов on 06.11.2024.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    // MARK: - Methods
    
    private func setupTabBar() {
        let trackersViewController = TrackersViewController()
        trackersViewController.title = "Трекеры"
        let trackersNavigationController = UINavigationController(rootViewController: trackersViewController)
        trackersNavigationController.tabBarItem = UITabBarItem(title: "Трекеры", image: .trackers, selectedImage: nil)
        
        let statisticsViewController = StatisticsViewController()
        statisticsViewController.title = "Статистка"
        let statisticsNavigationController = UINavigationController(rootViewController: statisticsViewController)
        statisticsNavigationController.tabBarItem = UITabBarItem(title: "Статистка", image: .stats, selectedImage: nil)
        
        viewControllers = [trackersNavigationController, statisticsNavigationController]
    }
    
}
