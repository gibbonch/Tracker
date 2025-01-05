//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Александр Торопов on 06.11.2024.
//

import UIKit

final class StatisticsViewController: UIViewController {
    
    // MARK: - Subviews
    
    private lazy var placeholderView: PlaceholderView = {
        let placeholder = PlaceholderView()
        placeholder.setImage(.statisticsPlaceholder)
        placeholder.setTitle("Анализировать пока нечего")
        placeholder.translatesAutoresizingMaskIntoConstraints = false
        return placeholder
    }()
    
    // MARK: - Initializer
    
    init() {
        super.init(nibName: nil, bundle: nil)
        tabBarItem = UITabBarItem(title: "Статистка", image: .stats, selectedImage: nil)
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
        setConstraints()
    }
    
    // MARK: - Private Methods
    
    private func setupNavigationBar() {
        title = "Статистика"
    }

    private func setupView() {
        view.backgroundColor = .whiteApp
        view.addSubview(placeholderView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            placeholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}
