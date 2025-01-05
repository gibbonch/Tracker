//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Александр Торопов on 07.11.2024.
//

import Foundation

// MARK: - TrackerCategory

struct TrackerCategory: Hashable {
    let title: String
    let trackers: [Tracker]
    
    init(title: String, trackers: [Tracker]) {
        self.title = title
        self.trackers = trackers
    }
}
