//
//  ColorCollectionViewDataSource.swift
//  Tracker
//
//  Created by Александр Торопов on 13.12.2024.
//

import UIKit

final class ColorCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    // MARK: - Properties
    
    private weak var viewModel: TrackerEditingViewModel?
    private let colors = (1...18).map { UIColor(named: "Selection\($0)") }
    
    // MARK: - Initializer
    
    init(viewModel: TrackerEditingViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Public Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCollectionViewCell.identifier, for: indexPath)
        guard let colorCell = cell as? ColorCollectionViewCell else { return cell}
        colorCell.color = colors[indexPath.row]
        
        if colorCell.color?.hexString == viewModel?.color.hexString {
            colorCell.applySelectedAppearance()
        } else {
            colorCell.applyDeselectedAppearance()
        }
        
        return colorCell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: PickerHeaderReusableView.identifier,
            for: indexPath
        )
        
        guard let colorHeaderView = headerView as? PickerHeaderReusableView,
              kind == UICollectionView.elementKindSectionHeader
        else { return UICollectionReusableView() }
        
        colorHeaderView.textLabel.text = "Цвет"
        return colorHeaderView
    }
}
