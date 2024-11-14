//
//  TrackersDataSourceProvider.swift
//  Tracker
//
//  Created by Александр Торопов on 09.11.2024.
//

import UIKit

protocol TrackersDataSourceProviderDelegate: AnyObject {
    func trackersDataSourceProvider(_ dataSourceProvider: TrackerDataSourceProvider, didUpdateItemCount count: Int)
}

final class TrackerDataSourceProvider {
    
    // MARK: - Type Aliases
    
    private typealias DataSource = UICollectionViewDiffableDataSource<TrackerCategory, Tracker>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<TrackerCategory, Tracker>
    
    // MARK: - Properties
    
    weak var delegate: TrackersDataSourceProviderDelegate?
    weak var trackersViewModel: TrackersViewModel?
    
    private var date: Date?
    
    private let collectionView: UICollectionView
    private var dataSource: DataSource?
    
    // MARK: - Initializer
    
    init(collectionView: UICollectionView, delegate: TrackersDataSourceProviderDelegate?) {
        self.collectionView = collectionView
        self.delegate = delegate
        date = Date()
        setupDataSource()
    }
    
    // MARK: - Methods
    
    func applySnapshot(for categories: [TrackerCategory]?, date: Date) {
        self.date = date
        
        guard let categories else { return }
        
        var snapshot = Snapshot()
        for category in categories {
            snapshot.appendSections([category])
            snapshot.appendItems(category.trackers, toSection: category)
        }

        delegate?.trackersDataSourceProvider(self, didUpdateItemCount: snapshot.numberOfItems)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func setupDataSource() {
        dataSource = DataSource(collectionView: collectionView) { [weak self] (collectionView, indexPath, tracker) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCollectionViewCell.identifier, for: indexPath)
            guard let trackerCell = cell as? TrackerCollectionViewCell, let date = self?.date else { return cell }
            
            let isChecked = self?.trackersViewModel?.isTrackerCompleted(tracker.id, on: date) ?? false
            
            trackerCell.configure(with: tracker, isChecked: isChecked) { [weak self] in
                guard let self else { return }
                
                if isChecked {
                    self.trackersViewModel?.uncheckTracker(tracker.id, on: date)
                } else {
                    self.trackersViewModel?.checkTracker(tracker.id, on: date)
                }
            }
            
            return trackerCell
        }
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else {
                return UICollectionReusableView()
            }
            
            let snapshot = self.dataSource?.snapshot()
            guard let section = snapshot?.sectionIdentifiers[indexPath.section] else {
                return UICollectionReusableView()
            }
            
            let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TrackerHeader.identifier, for: indexPath)
            let headerView = supplementaryView as? TrackerHeader
            headerView?.categoryLabel.text = section.title
            return headerView ?? UICollectionReusableView()
        }
    }
    
}

