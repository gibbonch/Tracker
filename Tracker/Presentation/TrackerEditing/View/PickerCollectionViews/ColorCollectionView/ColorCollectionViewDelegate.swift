//
//  ColorCollectionViewDelegate.swift
//  Tracker
//
//  Created by Александр Торопов on 13.12.2024.
//

import UIKit

final class ColorCollectionViewDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    private weak var viewModel: TrackerEditingViewModel?
    
    // MARK: - Initializer
    
    init(viewModel: TrackerEditingViewModel?) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let colorCell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell,
              let color = colorCell.color else { return }
        viewModel?.color = color
        collectionView.reloadData()
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerLine = 6
        let horizontalInsets = 18.0
        let interItemSpacing = 5.0
        let availableWidth = collectionView.frame.width - interItemSpacing * (CGFloat(itemsPerLine) - 1) - 2 * horizontalInsets
        let width = availableWidth / CGFloat(itemsPerLine)
        let height = width
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 18, bottom: 24, right: 18)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = collectionView.frame.width
        let height = 18.0
        return CGSize(width: width, height: height)
    }
}

