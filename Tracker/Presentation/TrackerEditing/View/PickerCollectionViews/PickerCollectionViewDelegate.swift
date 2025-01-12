//
//  PickerCollectionViewDelegate.swift
//  Tracker
//
//  Created by Александр Торопов on 05.01.2025.
//

import UIKit

final class PickerCollectionViewDelegate: NSObject, UICollectionViewDelegate {
    
    // MARK: - Properties
    
    private weak var viewModel: TrackerEditingViewModel?
    
    // MARK: - Initializer
    
    init(viewModel: TrackerEditingViewModel?) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let emojiCell = collectionView.cellForItem(at: indexPath) as? EmojiCollectionViewCell,
           let emoji = emojiCell.emoji {
            viewModel?.emoji = emoji
            collectionView.reloadData()
        } else if let colorCell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell,
                  let color = colorCell.color {
            viewModel?.color = color
            collectionView.reloadData()
        }
    }
}
