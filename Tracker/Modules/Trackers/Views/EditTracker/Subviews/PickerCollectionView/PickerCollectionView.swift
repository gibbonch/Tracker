//
//  PickerCollectionView.swift
//  Tracker
//
//  Created by Александр Торопов on 12.11.2024.
//

import UIKit

protocol PickerCollectionViewCellProtocol {
    func applySelectAppearance()
    func applyDeselectAppearance()
}

protocol PickerCollectionViewDelegate: AnyObject {
    func pickerCollectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
}

final class PickerCollectionView<T: UICollectionViewCell>: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    private weak var pickerCollectionViewDelegate: PickerCollectionViewDelegate?
    
    private let colors = (1...18).map { UIColor(named: "Selection\($0)") }
    private let emojis = ["🙂", "😻", "🌺", "🐶", "❤️", "😱",
                          "😇", "😡", "🥶", "🤔", "🙌", "🍔",
                          "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]
    
    private let cellsPerLine = 6
    private let itemSpacing = 5.0
    private let rowSpacing = 0.0
    private let horizontalInset = 2.0
    private let verticalInset = 24.0
    
    // MARK: - Initializer
    init(pickerCollectionViewDelegate: PickerCollectionViewDelegate? = nil) {
        self.pickerCollectionViewDelegate = pickerCollectionViewDelegate
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        setupCollectionView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func setupCollectionView() {
        register(T.self, forCellWithReuseIdentifier: T.identifier)
        dataSource = self
        delegate = self
        isScrollEnabled = false
        allowsMultipleSelection = false
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if T.self == ColorCollectionViewCell.self {
            return colors.count
        } else if T.self == EmojiCollectionViewCell.self {
            return emojis.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath)
        
        if let colorCell = cell as? ColorCollectionViewCell {
            colorCell.colorView.backgroundColor = colors[indexPath.row]
        } else if let emojiCell = cell as? EmojiCollectionViewCell {
            emojiCell.emojiLabel.text = emojis[indexPath.row]
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? PickerCollectionViewCellProtocol
        cell?.applySelectAppearance()
        pickerCollectionViewDelegate?.pickerCollectionView(collectionView, didSelectItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? PickerCollectionViewCellProtocol
        cell?.applyDeselectAppearance()
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - CGFloat(cellsPerLine - 1) * itemSpacing - horizontalInset * 2
        let cellWidth = availableWidth / CGFloat(cellsPerLine)
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        itemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        rowSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
    }
}
