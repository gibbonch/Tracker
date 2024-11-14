//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Александр Торопов on 07.11.2024.
//

import Foundation

struct TrackerCategory: Hashable, Codable {
    var id = UUID()
    let title: String
    var trackers: [Tracker]
}
