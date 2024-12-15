//
//  TrackersDataSourceManager.swift
//  Tracker
//
//  Created by Александр Торопов on 03.12.2024.
//

import UIKit

final class TrackersDataSourceManager {
    
    // MARK: - TrackerCategorySection
    
    private enum TrackerCategorySection: Hashable {
        case main(title: String)
    }
    
    // MARK: - Type Aliases
    
    private typealias DataSource = UICollectionViewDiffableDataSource<TrackerCategorySection, Tracker>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<TrackerCategorySection, Tracker>
    
    // MARK: - Properties
    
    weak var delegate: TrackersDataSourceManagerDelegate?
    
    private let viewModel: TrackersViewModel
    private let collectionView: UICollectionView
    private var dataSource: DataSource?
    
    // MARK: - Initializer
    
    init(collectionView: UICollectionView, viewModel: TrackersViewModel) {
        self.collectionView = collectionView
        self.viewModel = viewModel
        
        guard let viewModel = viewModel as? DefaultTrackersViewModel else { return }
        viewModel.delegate = self
        
        registerReusableViews()
        setupDataSource()
        applySnapshot()
    }
    
    // MARK: - Private Methods
    
    private func registerReusableViews() {
        collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: TrackerCollectionViewCell.identifier)
        collectionView.register(TrackerHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackerHeaderView.identifier)
    }
    
    private func setupDataSource() {
        dataSource = DataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, tracker in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCollectionViewCell.identifier, for: indexPath)
            guard let trackerCell = cell as? TrackerCollectionViewCell else {
                return cell
            }
            
            let trackerCellViewModel = self?.viewModel.trackerCellViewModel(tracker: tracker)
            trackerCell.viewModel = trackerCellViewModel
            guard let defaultTrackerCellViewModel = trackerCellViewModel as? DefaultTrackerCellViewModel else { return cell }
            defaultTrackerCellViewModel.delegate = trackerCell
            
            return trackerCell
        }
        
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: TrackerHeaderView.identifier,
                for: indexPath
            )
            
            guard kind == UICollectionView.elementKindSectionHeader,
                  let headerView = supplementaryView as? TrackerHeaderView,
                  let dataSource = self?.dataSource
            else { return supplementaryView }
            
            let snapshot = dataSource.snapshot()
            let category = snapshot.sectionIdentifiers[indexPath.section]
            
            switch category {
            case .main(let title):
                headerView.setupHeaderView(category: title)
            }
            
            return headerView
        }
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        guard let dataSource else { return }
        
        var snapshot = Snapshot()
        let sections = viewModel.visibleCategories.map { TrackerCategorySection.main(title: $0.title) }
        snapshot.appendSections(sections)

        for category in viewModel.visibleCategories {
            let items = category.trackers
            snapshot.appendItems(items, toSection: TrackerCategorySection.main(title: category.title))
        }
        
        dataSource.apply(snapshot, animatingDifferences: true) { [weak self] in
            self?.delegate?.didApplySnapshot(itemCount: snapshot.numberOfItems)
        }
    }
}

// MARK: - TrackersViewModelDelegate

extension TrackersDataSourceManager: DefaultTrackersViewModelDelegate {
    func didUpdateVisibleCategories() {
        applySnapshot()
    }
}
