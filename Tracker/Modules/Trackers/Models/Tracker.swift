//
//  Tracker.swift
//  Tracker
//
//  Created by Александр Торопов on 07.11.2024.
//

import Foundation

struct Tracker {
    let id: UUID
    let type: TrackerType
    let title: String
    let colorID: Int
    let emoji: String
    let schdule: [Day]
}

enum TrackerType {
    case regular
    case single
}

enum Day: Int, CaseIterable {
    case monday = 1
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
}
