//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Александр Торопов on 07.11.2024.
//

import Foundation

struct TrackerCategory {
    let id: UUID
    let title: String
    let trackers: [Tracker]
}
