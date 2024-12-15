//
//  TrackerCellState.swift
//  Tracker
//
//  Created by Александр Торопов on 07.12.2024.
//

import UIKit

struct TrackerCellState {
    let title: String
    let emoji: String
    let color: UIColor
    var isPinned: Bool
    var isEnabled: Bool
    var isCompleted: Bool
    
    var completionsCountText: String {
        "\(completionsCount) \(Utilities.dayWord(for: completionsCount))"
    }
    
    private var completionsCount: Int
    
    init(tracker: Tracker, completionsCount: Int, isCompleted: Bool, isEnabled: Bool, isPinned: Bool) {
        self.title = tracker.title
        self.emoji = tracker.emoji
        self.color = tracker.color
        self.completionsCount = completionsCount
        self.isCompleted = isCompleted
        self.isEnabled = isEnabled
        self.isPinned = isPinned
    }
    
    mutating func toggleCompletion() {
        isCompleted.toggle()
        completionsCount += isCompleted ? 1 : -1
    }
}
