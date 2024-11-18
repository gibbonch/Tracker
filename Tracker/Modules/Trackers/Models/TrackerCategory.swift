//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Александр Торопов on 07.11.2024.
//

import Foundation

struct TrackerCategory: Hashable, Codable {
    let id: UUID
    let title: String
    let trackers: [Tracker]
    
    init(id: UUID = UUID(), title: String, trackers: [Tracker]) {
        self.id = id
        self.title = title
        self.trackers = trackers
    }
}
