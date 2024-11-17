//
//  TrackersDataSourceProvider.swift
//  Tracker
//
//  Created by Александр Торопов on 09.11.2024.
//

import UIKit

protocol TrackersDataSourceProviderDelegate: AnyObject {
    func didUpdateItemCount(to count: Int)
    func isTrackerCompleted(for trackerId: UUID, on date: Date) -> Bool
}

final class TrackerDataSourceProvider {
    
    // MARK: - Type Aliases
    private typealias DataSource = UICollectionViewDiffableDataSource<TrackerCategory, Tracker>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<TrackerCategory, Tracker>
    
    // MARK: - Properties
    weak var delegate: TrackersDataSourceProviderDelegate?
    
    private var currentDate: Date?
    private let collectionView: UICollectionView
    private var dataSource: DataSource?
    
    // MARK: - Initializer
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        currentDate = Date()
        setupDataSource()
    }
    
    // MARK: - Public Methods
    func applySnapshot(for categories: [TrackerCategory]?, date: Date) {
        currentDate = date
        guard let categories else { return }
        
        let snapshot = createSnapshot(for: categories)
        delegate?.didUpdateItemCount(to: snapshot.numberOfItems)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func tracker(for indexPath: IndexPath) -> Tracker? {
        let snapshot = dataSource?.snapshot()
        guard let section = snapshot?.sectionIdentifiers[indexPath.section] else { return nil }
        return snapshot?.itemIdentifiers(inSection: section)[indexPath.item]
    }
    
    // MARK: - Private Methods
    private func setupDataSource() {
        dataSource = DataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, tracker in
            self?.configureCell(collectionView, indexPath: indexPath, tracker: tracker)
        }
        
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            self?.configureSupplementaryView(collectionView, kind: kind, indexPath: indexPath)
        }
    }
    
    private func createSnapshot(for categories: [TrackerCategory]) -> Snapshot {
        var snapshot = Snapshot()
        for category in categories {
            snapshot.appendSections([category])
            snapshot.appendItems(category.trackers, toSection: category)
        }
        return snapshot
    }
    
    private func configureCell(_ collectionView: UICollectionView, indexPath: IndexPath, tracker: Tracker) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCollectionViewCell.identifier, for: indexPath)
        guard
            let trackerCell = cell as? TrackerCollectionViewCell,
            let date = currentDate,
            let isChecked = delegate?.isTrackerCompleted(for: tracker.id, on: date)
        else { return cell }
        
        trackerCell.delegate = delegate as? TrackerCollectionViewCellDelegate
        trackerCell.configure(with: tracker, isChecked: isChecked)
        trackerCell.checkButton.isUserInteractionEnabled = date <= Date()
        return trackerCell
    }
    
    private func configureSupplementaryView(_ collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let supplementaryView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TrackerHeader.identifier,
            for: indexPath
        )
        guard let headerView = supplementaryView as? TrackerHeader else {
            return UICollectionReusableView()
        }
        
        let snapshot = dataSource?.snapshot()
        let section = snapshot?.sectionIdentifiers[indexPath.section]
        headerView.categoryLabel.text = section?.title
        return headerView
    }
}
