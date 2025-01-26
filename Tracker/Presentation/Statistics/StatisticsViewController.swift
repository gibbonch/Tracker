//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Александр Торопов on 06.11.2024.
//

import UIKit

final class StatisticsViewController: UIViewController {
    
    let provider = TrackerRecordProvider()
    
    // MARK: - Subviews
    
    private lazy var placeholderView: PlaceholderView = {
        let placeholder = PlaceholderView()
        placeholder.setImage(.statisticsPlaceholder)
        placeholder.setTitle(NSLocalizedString("emptyStatsState.title", comment: "Text displayed on placeholder"))
        placeholder.translatesAutoresizingMaskIntoConstraints = false
        return placeholder
    }()
    
    // MARK: - Initializer
    
    init() {
        super.init(nibName: nil, bundle: nil)
        tabBarItem = UITabBarItem(title: NSLocalizedString("statistics", comment: "Statistics title"), image: .stats, selectedImage: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
        setupLayout()
        provider.performFetch()
    }
    
    // MARK: - Private Methods
    
    private func setupNavigationBar() {
        title = NSLocalizedString("statistics", comment: "Statistics title")
    }

    private func setupView() {
        view.backgroundColor = .whiteApp
        view.addSubview(placeholderView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            placeholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}
