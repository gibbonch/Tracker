//
//  TrackersCollectionViewDelegate.swift
//  Tracker
//
//  Created by Александр Торопов on 03.12.2024.
//

import UIKit

final class TrackersCollectionViewDelegate: NSObject, UICollectionViewDelegate {

    // MARK: - Properties

    private let viewModel: TrackersViewModel
    private let parentViewController: UIViewController
    
    // MARK: - Initializer

    init(viewModel: TrackersViewModel, parentViewController: UIViewController) {
        self.viewModel = viewModel
        self.parentViewController = parentViewController
        super.init()
    }
    
    // MARK: - Public Methods
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard let indexPath = indexPaths.first,
              let cell = collectionView.cellForItem(at: indexPath) as? TrackerCollectionViewCell else { return nil }

        return UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: { [weak self] in
                self?.createPreviewController(for: cell)
            },
            actionProvider: { [weak self] _ in
                guard let self else { return nil }
                let actions = createContextMenuActions(for: cell, at: indexPath)
                return UIMenu(children: actions)
            }
        )
    }

    // MARK: - Private Methods

    private func createPreviewController(for cell: TrackerCollectionViewCell) -> UIViewController? {
        guard let previewView = cell.previewView.snapshotView(afterScreenUpdates: true) else { return nil }

        let previewController = UIViewController()
        previewController.view.addSubview(previewView)

        previewController.preferredContentSize = cell.previewView.bounds.size
        previewView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            previewView.leadingAnchor.constraint(equalTo: previewController.view.leadingAnchor),
            previewView.trailingAnchor.constraint(equalTo: previewController.view.trailingAnchor),
            previewView.topAnchor.constraint(equalTo: previewController.view.topAnchor),
            previewView.bottomAnchor.constraint(equalTo: previewController.view.bottomAnchor)
        ])

        return previewController
    }

    private func createContextMenuActions(for cell: TrackerCollectionViewCell, at indexPath: IndexPath) -> [UIAction] {
        let isPinned = cell.isPinned

        let pinActionTitle = isPinned ? "Открепить" : "Закрепить"
        let pinAction = UIAction(title: pinActionTitle) { [weak self] _ in
            if isPinned {
                self?.viewModel.performUnpinAction(at: indexPath)
            } else {
                self?.viewModel.performPinAction(at: indexPath)
            }
        }

        let editAction = UIAction(title: "Редактировать") { [weak self] _ in
            self?.editTracker(at: indexPath, cell: cell)
        }

        let deleteAction = UIAction(title: "Удалить", attributes: .destructive) { [weak self] _ in
            self?.viewModel.performDeleteAction(at: indexPath)
        }

        return [pinAction, editAction, deleteAction]
    }

    private func editTracker(at indexPath: IndexPath, cell: TrackerCollectionViewCell) {
        let trackerEditingViewModel = viewModel.createTrackerEditingViewModel(at: indexPath, completionsCount: cell.completionsCount)
        let trackerEditingViewController = TrackerEditingViewController(viewModel: trackerEditingViewModel)
        parentViewController.present(trackerEditingViewController, animated: true)
    }
}
