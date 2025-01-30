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

enum TrackerFilter: CaseIterable {
    case all, today, completed, active
    
    var description: String {
        switch self {
        case .all:
            return NSLocalizedString("filter.all", comment: "All trackers filter")
        case .today:
            return NSLocalizedString("filter.today", comment: "Trackers for today filter")
        case .completed:
            return NSLocalizedString("filter.completed", comment: "Completed trackers filter")
        case .active:
            return NSLocalizedString("filter.active", comment: "Active trackers filter")
        }
    }
}
