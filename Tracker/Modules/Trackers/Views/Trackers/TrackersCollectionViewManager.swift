// TrackersDataSourceProvider.swift
// Tracker
//
// Created by Александр Торопов on 09.11.2024.
//

import UIKit

// MARK: - Protocol Definitions

protocol TrackersCollectionViewManagerDelegate: AnyObject {
    var selectedDate: Date { get }
    func didUpdateItemCount(to count: Int)
    func isTrackerCompleted(trackerId: UUID, on date: Date) -> Bool
    func didTapCheckButton(in cell: TrackerCollectionViewCell)
    func didDelete(tracker: Tracker)
}

// MARK: - TrackersCollectionViewManager

final class TrackersCollectionViewManager: NSObject {
    
    // MARK: Type Aliases
    
    private typealias DataSource = UICollectionViewDiffableDataSource<TrackerCategory, Tracker>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<TrackerCategory, Tracker>
    
    // MARK: - Properties
    
    weak var delegate: TrackersCollectionViewManagerDelegate?
    
    private let collectionView: UICollectionView
    private var dataSource: DataSource?
    
    // MARK: - Initializer
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        configureCollectionView()
        configureDataSource()
    }
    
    // MARK: - Public Methods
    
    func applySnapshot(for categories: [TrackerCategory]?, date: Date) {
        guard let categories = categories else { return }
        let cleanSnapshot = Snapshot()
        dataSource?.apply(cleanSnapshot)
        let snapshot = createSnapshot(for: categories)
        delegate?.didUpdateItemCount(to: snapshot.numberOfItems)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func tracker(for indexPath: IndexPath) -> Tracker? {
        guard let snapshot = dataSource?.snapshot() else { return nil }
        let section = snapshot.sectionIdentifiers[indexPath.section]
        return snapshot.itemIdentifiers(inSection: section)[indexPath.item]
    }
    
    // MARK: - Private Methods
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: TrackerCollectionViewCell.identifier)
        collectionView.register(TrackerHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackerHeader.identifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 24, left: 16, bottom: 24, right: 16)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureDataSource() {
        dataSource = DataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, tracker in
            self?.configureTrackerCell(collectionView, indexPath: indexPath, tracker: tracker)
        }
        
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            self?.configureSupplementaryView(collectionView, kind: kind, indexPath: indexPath)
        }
    }
    
    private func configureTrackerCell(_ collectionView: UICollectionView, indexPath: IndexPath, tracker: Tracker) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCollectionViewCell.identifier, for: indexPath)
        guard
            let trackerCell = cell as? TrackerCollectionViewCell,
            let date = delegate?.selectedDate,
            let isChecked = delegate?.isTrackerCompleted(trackerId: tracker.id, on: date)
        else { return cell }
        
        trackerCell.layer.cornerRadius = 16
        trackerCell.tracker = tracker
        trackerCell.checkButton.isChecked = isChecked
        trackerCell.checkButton.isUserInteractionEnabled = date <= Date()
        trackerCell.delegate = self
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
    
    private func createSnapshot(for categories: [TrackerCategory]) -> Snapshot {
        var snapshot = Snapshot()
        for category in categories {
            snapshot.appendSections([category])
            snapshot.appendItems(category.trackers, toSection: category)
        }
        return snapshot
    }
}

// MARK: - UICollectionViewDelegate

extension TrackersCollectionViewManager: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard let indexPath = indexPaths.first,
              let cell = collectionView.cellForItem(at: indexPath) as? TrackerCollectionViewCell else { return nil }
        
        return UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: {
                guard let previewView = cell.trackerCardView.snapshotView(afterScreenUpdates: true) else { return nil }
                
                let previewController = UIViewController()
                previewController.view.addSubview(previewView)
                
                previewController.preferredContentSize = cell.trackerCardView.bounds.size
                previewView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    previewView.leadingAnchor.constraint(equalTo: previewController.view.leadingAnchor),
                    previewView.trailingAnchor.constraint(equalTo: previewController.view.trailingAnchor),
                    previewView.topAnchor.constraint(equalTo: previewController.view.topAnchor),
                    previewView.bottomAnchor.constraint(equalTo: previewController.view.bottomAnchor),
                ])
                return previewController
            },
            actionProvider: { _ in
                UIMenu(children: [
                    UIAction(title: "Закрепить") { [weak self] _ in
                        self?.pinTracker(at: indexPath)
                    },
                    UIAction(title: "Редактировать") { [weak self] _ in
                        self?.editTracker(at: indexPath)
                    },
                    UIAction(title: "Удалить", attributes: .destructive) { [weak self] _ in
                        self?.deleteTracker(at: indexPath)
                    },
                ])
            }
        )
    }
    
    private func pinTracker(at indexPath: IndexPath) { }
    
    private func editTracker(at indexPath: IndexPath) { }
    
    private func deleteTracker(at indexPath: IndexPath) {
        guard let tracker = tracker(for: indexPath),
              var snapshot = dataSource?.snapshot() else { return }
        
        delegate?.didDelete(tracker: tracker)
        
        snapshot.deleteItems([tracker])
        dataSource?.apply(snapshot, animatingDifferences: true)
        
        let itemCount = snapshot.numberOfItems
        delegate?.didUpdateItemCount(to: itemCount)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TrackersCollectionViewManager: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellsPerLine = 2.0
        let interItemSpacing = 9.0
        let horizontalInsets = 16.0
        let availableWidth = collectionView.frame.width - CGFloat(interItemSpacing + horizontalInsets * 2)
        let cellWidth = availableWidth / cellsPerLine
        return CGSize(width: cellWidth, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 18)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
    }
}

// MARK: - TrackerCollectionViewCellDelegate

extension TrackersCollectionViewManager: TrackerCollectionViewCellDelegate {
    func didTapCheckButton(in cell: TrackerCollectionViewCell) {
        delegate?.didTapCheckButton(in: cell)
    }
}
