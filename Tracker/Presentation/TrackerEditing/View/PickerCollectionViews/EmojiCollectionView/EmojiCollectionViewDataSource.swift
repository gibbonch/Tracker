//
//  EmojiCollectionViewDataSource.swift
//  Tracker
//
//  Created by Александр Торопов on 13.12.2024.
//

import UIKit

final class EmojiCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    // MARK: - Properties
    
    private weak var viewModel: TrackerEditingViewModel?
    private let emojis: [String]
    
    // MARK: - Initializer
    
    init(viewModel: TrackerEditingViewModel) {
        self.viewModel = viewModel
        self.emojis = Self.loadEmojis()
        super.init()
    }
    
    // MARK: - Public Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        emojis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCollectionViewCell.identifier, for: indexPath)
        guard let emojiCell = cell as? EmojiCollectionViewCell else { return cell}
        emojiCell.emoji = emojis[indexPath.row]
        
        if emojiCell.emoji == viewModel?.emoji {
            emojiCell.isSelected = true
            emojiCell.applySelectedAppearance()
        } else {
            emojiCell.applyDeselectedAppearance()
        }
        
        return emojiCell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: PickerHeaderReusableView.identifier,
            for: indexPath
        )
        
        guard let emojiHeaderView = headerView as? PickerHeaderReusableView,
              kind == UICollectionView.elementKindSectionHeader
        else { return UICollectionReusableView() }
        
        emojiHeaderView.textLabel.text = "Emoji"
        return emojiHeaderView
    }
    
    // MARK: - Private Methods
    
    private static func loadEmojis() -> [String] {
        guard let plist = Bundle.main.url(forResource: "Emojis", withExtension: "plist") else {
            print("Failed to locate Emojis.plist")
            return []
        }
        
        do {
            let data = try Data(contentsOf: plist)
            let serializedData = try PropertyListSerialization.propertyList(from: data, format: nil)
            return serializedData as? [String] ?? []
        } catch {
            print("Failed to load or parse Emojis.plist: \(error.localizedDescription)")
            return []
        }
    }
}
