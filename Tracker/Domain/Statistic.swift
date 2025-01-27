//
//  Statistic.swift
//  Tracker
//
//  Created by Александр Торопов on 26.01.2025.
//

import Foundation

enum Statistic {
    case bestPeriod(days: Int)
    case perfectDays(days: Int)
    case completedTrackers(count: Int)
    case averageValue(points: Int)

    var title: String {
        switch self {
        case .bestPeriod:
            return NSLocalizedString("Best Period", comment: "")
        case .perfectDays:
            return NSLocalizedString("Perfect Days", comment: "")
        case .completedTrackers:
            return NSLocalizedString("Completed Trackers", comment: "")
        case .averageValue:
            return NSLocalizedString("Average Value", comment: "")
        }
    }

    var value: Int {
        switch self {
        case .bestPeriod(let days):
            return days
        case .perfectDays(let days):
            return days
        case .completedTrackers(let count):
            return count
        case .averageValue(let points):
            return points
        }
    }
}
