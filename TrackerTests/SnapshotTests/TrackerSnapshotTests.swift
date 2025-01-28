//
//  TrackerViewControllerTests.swift
//  TrackerTests
//
//  Created by Александр Торопов on 28.01.2025.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerSnapshotTests: XCTestCase {
    
    func testTrackerViewControllerLightMode() {
        let vc = TrackersViewController(viewModel: TestTrackersViewModel())
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .light)))
    }
    
    func testTrackerViewControllerDarkMode() {
        let vc = TrackersViewController(viewModel: TestTrackersViewModel())
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }
    
    func testTrackerEditingViewControllerLightMode() {
        let vc = TrackerEditingViewController(title: "Title", viewModel: TestTrackerEditingViewModel())
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .light)))
    }
    
    func testTrackerEditingViewControllerDarkMode() {
        let vc = TrackerEditingViewController(title: "Title", viewModel: TestTrackerEditingViewModel())
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }
    
    func testFiltersViewControllerLightMode() {
        let vc = FiltersViewController(viewModel: TestFiltersViewModel())
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .light)))
    }
    
    func testFiltersViewControllerDarkMode() {
        let vc = FiltersViewController(viewModel: TestFiltersViewModel())
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }
    
    func testTrackerCategoriesViewControllerLightMode() {
        let vc = TrackerCategoriesViewController(viewModel: TestTrackerCategoriesViewModel())
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .light)))
    }
    
    func testTrackerCategoriesViewControllerDarkMode() {
        let vc = TrackerCategoriesViewController(viewModel: TestTrackerCategoriesViewModel())
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }
    
    func testTrackerScheduleViewControllerLightMode() {
        let vc = TrackerScheduleViewController(viewModel: TestTrackerScheduleViewModel())
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .light)))
    }
    
    func testTrackerScheduleViewControllerDarkMode() {
        let vc = TrackerScheduleViewController(viewModel: TestTrackerScheduleViewModel())
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }
    
    func testCategoryEditingViewControllerLightMode() {
        let vc = CategoryEditingViewController(viewModel: TestCategoryEditingViewModel())
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .light)))
    }
    
    func testCategoryEditingViewControllerDarkMode() {
        let vc = CategoryEditingViewController(viewModel: TestCategoryEditingViewModel())
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }
    
}
