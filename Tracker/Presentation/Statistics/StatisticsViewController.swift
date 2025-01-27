//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Александр Торопов on 06.11.2024.
//

import UIKit

final class StatisticsViewController: UIViewController {
    
    // MARK: - Properties
    
    private let statisticsService: StatisticsService
    private let cellHeight: CGFloat = 90
    
    // MARK: - Subviews
    
    private lazy var placeholderView: PlaceholderView = {
        let placeholder = PlaceholderView()
        placeholder.setImage(.statisticsPlaceholder)
        placeholder.setTitle(NSLocalizedString("emptyStatsState.title", comment: "Text displayed on placeholder"))
        placeholder.translatesAutoresizingMaskIntoConstraints = false
        return placeholder
    }()
    
    private lazy var statisticsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.bounds.width - 32.0, height: cellHeight)
        layout.minimumLineSpacing = 12.0
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.dataSource = self
        collection.register(StatisticsCell.self, forCellWithReuseIdentifier: StatisticsCell.identifier)
        collection.contentInset = UIEdgeInsets(top: 70, left: 0, bottom: 24, right: 0)
        collection.backgroundColor = .clear
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    // MARK: - Initializer
    
    init(statisticsService: StatisticsService) {
        self.statisticsService = statisticsService
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
        setupBinding()
        setupView()
        setupLayout()
    }
    
    // MARK: - Private Methods
    
    private func setupNavigationBar() {
        title = NSLocalizedString("statistics", comment: "Statistics title")
    }
    
    private func setupBinding() {
        statisticsService.onStatisticsUpdate = { [weak self] result in
            switch result {
            case .success:
                self?.updateViewState()
                self?.statisticsCollectionView.reloadData()
            case .failure:
                self?.updateViewState()
            }
        }
    }
    
    private func setupView() {
        view.backgroundColor = .whiteApp
        view.addSubview(placeholderView)
        view.addSubview(statisticsCollectionView)
        updateViewState()
    }
    
    private func updateViewState() {
        let hasStatistics = statisticsService.statistics.map { $0.value }.reduce(0, +) != 0
        placeholderView.isHidden = hasStatistics
        statisticsCollectionView.isHidden = !hasStatistics
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            placeholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            statisticsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            statisticsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statisticsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            statisticsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

// MARK: - UICollectionViewDataSource

extension StatisticsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        statisticsService.statisticsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let statistic = statisticsService.statistics[indexPath.row]
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StatisticsCell.identifier, for: indexPath) as? StatisticsCell else {
            return UICollectionViewCell()
        }
        
        switch statistic {
        case .bestPeriod(let days):
            cell.setupCell(title: NSLocalizedString("statistics.bestPeriod", comment: "Best Period"), value: days)
        case .perfectDays(let days):
            cell.setupCell(title: NSLocalizedString("statistics.perfectDays", comment: "Perfect Days"), value: days)
        case .completedTrackers(let count):
            cell.setupCell(title: NSLocalizedString("statistics.completedTrackers", comment: "Completed Trackers"), value: count)
        case .averageValue(let points):
            cell.setupCell(title: NSLocalizedString("statistics.averageValue", comment: "Average Value"), value: points)
        }
        
        return cell
    }
}
