//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Александр Торопов on 06.11.2024.
//

import UIKit

final class StatisticsViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var placeHolderView: PlaceholderView = {
        let placeholderView = PlaceholderView(image: .statisticsPlaceholder, message: "Анализировать пока нечего")
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        return placeholderView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
    }
    
    // MARK: - Methods
    
    private func setupView() {
        view.backgroundColor = .whiteApp
        view.addSubview(placeHolderView)
        NSLayoutConstraint.activate([
            placeHolderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeHolderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
}
