//
//  TrackerQuery.swift
//  Tracker
//
//  Created by Александр Торопов on 02.12.2024.
//

import Foundation

// MARK: - TrackerQuery

struct TrackerQuery {
    let title: String
    let date: Date
    let filter: TrackerFilter
}

// MARK: - TrackerFilter

enum TrackerFilter {
    case all, today, completed, active
}
