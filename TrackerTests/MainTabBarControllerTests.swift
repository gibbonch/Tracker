//
//  MainTabBarControllerTests.swift
//  TrackerTests
//
//  Created by Александр Торопов on 12.01.2025.
//

import XCTest
@testable import Tracker

final class MainTabBarControllerTests: XCTestCase {

    func testMainTabBarControllerInitialization() {
        // Given
        let viewController1 = UIViewController()
        viewController1.tabBarItem = UITabBarItem(title: "Trackers", image: nil, tag: 0)
        
        let viewController2 = UIViewController()
        viewController2.tabBarItem = UITabBarItem(title: "Statistics", image: nil, tag: 1)
        
        let viewControllers = [viewController1, viewController2]
        
        // When
        let tabBarController = MainTabBarController(viewControllers: viewControllers)
        
        // Then
        
        guard let viewControllers = tabBarController.viewControllers?.compactMap({ ($0 as? UINavigationController)?.topViewController }) else {
            return
        }
        
        XCTAssertEqual(viewControllers.count, 2)
        XCTAssertTrue((viewControllers.contains(where: { $0 == viewController1 })))
        XCTAssertTrue((viewControllers.contains(where: { $0 == viewController2 })))
        XCTAssertEqual(viewControllers.first?.tabBarItem.title, "Trackers")
        XCTAssertEqual(tabBarController.tabBar.layer.borderWidth, 1.25)
        XCTAssertEqual(tabBarController.tabBar.layer.borderColor, UIColor.lightGrayApp.cgColor)
    }
}

