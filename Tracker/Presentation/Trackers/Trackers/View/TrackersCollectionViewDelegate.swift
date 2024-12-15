//
//  TrackersCollectionViewDelegate.swift
//  Tracker
//
//  Created by Александр Торопов on 03.12.2024.
//

import UIKit

final class TrackersCollectionViewDelegate: NSObject, UICollectionViewDelegate {
    
    // MARK: - Properties
    
    weak var parentViewController: UIViewController?
    
    var layoutConfiguration: CollectionViewLayoutConfiguration?
    private let viewModel: TrackersViewModel
    
    // MARK: - Initializer
    
    init(viewModel: TrackersViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - UICollectionViewDelegate
    
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
            actionProvider: { [weak self] _ in
                if cell.viewModel?.trackerCellState.isPinned == true {
                    return self?.prepareContextMenuForPinnedTracker(cell: cell, indexPath: indexPath)
                } else {
                    return self?.prepareContextMenuForUnpinnedTracker(cell: cell, indexPath: indexPath)
                }
            }
        )
    }
    
    private func editTracker(at indexPath: IndexPath) {
        let trackerEditingViewController = TrackerEditingViewController(viewModel: viewModel.createTrackerEditingViewModel(at: indexPath))
        parentViewController?.present(trackerEditingViewController, animated: true)
    }
    
    private func prepareContextMenuForUnpinnedTracker(cell: TrackerCollectionViewCell, indexPath: IndexPath) -> UIMenu {
        UIMenu(children: [
            UIAction(title: "Закрепить") { [weak self] _ in
                self?.viewModel.pinTracker(at: indexPath)
            },
            UIAction(title: "Редактировать") { [weak self] _ in
                self?.editTracker(at: indexPath)
            },
            UIAction(title: "Удалить", attributes: .destructive) { [weak self] _ in
                self?.viewModel.deleteTracker(at: indexPath)
            },
        ])
    }
    
    private func prepareContextMenuForPinnedTracker(cell: TrackerCollectionViewCell, indexPath: IndexPath) -> UIMenu {
        UIMenu(children: [
            UIAction(title: "Открепить") { [weak self] _ in
                self?.viewModel.unpinTracker(at: indexPath)
            },
            UIAction(title: "Редактировать") { [weak self] _ in
                self?.editTracker(at: indexPath)
            },
            UIAction(title: "Удалить", attributes: .destructive) { [weak self] _ in
                self?.viewModel.deleteTracker(at: indexPath)
            },
        ])
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TrackersCollectionViewDelegate: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        layoutConfiguration?.itemSize ?? CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        layoutConfiguration?.minimumLineSpacing ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        layoutConfiguration?.minimumInteritemSpacing ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.width, height: layoutConfiguration?.headerHeight ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        layoutConfiguration?.sectionInsets ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
